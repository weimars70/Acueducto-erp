import { Controller, Get, Post, Body } from '@nestjs/common';
import { ConsumosService } from './consumos.service';
import { CreateConsumoDto } from './dto/create-consumo.dto';
import { Auth } from '../common/decorators/auth.decorator';
import { Consumo } from './interfaces/consumo.interface';

@Controller('consumos')
@Auth()
export class ConsumosController {
  constructor(private readonly consumosService: ConsumosService) {}

  @Get()
  async getConsumos(): Promise<Consumo[]> {
    return this.consumosService.getConsumos();
  }

  @Post()
  async create(@Body() createConsumoDto: CreateConsumoDto): Promise<Consumo> {
    return this.consumosService.create(createConsumoDto);
  }
}