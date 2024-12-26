import { defineStore } from 'pinia';
import { ref, computed } from 'vue';
import { authService } from '../services/auth/auth.service';
import { authStorage } from '../services/auth/storage';

export const useAuthStore = defineStore('auth', () => {
  const user = ref(authStorage.getUser());
  const token = ref(authStorage.getToken());
  const initialized = ref(false);

  const isAuthenticated = computed(() => !!token.value && !!user.value);
  const userFullName = computed(() => user.value?.full_name || '');

  function initialize() {
    if (initialized.value) return;
    
    const storedToken = authStorage.getToken();
    const storedUser = authStorage.getUser();
    
    if (storedToken && storedUser) {
      token.value = storedToken;
      user.value = storedUser;
    }
    
    initialized.value = true;
  }

  async function login(username, password) {
    try {
      const response = await authService.login({ username, password });
      user.value = response.user;
      token.value = response.access_token;
      return true;
    } catch (error) {
      throw error;
    }
  }

  function logout() {
    authService.logout();
    user.value = null;
    token.value = null;
  }

  return {
    user,
    token,
    isAuthenticated,
    userFullName,
    initialize,
    login,
    logout
  };
});