import { IsString, Length } from "class-validator";

export class BindDto {
  @IsString()
  @Length(4, 32)
  inviteCode!: string;
}

