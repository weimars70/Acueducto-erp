import { ConfigService } from '@nestjs/config';

export const getDatabaseConfig = (configService: ConfigService) => ({
  url: configService.get('SUPABASE_URL'),
  key: configService.get('SUPABASE_ANON_KEY')
});