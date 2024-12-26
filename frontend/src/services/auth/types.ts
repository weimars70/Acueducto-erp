export interface LoginCredentials {
  username: string;
  password: string;
}

export interface User {
  id: string;
  username: string;
  full_name: string;
  role: string;
}

export interface AuthResponse {
  access_token: string;
  user: User;
}