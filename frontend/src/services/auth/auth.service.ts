import api from '../api/axios';
import { authStorage } from './storage';
import type { LoginCredentials, AuthResponse } from './types';
import { handleApiError } from '../api/error-handler';
import { AUTH_ERROR_MESSAGES } from './constants';

export const authService = {
  async login(credentials: LoginCredentials): Promise<AuthResponse> {
    try {
      console.log('Sending login request:', { 
        username: credentials.username,
        password: '[REDACTED]' 
      });

      const { data } = await api.post<AuthResponse>('/api/auth/login', credentials);
      
      console.log('Raw response:', {
        status: 'success',
        hasData: !!data,
        timestamp: new Date().toISOString()
      });

      if (!data?.access_token || !data?.user) {
        console.error('Invalid response structure:', { 
          hasToken: !!data?.access_token, 
          hasUser: !!data?.user 
        });
        throw new Error(AUTH_ERROR_MESSAGES.INVALID_RESPONSE);
      }

      return data;
    } catch (error) {
      console.error('Login error:', error);
      throw handleApiError(error);
    }
  },

  logout(): void {
    authStorage.clear();
  }
};