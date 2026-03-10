import { createParamDecorator, ExecutionContext } from "@nestjs/common";
import { Request } from "express";

type ReqWithUser = Request & { user?: { sub: string; account: string } };

export const CurrentUser = createParamDecorator(
  (_data: unknown, ctx: ExecutionContext) => {
    const req = ctx.switchToHttp().getRequest<ReqWithUser>();
    return req.user;
  }
);

