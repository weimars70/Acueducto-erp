import { Injectable, InternalServerErrorException, BadRequestException } from '@nestjs/common';
import { SupabaseService } from '../supabase/supabase.service';
import { CreateConsumoDto } from './dto/create-consumo.dto';
import { Consumo } from './interfaces/consumo.interface';
import { ERROR_MESSAGES } from './constants/error-messages';
import { validateLectura, calculateConsumo } from './utils/consumo.utils';

@Injectable()
export class ConsumosService {
  constructor(private readonly supabase: SupabaseService) {}

  async getConsumos(): Promise<any[]> {
    try {
      const { data, error } = await this.supabase
        .getClient()
        .rpc('get_consumos');

      if (error) throw error;
      
      return data || [];
    } catch (error) {
      throw new InternalServerErrorException(ERROR_MESSAGES.FETCH_ERROR);
    }
  }

  async create(createConsumoDto: CreateConsumoDto): Promise<Consumo> {
    try {
      const { data: ultimaLectura } = await this.supabase
        .getClient()
        .rpc('get_ultima_lectura', { 
          p_instalacion: createConsumoDto.instalacion 
        });

      if (!validateLectura(createConsumoDto.lectura, ultimaLectura)) {
        throw new BadRequestException(ERROR_MESSAGES.INVALID_LECTURA);
      }

      const consumo = calculateConsumo(createConsumoDto.lectura, ultimaLectura);

      const { data, error } = await this.supabase
        .getClient()
        .from('consumo')
        .insert({
          ...createConsumoDto,
          consumo,
          facturada: false
        })
        .select()
        .single();

      if (error) throw error;
      return data;
    } catch (error) {
      if (error instanceof BadRequestException) throw error;
      throw new InternalServerErrorException(ERROR_MESSAGES.CREATE_ERROR);
    }
  }
}