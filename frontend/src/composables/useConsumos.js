import { ref, computed } from 'vue';
import { useQuasar } from 'quasar';
import { consumosApi } from '../services/consumos/api';
import { ERROR_MESSAGES } from '../services/consumos/types';
import { formatDate, formatPeriodo, getStatusColor, getStatusText } from '../services/consumos/utils';

export function useConsumos() {
  const $q = useQuasar();
  const consumos = ref([]);
  const loading = ref(false);
  const error = ref(null);

  const formattedConsumos = computed(() => {
    return consumos.value.map(consumo => ({
      ...consumo,
      formattedDate: formatDate(consumo.fecha),
      formattedPeriodo: formatPeriodo(consumo.mes, consumo.year),
      statusColor: getStatusColor(consumo.facturado),
      statusText: getStatusText(consumo.facturado)
    }));
  });

  const fetchConsumos = async () => {
    try {
      loading.value = true;
      error.value = null;
      const data = await consumosApi.getAll();
      consumos.value = data;
    } catch (err) {
      error.value = err.message || ERROR_MESSAGES.FETCH_ERROR;
      $q.notify({
        type: 'negative',
        message: error.value,
        position: 'top'
      });
    } finally {
      loading.value = false;
    }
  };

  const createConsumo = async (consumoData) => {
    try {
      loading.value = true;
      error.value = null;
      const newConsumo = await consumosApi.create(consumoData);
      consumos.value = [newConsumo, ...consumos.value];
      return newConsumo;
    } catch (err) {
      error.value = err.message || ERROR_MESSAGES.CREATE_ERROR;
      $q.notify({
        type: 'negative',
        message: error.value,
        position: 'top'
      });
      throw error.value;
    } finally {
      loading.value = false;
    }
  };

  return {
    consumos: formattedConsumos,
    loading,
    error,
    fetchConsumos,
    createConsumo
  };
}