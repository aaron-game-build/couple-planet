import { Module } from "@nestjs/common";
import { APP_GUARD } from "@nestjs/core";
import { JwtAuthGuard } from "./common/jwt-auth.guard";
import { AuthModule } from "./modules/auth/auth.module";
import { ChatModule } from "./modules/chat/chat.module";
import { RelationModule } from "./modules/relation/relation.module";
import { DbModule } from "./infra/db.module";
import { HealthController } from "./infra/health.controller";

@Module({
  imports: [DbModule, AuthModule, RelationModule, ChatModule],
  controllers: [HealthController],
  providers: [
    {
      provide: APP_GUARD,
      useClass: JwtAuthGuard
    }
  ]
})
export class AppModule {}

