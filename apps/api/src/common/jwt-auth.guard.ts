import { CanActivate, ExecutionContext, Injectable } from "@nestjs/common";
import { Reflector } from "@nestjs/core";
import { JwtService } from "@nestjs/jwt";
import { Request } from "express";
import { AppError } from "./app-error";
import { IS_PUBLIC_KEY } from "./public.decorator";

type ReqWithUser = Request & { user?: { sub: string; account: string } };

@Injectable()
export class JwtAuthGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly jwtService: JwtService
  ) {}

  canActivate(context: ExecutionContext): boolean {
    const isPublic = this.reflector.getAllAndOverride<boolean>(IS_PUBLIC_KEY, [
      context.getHandler(),
      context.getClass()
    ]);
    if (isPublic) {
      return true;
    }

    const req = context.switchToHttp().getRequest<ReqWithUser>();
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      throw new AppError(
        "AUTH_401_TOKEN_INVALID",
        "Invalid token",
        401,
        null
      );
    }

    const token = authHeader.slice(7);
    try {
      const payload = this.jwtService.verify<{ sub: string; account: string }>(
        token
      );
      req.user = payload;
      return true;
    } catch {
      throw new AppError(
        "AUTH_401_TOKEN_INVALID",
        "Invalid token",
        401,
        null
      );
    }
  }
}

