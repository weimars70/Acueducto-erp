<template>
  <q-table
    :rows="consumos"
    :columns="columns"
    row-key="codigo"
    :loading="loading"
    :pagination="pagination"
    @update:pagination="$emit('update:pagination', $event)"
    flat
    bordered
  >
    <template v-slot:top-right>
      <q-btn
        icon="refresh"
        flat
        round
        dense
        :loading="loading"
        @click="$emit('refresh')"
      >
        <q-tooltip>Actualizar</q-tooltip>
      </q-btn>
    </template>

    <template v-slot:body-cell-facturado="props">
      <q-td :props="props">
        <q-badge :color="props.row.facturado ? 'positive' : 'warning'">
          {{ props.row.facturado ? 'Facturado' : 'Pendiente' }}
        </q-badge>
      </q-td>
    </template>

    <template v-slot:loading>
      <q-inner-loading showing color="primary">
        <q-spinner size="50px" color="primary"/>
      </q-inner-loading>
    </template>

    <template v-slot:no-data>
      <div class="full-width row flex-center q-pa-md text-grey-8">
        No hay consumos registrados
      </div>
    </template>
  </q-table>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import type { Consumo } from '../../services/consumos/types';
import { tableColumns } from './table-config';

defineProps<{
  consumos: Consumo[];
  loading: boolean;
}>();

defineEmits<{
  (e: 'refresh'): void;
  (e: 'update:pagination', pagination: any): void;
}>();

const pagination = ref({
  sortBy: 'codigo',
  descending: true,
  page: 1,
  rowsPerPage: 10
});

const columns = tableColumns;
</script>