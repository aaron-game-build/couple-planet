import { Body, Controller, Get, Post } from "@nestjs/common";
import { CurrentUser } from "../../common/current-user.decorator";
import { BindDto } from "./dto/bind.dto";
import { RelationService } from "./relation.service";

@Controller("relations")
export class RelationController {
  constructor(private readonly relationService: RelationService) {}

  @Post("invite-code")
  createInviteCode(@CurrentUser() user: { sub: string }) {
    return this.relationService.createInviteCode(user.sub);
  }

  @Post("bind")
  bind(@CurrentUser() user: { sub: string }, @Body() dto: BindDto) {
    return this.relationService.bind(user.sub, dto);
  }

  @Post("unbind")
  unbind(@CurrentUser() user: { sub: string }) {
    return this.relationService.unbind(user.sub);
  }

  @Get("current")
  current(@CurrentUser() user: { sub: string }) {
    return this.relationService.current(user.sub);
  }

  @Get("latest")
  latest(@CurrentUser() user: { sub: string }) {
    return this.relationService.latest(user.sub);
  }
}

