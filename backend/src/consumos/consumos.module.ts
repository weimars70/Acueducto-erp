import { Module } from '@nestjs/common';
import { ConsumosController } from './consumos.controller';
import { ConsumosService } from './consumos.service';
import { SupabaseModule } from '../supabase/supabase.module';

@Module({
  imports: [SupabaseModule],
  controllers: [ConsumosController],
  providers: [ConsumosService],
  exports: [ConsumosService]
})
export class ConsumosModule {}