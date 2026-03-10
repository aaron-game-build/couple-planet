import {
  CallHandler,
  ExecutionContext,
  Injectable,
  NestInterceptor
} from "@nestjs/common";
import { Request } from "express";
import { map, Observable } from "rxjs";
import { ApiResponseBody } from "./api-response.interface";

type ReqWithRequestId = Request & { requestId?: string };

@Injectable()
export class ResponseInterceptor<T> implements NestInterceptor<T, ApiResponseBody<T>> {
  intercept(
    context: ExecutionContext,
    next: CallHandler<T>
  ): Observable<ApiResponseBody<T>> {
    const req = context.switchToHttp().getRequest<ReqWithRequestId>();

    return next.handle().pipe(
      map((data) => {
        if (
          data &&
          typeof data === "object" &&
          "success" in (data as Record<string, unknown>) &&
          "requestId" in (data as Record<string, unknown>)
        ) {
          return data as unknown as ApiResponseBody<T>;
        }

        return {
          success: true,
          requestId: req.requestId ?? null,
          data,
          error: null
        };
      })
    );
  }
}

