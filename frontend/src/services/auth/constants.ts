export const AUTH_ERROR_MESSAGES = {
  INVALID_CREDENTIALS: 'Usuario o contraseña incorrectos',
  USER_NOT_FOUND: 'Usuario no encontrado',
  UNAUTHORIZED: 'No autorizado',
  SERVER_ERROR: 'Error del servidor',
  INVALID_RESPONSE: 'Respuesta inválida del servidor'
} as const;

export const ENDPOINTS = {
  LOGIN: '/auth/login'
} as const;