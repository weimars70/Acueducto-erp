export const calculateConsumo = (lectura: number, ultimaLectura: number): number => {
  return Math.max(0, lectura - (ultimaLectura || 0));
};

export const validateLectura = (lectura: number, ultimaLectura: number): boolean => {
  return lectura >= (ultimaLectura || 0);
};