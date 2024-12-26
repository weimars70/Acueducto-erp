<template>
  <q-page padding>
    <div class="row q-col-gutter-md">
      <div class="col-12">
        <div class="row items-center justify-between q-mb-md">
          <h5 class="q-my-none">Listado de Consumos</h5>
          <div class="row q-gutter-sm">
            <q-btn
              icon="refresh"
              flat
              round
              :loading="consumosStore.loading"
              @click="loadConsumos"
            >
              <q-tooltip>Actualizar</q-tooltip>
            </q-btn>
            <q-btn 
              color="primary" 
              icon="add" 
              label="Nuevo Consumo" 
              to="/nuevo-consumo" 
            />
          </div>
        </div>

        <consumos-grid 
          :consumos="consumosStore.consumos"
          :loading="consumosStore.loading"
        />
      </div>
    </div>
  </q-page>
</template>

<script setup lang="ts">
import { onMounted } from 'vue';
import { useQuasar } from 'quasar';
import { useConsumosStore } from '../stores/consumos';

const $q = useQuasar();
const consumosStore = useConsumosStore();

const loadConsumos = async () => {
  try {
    await consumosStore.getConsumos();
  } catch (error) {
    $q.notify({
      type: 'negative',
      message: error instanceof Error ? error.message : 'Error al cargar los consumos',
      position: 'top',
      timeout: 5000
    });
  }
};

onMounted(loadConsumos);
</script>