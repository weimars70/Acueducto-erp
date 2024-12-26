export interface Consumo {
  codigo: number;
  instalacion: number;
  lectura: number;
  fecha: string;
  consumo: number;
  mes: number;
  year: number;
  medidor: string;
  otros_cobros?: number;
  reconexion?: number;
  facturado: string;
  created_at?: string;
  updated_at?: string;
}