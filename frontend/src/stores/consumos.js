import { defineStore } from 'pinia';
import { ref } from 'vue';
import { consumosApi } from '../services/consumos/api';

export const useConsumosStore = defineStore('consumos', () => {
  const consumos = ref([]);
  const loading = ref(false);
  const error = ref(null);

  async function getConsumos() {
    try {
      loading.value = true;
      error.value = null;
      const data = await consumosApi.getAll();
      consumos.value = data;
      return data;
    } catch (err) {
      error.value = err?.message || 'Error al cargar los consumos';
      throw error.value;
    } finally {
      loading.value = false;
    }
  }

  async function createConsumo(consumoData) {
    try {
      loading.value = true;
      error.value = null;
      const newConsumo = await consumosApi.create(consumoData);
      consumos.value = [newConsumo, ...consumos.value];
      return newConsumo;
    } catch (err) {
      error.value = err?.message || 'Error al crear el consumo';
      throw error.value;
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