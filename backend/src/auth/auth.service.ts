import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { SupabaseService } from '../supabase/supabase.service';
import { LoginDto } from './dto/login.dto';
import { AuthResponse } from './interfaces/auth.interface';

@Injectable()
export class AuthService {
  constructor(
    private supabase: SupabaseService,
    private jwtService: JwtService,
  ) {}

  async login(loginDto: LoginDto): Promise<AuthResponse> {
    console.log('Login attempt for username:', loginDto);
    try {
      console.log('Login attempt for username:', loginDto.username);

      // Get user by username
      const { data: users, error: userError } = await this.supabase
        .getClient()
        .rpc('get_user_by_username', {
          input_username: loginDto.username
        });

      console.log('Database response:', { 
        hasUsers: !!users?.length,
        error: userError?.message || null
      });

      if (userError || !users?.length) {
        console.log('User not found or database error');
        throw new UnauthorizedException('Usuario no encontrado');
      }

      const user = users[0];
      console.log('User found:', { 
        id: user.id,
        username: user.username,
        role: user.role
      });

      // Verify password
      const { data: verified, error: verifyError } = await this.supabase
        .getClient()
        .rpc('verify_password', {
          input_password: loginDto.password,
          stored_hash: user.password_hash
        });

      console.log('Password verification:', {
        verified,
        error: verifyError?.message || null
      });

      if (verifyError || !verified) {
        console.log('Password verification failed');
        throw new UnauthorizedException('Credenciales inválidas');
      }

      const payload = {
        sub: user.id,
        username: user.username,
        role: user.role
      };

      const access_token = this.jwtService.sign(payload);
      console.log('JWT token generated successfully');

      const response: AuthResponse = {
        access_token,
        user: {
          id: user.id,
          username: user.username,
          full_name: user.full_name,
          role: user.role
        }
      };

      console.log('Login successful:', {
        userId: user.id,
        username: user.username,
        role: user.role
      });

      return response;
    } catch (error) {
      console.error('Login error:', error);
      throw error;
    }
  }
}