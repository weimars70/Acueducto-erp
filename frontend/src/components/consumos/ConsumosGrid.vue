```vue
<template>
  <div>
    <div class="row q-col-gutter-md">
      <div v-for="consumo in consumos" :key="consumo.codigo" class="col-12 col-sm-6 col-md-4">
        <consumo-card :consumo="consumo" />
      </div>
    </div>

    <div v-if="loading" class="row justify-center q-pa-md">
      <q-spinner size="40px" color="primary" />
    </div>

    <div v-if="!loading && consumos.length === 0" class="row justify-center q-pa-md text-grey-8">
      No hay consumos registrados
    </div>
  </div>
</template>

<script setup lang="ts">
import { type Consumo } from '../../services/consumos/types';
import ConsumoCard from './ConsumoCard.vue';

defineProps<{
  consumos: Consumo[];
  loading: boolean;
}>();
</script>
```