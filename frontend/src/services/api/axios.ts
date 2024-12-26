import axios from 'axios';
import { API_CONFIG } from './config';
import { setupInterceptors } from './interceptors';

const api = axios.create(API_CONFIG);
setupInterceptors(api);

export default api;