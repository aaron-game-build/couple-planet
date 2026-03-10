import { Controller, Get } from "@nestjs/common";
import { Public } from "../common/public.decorator";
import { DbService } from "./db.service";

@Controller("health")
export class HealthController {
  constructor(private readonly db: DbService) {}

  @Public()
  @Get()
  async getHealth() {
    const dbOk = await this.db.healthCheck();
    return { status: "ok", db: dbOk ? "up" : "down" };
  }
}

