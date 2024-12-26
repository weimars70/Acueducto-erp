import { ref } from 'vue';
import { useQuasar } from 'quasar';
import { useConsumosStore } from '../stores/consumos';
import type { CreateConsumoDto } from '../services/consumos/types';
import { ERROR_MESSAGES } from '../services/consumos/constants';

export function useConsumos() {
  const loading = ref(false);
  const $q = useQuasar();
  const consumosStore = useConsumosStore();

  const fetchConsumos = async () => {
    try {
      loading.value = true;
      await consumosStore.getConsumos();
    } catch (error) {
      const message = error instanceof Error ? error.message : ERROR_MESSAGES.FETCH_ERROR;
      $q.notify({
        type: 'negative',
        message,
        position: 'top'
      });
    } finally {
      loading.value = false;
    }
  };

  const createConsumo = async (data: CreateConsumoDto) => {
    try {
      loading.value = true;
      await consumosStore.createConsumo(data);
      $q.notify({
        type: 'positive',
        message: 'Consumo creado exitosamente',
        position: 'top'
      });
      return true;
    } catch (error) {
      const message = error instanceof Error ? error.message : ERROR_MESSAGES.CREATE_ERROR;
      $q.notify({
        type: 'negative',
        message,
        position: 'top'
      });
      return false;
    } finally {
      loading.value = false;
    }
  };

  return {
    loading,
    consumos: consumosStore.consumos,
    fetchConsumos,
    createConsumo
  };
}