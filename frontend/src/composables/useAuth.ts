import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useQuasar } from 'quasar';
import { useAuthStore } from '../stores/auth';
import type { LoginCredentials } from '../services/auth/types';

export function useAuth() {
  const loading = ref(false);
  const router = useRouter();
  const $q = useQuasar();
  const authStore = useAuthStore();

  const login = async (credentials: LoginCredentials) => {
    console.log('credentials:::::', credentials);
    try {
      loading.value = true;
      console.log('Login attempt:', { 
        username: credentials.username,
        timestamp: new Date().toISOString()
      });
      
      const success = await authStore.login(credentials);
      
      console.log('Login result:', { 
        success,
        isAuthenticated: authStore.isAuthenticated,
        timestamp: new Date().toISOString()
      });

      if (success) {
        $q.notify({
          type: 'positive',
          message: 'Bienvenido',
          position: 'top'
        });
        await router.replace('/consumos');
      }
      
      return success;
    } catch (error) {
      console.error('Login error:', error);
      $q.notify({
        type: 'negative',
        message: error instanceof Error ? error.message : 'Error de autenticación',
        position: 'top',
        timeout: 3000
      });
      throw error;
    } finally {
      loading.value = false;
    }
  };

  return {
    login,
    loading
  };
}