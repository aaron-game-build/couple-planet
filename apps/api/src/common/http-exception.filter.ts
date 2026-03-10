import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpException,
  HttpStatus
} from "@nestjs/common";
import { Request, Response } from "express";
import { AppError } from "./app-error";

type ReqWithRequestId = Request & { requestId?: string };

@Catch()
export class HttpExceptionFilter implements ExceptionFilter {
  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const req = ctx.getRequest<ReqWithRequestId>();
    const res = ctx.getResponse<Response>();

    if (exception instanceof AppError) {
      res.status(exception.statusCode).json({
        success: false,
        requestId: req.requestId ?? null,
        data: null,
        error: {
          code: exception.code,
          message: exception.message,
          details: exception.details
        }
      });
      return;
    }

    if (exception instanceof HttpException) {
      const status = exception.getStatus();
      const payload = exception.getResponse();
      const message =
        typeof payload === "object" && payload !== null && "message" in payload
          ? String((payload as Record<string, unknown>).message)
          : exception.message;

      res.status(status).json({
        success: false,
        requestId: req.requestId ?? null,
        data: null,
        error: {
          code: `HTTP_${status}`,
          message,
          details: null
        }
      });
      return;
    }

    res.status(HttpStatus.INTERNAL_SERVER_ERROR).json({
      success: false,
      requestId: req.requestId ?? null,
      data: null,
      error: {
        code: "INTERNAL_500",
        message: "Internal Server Error",
        details: null
      }
    });
  }
}

