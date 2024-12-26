import { IsNumber, IsDateString, IsString, IsOptional, Min } from 'class-validator';
import { Type } from 'class-transformer';

export class CreateConsumoDto {
  @IsNumber()
  @Type(() => Number)
  @Min(1)
  instalacion: number;

  @IsNumber()
  @Type(() => Number)
  @Min(0)
  lectura: number;

  @IsDateString()
  fecha: string;

  @IsNumber()
  @Type(() => Number)
  @Min(1)
  mes: number;

  @IsNumber()
  @Type(() => Number)
  @Min(2000)
  year: number;

  @IsString()
  medidor: string;

  @IsNumber()
  @IsOptional()
  @Type(() => Number)
  @Min(0)
  otros_cobros?: number;

  @IsNumber()
  @IsOptional()
  @Type(() => Number)
  @Min(0)
  reconexion?: number;
}