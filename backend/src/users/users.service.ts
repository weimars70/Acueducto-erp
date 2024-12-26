import { Injectable, ConflictException, NotFoundException } from '@nestjs/common';
import { SupabaseService } from '../supabase/supabase.service';
import { CreateUserDto } from './dto/create-user.dto';

@Injectable()
export class UsersService {
  constructor(private supabase: SupabaseService) {}

  async findByUsername(username: string) {
    const { data: users, error } = await this.supabase
      .getClient()
      .rpc('get_user_by_username', { input_username: username });

    if (error || !users?.length) {
      throw new NotFoundException('Usuario no encontrado');
    }

    return users[0];
  }

  async create(createUserDto: CreateUserDto) {
    const { data: existingUser } = await this.supabase
      .getClient()
      .from('users')
      .select()
      .eq('username', createUserDto.username)
      .single();

    if (existingUser) {
      throw new ConflictException('El usuario ya existe');
    }

    const { data: user, error } = await this.supabase
      .getClient()
      .from('users')
      .insert(createUserDto)
      .select()
      .single();

    if (error) {
      throw error;
    }

    return user;
  }
}