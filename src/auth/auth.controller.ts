import { Controller, Post, Get, Body } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthDto } from './dto';
import { dot } from 'node:test/reporters';

@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('register')
  register(@Body() dto: AuthDto) {
    console.log(dto);
    return this.authService.register(dto);
  }

  @Get('login')
  login(@Body() dto: AuthDto) {
    return this.authService.login(dto);
  }
}
