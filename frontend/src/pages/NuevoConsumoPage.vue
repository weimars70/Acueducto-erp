<template>
  <q-page padding>
    <div class="row justify-center">
      <div class="col-12 col-md-8 col-lg-6">
        <h5 class="q-mt-none q-mb-md">Nuevo Consumo</h5>
        
        <q-form @submit="onSubmit" class="q-gutter-md">
          <q-input
            v-model="form.instalacion"
            type="number"
            label="Instalación"
            :rules="[val => !!val || 'Instalación es requerida']"
          />

          <q-input
            v-model="form.lectura"
            type="number"
            label="Lectura"
            :rules="[val => !!val || 'Lectura es requerida']"
          />

          <q-input
            v-model="form.medidor"
            label="Medidor"
            :rules="[val => !!val || 'Medidor es requerido']"
          />

          <q-input
            v-model="form.fecha"
            type="date"
            label="Fecha"
            :rules="[val => !!val || 'Fecha es requerida']"
          />

          <div class="row q-col-gutter-md">
            <div class="col-6">
              <q-input
                v-model="form.mes"
                type="number"
                label="Mes"
                :rules="[
                  val => !!val || 'Mes es requerido',
                  val => val >= 1 && val <= 12 || 'Mes inválido'
                ]"
              />
            </div>
            <div class="col-6">
              <q-input
                v-model="form.year"
                type="number"
                label="Año"
                :rules="[val => !!val || 'Año es requerido']"
              />
            </div>
          </div>

          <q-toggle
            v-model="form.procesado"
            label="Procesado"
          />

          <div class="row q-gutter-sm justify-end">
            <q-btn
              label="Cancelar"
              type="button"
              flat
              color="negative"
              to="/consumos"
            />
            <q-btn
              label="Guardar"
              type="submit"
              color="primary"
              :loading="loading"
            />
          </div>
        </q-form>
      </div>
    </div>
  </q-page>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useQuasar } from 'quasar'
import { useConsumosStore } from 'src/stores/consumos'

const $q = useQuasar()
const router = useRouter()
const consumosStore = useConsumosStore()
const loading = ref(false)

const form = ref({
  instalacion: null,
  lectura: null,
  fecha: '',
  mes: new Date().getMonth() + 1,
  year: new Date().getFullYear(),
  medidor: '',
  procesado: false
})

const onSubmit = async () => {
  console.log('consumo::: consumoData');
  try {
    loading.value = true
    const consumoData = {
      ...form.value,
      instalacion: Number(form.value.instalacion),
      lectura: Number(form.value.lectura),
      mes: Number(form.value.mes),
      year: Number(form.value.year)
    }
    console.log('consumo:::XXX', consumoData);
    await consumosStore.createConsumo(consumoData)
    
    $q.notify({
      color: 'positive',
      message: 'Consumo guardado exitosamente',
      icon: 'check'
    })
    
    router.push('/consumos')
  } catch (error) {
    $q.notify({
      color: 'negative',
      message: error.response?.data?.message || 'Error al guardar el consumo',
      icon: 'warning'
    })
  } finally {
    loading.value = false
  }
}
</script>