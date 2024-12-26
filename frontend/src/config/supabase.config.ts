import { ConfigService } from '@nestjs/config';

export interface SupabaseConfig {
  url: string;
  key: string;
}

export const getSupabaseConfig = (configService: ConfigService): SupabaseConfig => {
  const url = configService.get<string>('SUPABASE_URL');
  const key = configService.get<string>('SUPABASE_ANON_KEY');

  if (!url || !key) {
    throw new Error('Missing Supabase configuration');
  }

  return { url, key };
};