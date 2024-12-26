export interface Consumo {
  codigo: number;
  instalacion: number;
  nombre: string;
  lectura: number;
  fecha: string;
  mes_nombre: string;
  mes_codigo: number;
  year: number;
  consumo: number;
  medidor: string;
  otros_cobros: number;
  reconexion: number;
  facturado: boolean;
}

export interface CreateConsumoDto {
  instalacion: number;
  lectura: number;
  fecha: string;
  mes: number;
  year: number;
  medidor: string;
  otros_cobros?: number;
  reconexion?: number;
}