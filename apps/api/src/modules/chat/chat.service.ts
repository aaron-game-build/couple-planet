import { Injectable } from "@nestjs/common";
import { AppError } from "../../common/app-error";
import { DbService } from "../../infra/db.service";
import { MarkReadDto } from "./dto/mark-read.dto";
import { SendMessageDto } from "./dto/send-message.dto";

type RelationRow = {
  id: string;
  status: string;
};

type MessageRow = {
  id: string;
  client_msg_id: string;
  sender_id: string;
  content: string;
  status: string;
  created_at: string;
  read_at: string | null;
};

@Injectable()
export class ChatService {
  constructor(private readonly db: DbService) {}

  async listMessages(
    userId: string,
    cursor?: string,
    limit = 20,
    includeArchived = false
  ) {
    const relation = includeArchived
      ? await this.getReadableRelation(userId)
      : await this.getCurrentRelation(userId);
    const relationId = relation.id;
    const readOnly = relation.status !== "active";
    const pageSize = Math.min(Math.max(limit, 1), 50);

    let cursorTime: string | null = null;
    if (cursor) {
      const cursorResult = await this.db.query<{ created_at: string }>(
        "SELECT created_at FROM messages WHERE id = $1 LIMIT 1",
        [cursor]
      );
      cursorTime = cursorResult.rows[0]?.created_at || null;
    }

    const params: unknown[] = [relationId, pageSize];
    let sql = `SELECT id, client_msg_id, sender_id, content, status, created_at, read_at
               FROM messages
               WHERE relation_id = $1`;

    if (cursorTime) {
      sql += " AND created_at < $3";
      params.push(cursorTime);
    }

    sql += " ORDER BY created_at DESC LIMIT $2";

    const result = await this.db.query<MessageRow>(sql, params);
    const items = result.rows.map((row) => ({
      id: row.id,
      clientMsgId: row.client_msg_id,
      senderId: row.sender_id,
      content: row.content,
      status: row.status,
      createdAt: row.created_at,
      readAt: row.read_at
    }));

    return {
      items,
      nextCursor: items.length === pageSize ? items[items.length - 1].id : null,
      relationId,
      relationStatus: relation.status,
      readOnly
    };
  }

  async sendMessage(userId: string, dto: SendMessageDto) {
    const relation = await this.getCurrentRelation(userId);
    const relationId = relation.id;

    const existing = await this.db.query<MessageRow>(
      `SELECT id, client_msg_id, sender_id, content, status, created_at, read_at
       FROM messages
       WHERE sender_id = $1 AND client_msg_id = $2
       LIMIT 1`,
      [userId, dto.clientMsgId]
    );

    if (existing.rowCount) {
      const row = existing.rows[0];
      return {
        message: {
          id: row.id,
          clientMsgId: row.client_msg_id,
          senderId: row.sender_id,
          content: row.content,
          status: row.status,
          createdAt: row.created_at
        },
        idempotentHit: true
      };
    }

    const inserted = await this.db.query<MessageRow>(
      `INSERT INTO messages (relation_id, sender_id, client_msg_id, content, status)
       VALUES ($1, $2, $3, $4, 'sent')
       RETURNING id, client_msg_id, sender_id, content, status, created_at, read_at`,
      [relationId, userId, dto.clientMsgId, dto.content]
    );

    const row = inserted.rows[0];
    return {
      message: {
        id: row.id,
        clientMsgId: row.client_msg_id,
        senderId: row.sender_id,
        content: row.content,
        status: row.status,
        createdAt: row.created_at
      },
      idempotentHit: false
    };
  }

  async markRead(userId: string, dto: MarkReadDto) {
    const relation = await this.getCurrentRelation(userId);
    const relationId = relation.id;

    const updated = await this.db.query(
      `UPDATE messages
       SET read_at = NOW()
       WHERE relation_id = $1
         AND id = ANY($2::uuid[])
         AND sender_id <> $3
         AND read_at IS NULL`,
      [relationId, dto.messageIds, userId]
    );

    return {
      updated: updated.rowCount || 0,
      readAt: new Date().toISOString()
    };
  }

  private async getCurrentRelation(userId: string) {
    const relation = await this.db.query<RelationRow>(
      `SELECT id, status
       FROM relations
       WHERE status = 'active'
         AND (user_a_id = $1 OR user_b_id = $1)
       LIMIT 1`,
      [userId]
    );

    if (!relation.rowCount) {
      throw new AppError("RELATION_404_NOT_BOUND", "Not bound", 404);
    }

    return relation.rows[0];
  }

  private async getReadableRelation(userId: string) {
    const relation = await this.db.query<RelationRow>(
      `SELECT id, status
       FROM relations
       WHERE (user_a_id = $1 OR user_b_id = $1)
         AND status IN ('active', 'cancelled')
       ORDER BY
         CASE WHEN status = 'active' THEN 0 ELSE 1 END ASC,
         updated_at DESC,
         bound_at DESC
       LIMIT 1`,
      [userId]
    );

    if (!relation.rowCount) {
      throw new AppError("RELATION_404_NOT_BOUND", "Not bound", 404);
    }

    return relation.rows[0];
  }
}

