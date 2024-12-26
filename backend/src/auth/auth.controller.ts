import { Controller, Post, Body } from '@nestjs/common';
import { AuthService } from './auth.service';
import { LoginDto } from './dto/login.dto';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('login')
  async login(@Body() loginDto: LoginDto) {
    console.log('Login request received:', {
      username: loginDto.username,
      password: '[REDACTED]'
    });

    try {
      const result = await this.authService.login(loginDto);
      console.log('Login successful, sending response:', {
        ...result,
        access_token: '[REDACTED]'
      });
      return result;
    } catch (error) {
      console.error('Login error in controller:', error);
      throw error;
    }
  }
}