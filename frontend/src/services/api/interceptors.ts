import type { AxiosInstance } from 'axios';
import { authStorage } from '../auth/storage';

export const setupInterceptors = (api: AxiosInstance): void => {
  // Request interceptor
  api.interceptors.request.use(
    (config) => {
      const token = authStorage.getToken();
      if (token) {
        config.headers.Authorization = `Bearer ${token}`;
      }
      return config;
    },
    (error) => Promise.reject(error)
  );

  // Response interceptor
  api.interceptors.response.use(
    (response) => response,
    (error) => {
      if (error.response?.status === 401) {
        authStorage.clear();
        window.location.href = '/login';
      }
      return Promise.reject(error);
    }
  );
};