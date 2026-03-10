export interface ApiErrorBody {
  code: string;
  message: string;
  details: Record<string, unknown> | null;
}

export interface ApiResponseBody<T> {
  success: boolean;
  requestId: string | null;
  data: T | null;
  error: ApiErrorBody | null;
}

