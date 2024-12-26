<template>
  <q-page class="flex flex-center bg-grey-2">
    <q-card class="login-card q-pa-lg">
      <q-card-section class="text-center">
        <h4 class="text-h5 q-mt-none q-mb-md">Iniciar Sesión</h4>
      </q-card-section>

      <q-card-section>
        <q-form @submit.prevent="onSubmit" class="q-gutter-md">
          <q-input
            v-model="form.username"
            label="Usuario"
            :rules="usernameRules"
            :loading="loading"
            :disable="loading"
            lazy-rules
          >
            <template v-slot:prepend>
              <q-icon name="person" />
            </template>
          </q-input>

          <q-input
            v-model="form.password"
            label="Contraseña"
            type="password"
            :rules="passwordRules"
            :loading="loading"
            :disable="loading"
            lazy-rules
          >
            <template v-slot:prepend>
              <q-icon name="lock" />
            </template>
          </q-input>

          <div class="full-width q-pt-md">
            <q-btn
              label="Ingresar"
              type="submit"
              color="primary"
              class="full-width"
              :loading="loading"
            />
          </div>
        </q-form>

        <!-- Debug Info Panel -->
        <q-expansion-item
          v-if="debugInfo"
          class="q-mt-md"
          label="Debug Info"
          header-class="text-grey-8"
        >
          <q-card>
            <q-card-section>
              <div class="text-caption">
                <div class="q-mb-sm">
                  <strong>Status:</strong> {{ debugInfo.status }}
                </div>
                <div v-if="debugInfo.request" class="q-mb-sm">
                  <strong>Request:</strong>
                  <pre>{{ JSON.stringify(debugInfo.request, null, 2) }}</pre>
                </div>
                <div v-if="debugInfo.response" class="q-mb-sm">
                  <strong>Response:</strong>
                  <pre>{{ JSON.stringify(debugInfo.response, null, 2) }}</pre>
                </div>
                <div v-if="debugInfo.error" class="text-negative">
                  <strong>Error:</strong>
                  <pre>{{ JSON.stringify(debugInfo.error, null, 2) }}</pre>
                </div>
              </div>
            </q-card-section>
          </q-card>
        </q-expansion-item>

        <div class="text-center q-mt-md">
          <p class="text-grey-8 q-mb-xs">Credenciales de prueba:</p>
          <p class="text-grey-8 q-my-none">Usuario: admin</p>
          <p class="text-grey-8 q-mt-none">Contraseña: admin123456</p>
        </div>
      </q-card-section>
    </q-card>
  </q-page>
</template>

<script setup lang="ts">
import { reactive, ref } from 'vue';
import { useAuth } from '../composables/useAuth';
import type { LoginCredentials } from '../services/auth/types';

const { login, loading } = useAuth();

const debugInfo = ref<any>(null);

const form = reactive<LoginCredentials>({
  username: '',
  password: ''
});

const usernameRules = [
  (val: string) => !!val || 'El usuario es requerido',
  //(val: string) => val.length >= 3 || 'El usuario debe tener al menos 3 caracteres'
];

const passwordRules = [
  (val: string) => !!val || 'La contraseña es requerida',
  (val: string) => val.length >= 6 || 'La contraseña debe tener al menos 6 caracteres'
];

const onSubmit = async () => {
  console.log('onSubmit::::');
  try {
    console.log('form:::', form);
    const response = await login(form);
    console.log('onSubmit::::', response);
    debugInfo.value = {
      status: 'success',
      request: debugInfo.value.request,
      response: {
        success: true,
        timestamp: new Date().toISOString()
      }
    };
  } catch (error) {
    console.error('Login error:', error);
    debugInfo.value = {
      status: 'error',
      request: debugInfo.value.request,
      error: error instanceof Error ? {
        message: error.message,
        timestamp: new Date().toISOString()
      } : 'Error desconocido'
    };
  }
};
</script>

<style scoped>
.login-card {
  width: 100%;
  max-width: 400px;
}

pre {
  white-space: pre-wrap;
  word-wrap: break-word;
  font-size: 0.8rem;
  margin: 4px 0;
  padding: 8px;
  background: #f5f5f5;
  border-radius: 4px;
}
</style>