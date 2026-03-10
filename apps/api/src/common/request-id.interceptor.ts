import {
  CallHandler,
  ExecutionContext,
  Injectable,
  NestInterceptor
} from "@nestjs/common";
import { randomUUID } from "crypto";
import { Request } from "express";
import { Observable } from "rxjs";

type ReqWithRequestId = Request & { requestId?: string };

@Injectable()
export class RequestIdInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<unknown> {
    const req = context.switchToHttp().getRequest<ReqWithRequestId>();
    const raw = req.headers["x-request-id"];
    const headerRequestId = Array.isArray(raw) ? raw[0] : raw;
    req.requestId = headerRequestId || randomUUID();
    return next.handle();
  }
}

