<template>
  <div class="row items-center justify-between full-width">
    <div class="col-auto">
      Ir a página: 
      <q-input 
        :model-value="page"
        @update:model-value="$emit('update:page', $event)"
        type="number" 
        style="width: 60px"
        dense
        outlined
        class="q-ml-sm"
      />
    </div>
    <div class="col">
      <q-pagination
        :model-value="page"
        @update:model-value="$emit('update:page', $event)"
        :max="Math.ceil(rowsNumber / rowsPerPage)"
        :max-pages="5"
        boundary-numbers
        direction-links
      />
    </div>
    <div class="col-auto">
      Ver:
      <q-select
        :model-value="rowsPerPage"
        @update:model-value="$emit('update:rowsPerPage', $event)"
        :options="[10, 20, 50, 100]"
        dense
        outlined
        class="q-ml-sm"
        style="width: 100px"
      />
    </div>
  </div>
</template>

<script setup>
defineProps({
  page: {
    type: Number,
    required: true
  },
  rowsPerPage: {
    type: Number,
    required: true
  },
  rowsNumber: {
    type: Number,
    required: true
  }
});

defineEmits(['update:page', 'update:rowsPerPage']);
</script>