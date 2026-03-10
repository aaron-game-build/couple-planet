import { Injectable } from "@nestjs/common";
import { JwtService } from "@nestjs/jwt";
import { randomBytes, scryptSync, timingSafeEqual } from "crypto";
import { DbService } from "../../infra/db.service";
import { AppError } from "../../common/app-error";
import { LoginDto } from "./dto/login.dto";
import { RegisterDto } from "./dto/register.dto";

type UserRow = {
  id: string;
  account: string;
  password_hash: string;
  nickname: string;
  created_at: string;
};

@Injectable()
export class AuthService {
  constructor(
    private readonly db: DbService,
    private readonly jwt: JwtService
  ) {}

  async register(dto: RegisterDto) {
    const exists = await this.db.query<UserRow>(
      "SELECT id FROM users WHERE account = $1 LIMIT 1",
      [dto.account]
    );
    if (exists.rowCount) {
      throw new AppError("AUTH_409_ACCOUNT_EXISTS", "Account already exists", 409);
    }

    const passwordHash = this.hashPassword(dto.password);
    const inserted = await this.db.query<UserRow>(
      `INSERT INTO users (account, password_hash, nickname)
       VALUES ($1, $2, $3)
       RETURNING id, account, password_hash, nickname, created_at`,
      [dto.account, passwordHash, dto.nickname]
    );

    const user = inserted.rows[0];
    return {
      user: {
        id: user.id,
        account: user.account,
        nickname: user.nickname,
        createdAt: user.created_at
      },
      token: this.signToken(user.id, user.account)
    };
  }

  async login(dto: LoginDto) {
    const result = await this.db.query<UserRow>(
      `SELECT id, account, password_hash, nickname, created_at
       FROM users WHERE account = $1 LIMIT 1`,
      [dto.account]
    );
    if (!result.rowCount) {
      throw new AppError(
        "AUTH_401_CREDENTIALS_INVALID",
        "Invalid account or password",
        401
      );
    }

    const user = result.rows[0];
    const valid = this.verifyPassword(dto.password, user.password_hash);
    if (!valid) {
      throw new AppError(
        "AUTH_401_CREDENTIALS_INVALID",
        "Invalid account or password",
        401
      );
    }

    return {
      user: {
        id: user.id,
        account: user.account,
        nickname: user.nickname
      },
      token: this.signToken(user.id, user.account)
    };
  }

  async me(userId: string) {
    const result = await this.db.query<UserRow>(
      "SELECT id, account, password_hash, nickname, created_at FROM users WHERE id = $1 LIMIT 1",
      [userId]
    );
    if (!result.rowCount) {
      throw new AppError("AUTH_401_TOKEN_INVALID", "Invalid token", 401);
    }

    const user = result.rows[0];
    return {
      user: {
        id: user.id,
        account: user.account,
        nickname: user.nickname
      }
    };
  }

  private signToken(userId: string, account: string) {
    return this.jwt.sign({ sub: userId, account });
  }

  private hashPassword(password: string) {
    const salt = randomBytes(16).toString("hex");
    const hash = scryptSync(password, salt, 64).toString("hex");
    return `${salt}:${hash}`;
  }

  private verifyPassword(password: string, storedHash: string) {
    const [salt, key] = storedHash.split(":");
    const hashBuffer = scryptSync(password, salt, 64);
    const keyBuffer = Buffer.from(key, "hex");
    return timingSafeEqual(hashBuffer, keyBuffer);
  }
}

