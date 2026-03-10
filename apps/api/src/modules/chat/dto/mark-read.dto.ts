import { ArrayNotEmpty, IsArray, IsString } from "class-validator";

export class MarkReadDto {
  @IsArray()
  @ArrayNotEmpty()
  @IsString({ each: true })
  messageIds!: string[];
}

