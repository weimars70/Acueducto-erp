export interface JwtPayload {
  sub: string;
  username: string;
  role: string;
}

export interface AuthResponse {
  access_token: string;
  user: {
    id: string;
    username: string;
    full_name: string;
    role: string;
  };
}