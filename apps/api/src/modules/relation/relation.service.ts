import { Injectable } from "@nestjs/common";
import { randomBytes } from "crypto";
import { AppError } from "../../common/app-error";
import { DbService } from "../../infra/db.service";
import { BindDto } from "./dto/bind.dto";

type RelationRow = {
  id: string;
  status: string;
  bound_at: string;
  user_a_id: string;
  user_b_id: string;
};

type PartnerRow = {
  id: string;
  nickname: string;
};

type InvitePayload = {
  code: string;
  inviter_user_id: string;
  expires_at: string;
};

@Injectable()
export class RelationService {
  constructor(private readonly db: DbService) {}

  async createInviteCode(userId: string) {
    await this.assertNotBound(userId);
    await this.db.query(
      `UPDATE relation_invites
       SET status = 'expired', updated_at = NOW()
       WHERE inviter_user_id = $1
         AND status = 'active'`,
      [userId]
    );

    const expiresAt = new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString();
    const inviteCode = await this.createUniqueInviteCode(userId, expiresAt);

    return {
      inviteCode,
      expiresAt
    };
  }

  async bind(userId: string, dto: BindDto) {
    await this.assertNotBound(userId);
    const inviteResult = await this.db.query<InvitePayload>(
      `SELECT code, inviter_user_id, expires_at
       FROM relation_invites
       WHERE code = $1
         AND status = 'active'
       LIMIT 1`,
      [dto.inviteCode]
    );
    const payload = inviteResult.rows[0];

    if (!payload) {
      throw new AppError(
        "RELATION_400_INVITE_CODE_INVALID",
        "Invite code is invalid",
        400
      );
    }

    if (new Date(payload.expires_at).getTime() < Date.now()) {
      await this.db.query(
        `UPDATE relation_invites
         SET status = 'expired', updated_at = NOW()
         WHERE code = $1`,
        [dto.inviteCode]
      );
      throw new AppError(
        "RELATION_410_INVITE_CODE_EXPIRED",
        "Invite code is expired",
        410
      );
    }

    if (payload.inviter_user_id === userId) {
      throw new AppError(
        "RELATION_409_SELF_BIND_FORBIDDEN",
        "Cannot bind yourself",
        409
      );
    }

    await this.assertNotBound(payload.inviter_user_id);

    let inserted;
    try {
      inserted = await this.db.query<RelationRow>(
        `INSERT INTO relations (user_a_id, user_b_id, status, invite_code, invite_code_expires_at)
         VALUES ($1, $2, 'active', $3, $4)
         RETURNING id, status, bound_at, user_a_id, user_b_id`,
        [payload.inviter_user_id, userId, dto.inviteCode, payload.expires_at]
      );
    } catch (error: unknown) {
      const dbError = error as { code?: string; constraint?: string };
      if (dbError.code === "23505") {
        if (dbError.constraint === "uq_relations_pair_unique") {
          throw new AppError(
            "RELATION_500_REBIND_MIGRATION_REQUIRED",
            "Rebind policy migration is required",
            500
          );
        }
        throw new AppError("RELATION_409_ALREADY_BOUND", "Already bound", 409);
      }
      throw error;
    }

    await this.db.query(
      `UPDATE relation_invites
       SET status = 'consumed',
           consumed_by_user_id = $2,
           consumed_at = NOW(),
           updated_at = NOW()
       WHERE code = $1`,
      [dto.inviteCode, userId]
    );

    const relation = inserted.rows[0];
    const partner = await this.getPartner(relation.id, userId);

    return {
      relation: {
        relationId: relation.id,
        status: relation.status,
        boundAt: relation.bound_at,
        partner
      }
    };
  }

  async current(userId: string) {
    const relation = await this.getActiveRelation(userId);
    if (!relation) {
      throw new AppError("RELATION_404_NOT_BOUND", "Not bound", 404);
    }

    const partner = await this.getPartner(relation.id, userId);
    return {
      relation: {
        relationId: relation.id,
        status: relation.status,
        boundAt: relation.bound_at,
        partner
      }
    };
  }

  async latest(userId: string) {
    const relation = await this.getLatestRelation(userId);
    if (!relation) {
      throw new AppError("RELATION_404_NOT_BOUND", "Not bound", 404);
    }

    const partner = await this.getPartner(relation.id, userId);
    return {
      relation: {
        relationId: relation.id,
        status: relation.status,
        boundAt: relation.bound_at,
        partner
      }
    };
  }

  async unbind(userId: string) {
    const relation = await this.getActiveRelation(userId);
    if (!relation) {
      throw new AppError("RELATION_404_NOT_BOUND", "Not bound", 404);
    }

    await this.db.query(
      `UPDATE relations
       SET status = 'cancelled'
       WHERE id = $1`,
      [relation.id]
    );

    return {
      relation: {
        relationId: relation.id,
        status: "cancelled"
      }
    };
  }

  private async assertNotBound(userId: string) {
    const relation = await this.getActiveRelation(userId);
    if (relation) {
      throw new AppError("RELATION_409_ALREADY_BOUND", "Already bound", 409);
    }
  }

  private async getActiveRelation(userId: string) {
    const result = await this.db.query<RelationRow>(
      `SELECT id, status, bound_at, user_a_id, user_b_id
       FROM relations
       WHERE status = 'active'
         AND (user_a_id = $1 OR user_b_id = $1)
       LIMIT 1`,
      [userId]
    );
    return result.rows[0] || null;
  }

  private async getLatestRelation(userId: string) {
    const result = await this.db.query<RelationRow>(
      `SELECT id, status, bound_at, user_a_id, user_b_id
       FROM relations
       WHERE user_a_id = $1 OR user_b_id = $1
       ORDER BY bound_at DESC, updated_at DESC
       LIMIT 1`,
      [userId]
    );
    return result.rows[0] || null;
  }

  private async getPartner(relationId: string, userId: string) {
    const result = await this.db.query<PartnerRow>(
      `SELECT u.id, u.nickname
       FROM relations r
       JOIN users u ON (u.id = r.user_a_id OR u.id = r.user_b_id)
       WHERE r.id = $1
         AND u.id <> $2
       LIMIT 1`,
      [relationId, userId]
    );
    return result.rows[0];
  }

  private async createUniqueInviteCode(userId: string, expiresAt: string) {
    for (let i = 0; i < 5; i += 1) {
      const inviteCode = `CP-${randomBytes(3).toString("hex").toUpperCase()}`;
      try {
        await this.db.query(
          `INSERT INTO relation_invites (code, inviter_user_id, expires_at, status)
           VALUES ($1, $2, $3, 'active')`,
          [inviteCode, userId, expiresAt]
        );
        return inviteCode;
      } catch {
        // Retry on possible unique collision.
      }
    }
    throw new AppError("RELATION_400_INVITE_CODE_INVALID", "Failed to generate invite code", 500);
  }
}

