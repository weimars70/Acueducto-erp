import api from '../api/axios';
import { ENDPOINTS } from './constants';
import type { Consumo, CreateConsumoDto } from './types';

export const consumosService = {
  async getAll(): Promise<Consumo[]> {
    const { data } = await api.get<Consumo[]>('/api/consumos');
    return data;
  },

  async create(consumo: CreateConsumoDto): Promise<Consumo> {
    const { data } = await api.post<Consumo>('/api/consumos', consumo);
    return data;
  }
};