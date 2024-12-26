import { defineStore } from 'pinia';
import { ref } from 'vue';
import { consumosService } from '../services/consumos/consumos.service';
import type { Consumo, CreateConsumoDto } from '../services/consumos/types';

export const useConsumosStore = defineStore('consumos', () => {
  const consumos = ref<Consumo[]>([]);
  const loading = ref(false);
  const error = ref<string | null>(null);

  async function getConsumos() {
    try {
      loading.value = true;
      error.value = null;
      const data = await consumosService.getAll();
      consumos.value = data;
      return data;
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Error al cargar los consumos';
      error.value = message;
      throw new Error(message);
    } finally {
      loading.value = false;
    }
  }

  async function createConsumo(consumoData: CreateConsumoDto) {
    try {
      loading.value = true;
      error.value = null;
      const newConsumo = await consumosService.create(consumoData);
      consumos.value = [newConsumo, ...consumos.value];
      return newConsumo;
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Error al crear el consumo';
      error.value = message;
      throw new Error(message);
    } finally {
      loading.value = false;
    }
  }

  return {
    consumos,
    loading,
    error,
    getConsumos,
    createConsumo
  };
});