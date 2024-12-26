import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useQuasar } from 'quasar';
import { useAuthStore } from '../stores/auth';
import { AUTH_ERROR_MESSAGES } from '../services/auth/constants';

export function useAuth() {
  const loading = ref(false);
  const router = useRouter();
  const $q = useQuasar();
  const authStore = useAuthStore();

  const login = async (username, password) => {
    console.log(':::username:::', username);
    console.log(':::password:::', username.password);
    try {
      loading.value = true;
      await authStore.login(username.username, username.password);
      
      $q.notify({
        type: 'positive',
        message: 'Bienvenido',
        position: 'top'
      });
      
      await router.replace('/consumos');
    } catch (error) {
      const message = error?.message || AUTH_ERROR_MESSAGES.SERVER_ERROR;
      $q.notify({
        type: 'negative',
        message,
        position: 'top'
      });
    } finally {
      loading.value = false;
    }
  };

  return {
    login,
    loading
  };
}