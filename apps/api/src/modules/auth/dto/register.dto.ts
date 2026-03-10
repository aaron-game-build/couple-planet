import { IsEmail, IsString, Length } from "class-validator";

export class RegisterDto {
  @IsEmail()
  account!: string;

  @IsString()
  @Length(8, 128)
  password!: string;

  @IsString()
  @Length(1, 20)
  nickname!: string;
}

