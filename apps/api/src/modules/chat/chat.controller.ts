import { Body, Controller, Get, Post, Query } from "@nestjs/common";
import { CurrentUser } from "../../common/current-user.decorator";
import { ChatService } from "./chat.service";
import { MarkReadDto } from "./dto/mark-read.dto";
import { SendMessageDto } from "./dto/send-message.dto";

@Controller("chats/current/messages")
export class ChatController {
  constructor(private readonly chatService: ChatService) {}

  @Get()
  list(
    @CurrentUser() user: { sub: string },
    @Query("cursor") cursor?: string,
    @Query("limit") limit?: string,
    @Query("includeArchived") includeArchived?: string
  ) {
    return this.chatService.listMessages(
      user.sub,
      cursor,
      limit ? Number(limit) : 20,
      includeArchived === "true"
    );
  }

  @Post()
  send(@CurrentUser() user: { sub: string }, @Body() dto: SendMessageDto) {
    return this.chatService.sendMessage(user.sub, dto);
  }

  @Post("read")
  markRead(@CurrentUser() user: { sub: string }, @Body() dto: MarkReadDto) {
    return this.chatService.markRead(user.sub, dto);
  }
}

