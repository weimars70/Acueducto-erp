import api from '../api/axios';
import { authStorage } from './storage';

export const authService = {
  async login({ username, password }) {
    try {
      const { data } = await api.post('/api/auth/login', { username, password });
      if (data.access_token) {
        authStorage.setToken(data.access_token);
        authStorage.setUser(data.user);
      }
      return data;
    } catch (error) {
      const message = error.response?.data?.message || 'Error de autenticación';
      throw new Error(message);
    }
  },

  logout() {
    authStorage.clear();
  }
};