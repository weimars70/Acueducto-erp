import { ConfigService } from '@nestjs/config';

export interface SupabaseConfig {
  url: string;
  key: string;
}

export const getSupabaseConfig = (configService: ConfigService): SupabaseConfig => {
  const url = configService.getOrThrow<string>('SUPABASE_URL');
  const key = configService.getOrThrow<string>('SUPABASE_ANON_KEY');

  return { url, key };
};