import { defineStore } from 'pinia';
import { ref, computed } from 'vue';
import { authService } from '../services/auth/auth.service';
import { authStorage } from '../services/auth/storage';
import type { User, LoginCredentials } from '../services/auth/types';

export const useAuthStore = defineStore('auth', () => {
  const user = ref<User | null>(authStorage.getUser());
  const token = ref<string | null>(authStorage.getToken());
  const initialized = ref(false);

  const isAuthenticated = computed(() => !!token.value && !!user.value);
  const userFullName = computed(() => user.value?.full_name || '');

  function initialize() {
    if (initialized.value) return;
    
    const storedUser = authStorage.getUser();
    const storedToken = authStorage.getToken();
    
    if (storedToken && storedUser) {
      user.value = storedUser;
      token.value = storedToken;
    }
    
    initialized.value = true;
  }

  async function login(credentials: LoginCredentials) {
    try {
      console.log('Auth store: login attempt', { 
        username: credentials.username 
      });

      const response = await authService.login(credentials);
      
      console.log('Auth store: login response received', {
        success: true,
        hasToken: !!response.access_token,
        hasUser: !!response.user
      });

      if (response.access_token && response.user) {
        token.value = response.access_token;
        user.value = response.user;
        authStorage.setToken(response.access_token);
        authStorage.setUser(response.user);
        return true;
      }
      
      return false;
    } catch (error) {
      console.error('Auth store: login error', error);
      token.value = null;
      user.value = null;
      throw error;
    }
  }

  function logout() {
    console.log('Auth store: logging out');
    authService.logout();
    token.value = null;
    user.value = null;
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