import type { AxiosError } from 'axios';
import type { ApiError } from './types';
import { AUTH_ERROR_MESSAGES } from '../auth/constants';

export const handleApiError = (error: AxiosError<ApiError>): never => {
  console.error('API Error:', {
    status: error.response?.status,
    data: error.response?.data,
    message: error.message
  });

  // Handle specific error cases
  if (error.response?.status === 401) {
    throw new Error(AUTH_ERROR_MESSAGES.INVALID_CREDENTIALS);
  }

  if (error.response?.status === 404) {
    throw new Error(AUTH_ERROR_MESSAGES.USER_NOT_FOUND);
  }

  // Use server message if available, fallback to default message
  const message = error.response?.data?.message || AUTH_ERROR_MESSAGES.SERVER_ERROR;
  throw new Error(message);
};