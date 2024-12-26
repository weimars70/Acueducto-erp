export interface Consumo {
  codigo: number;
  instalacion: number;
  lectura: number;
  fecha: string;
  consumo: number;
  mes: number;
  year: number;
  medidor: string;
  procesado: boolean;
}

export type NewConsumo = Omit<Consumo, 'codigo'>;