<template>
  <q-card class="consumo-card bg-water-light">
    <q-card-section class="q-pa-sm">
      <div class="text-subtitle1 text-dark text-weight-bold">{{ consumo.nombre }}</div>
      <div class="row items-center no-margin">
        <div class="text-caption text-secondary text-weight-bold">Instalación:</div>
        <div class="text-caption text-dark q-ml-xs">{{ consumo.instalacion }}</div>
      </div>
    </q-card-section>

    <q-card-section class="q-pa-sm bg-white">
      <div class="row q-col-gutter-x-sm">
        <div class="col-6">
          <div class="text-caption text-secondary text-weight-bold">Medidor</div>
          <div class="text-caption text-dark">{{ consumo.medidor }}</div>
        </div>
        <div class="col-6">
          <div class="text-caption text-secondary text-weight-bold">Periodo</div>
          <div class="text-caption text-dark">{{ consumo.mes_nombre }} {{ consumo.year }}</div>
        </div>
      </div>

      <div class="row q-col-gutter-x-sm q-mt-xs">
        <div class="col-6">
          <div class="text-caption text-secondary text-weight-bold">Lectura</div>
          <div class="text-caption text-dark">{{ consumo.lectura }}</div>
        </div>
        <div class="col-6">
          <div class="text-caption text-secondary text-weight-bold">Consumo</div>
          <div class="text-caption text-primary">{{ consumo.consumo }}</div>
        </div>
      </div>

      <div class="row q-col-gutter-x-sm q-mt-xs">
        <div class="col-6">
          <div class="text-caption text-secondary text-weight-bold">Otros Cobros</div>
          <div class="text-caption text-dark">$ {{ consumo.otros_cobros.toFixed(2) }}</div>
        </div>
        <div class="col-6">
          <div class="text-caption text-secondary text-weight-bold">Reconexión</div>
          <div class="text-caption text-dark">$ {{ consumo.reconexion.toFixed(2) }}</div>
        </div>
      </div>
    </q-card-section>

    <q-card-section class="q-pa-sm bg-water-light">
      <div class="row justify-end">
        <q-badge 
          :color="consumo.facturado ? 'positive' : 'warning'"
          class="text-caption"
        >
          {{ consumo.facturado ? 'Facturado' : 'Pendiente' }}
        </q-badge>
      </div>
    </q-card-section>
  </q-card>
</template>

<script setup lang="ts">
import type { Consumo } from '../../services/consumos/types';

defineProps<{
  consumo: Consumo;
}>();
</script>

<style scoped>
.consumo-card {
  transition: all 0.3s ease;
  border: 1px solid #E0E0E0;
}

.consumo-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(3, 169, 244, 0.15);
}

.no-margin {
  margin: 1 !important;
}

:deep(.q-card__section--vert) {
  padding: 6px;
}
</style>