export const formatDate = (date: string): string => {
  return new Date(date).toLocaleDateString('es-ES');
};

export const formatPeriodo = (mes: number, year: number): string => {
  return `${mes}/${year}`;
};

export const getStatusColor = (facturado: boolean): string => {
  return facturado ? 'positive' : 'warning';
};

export const getStatusText = (facturado: boolean): string => {
  return facturado ? 'Facturado' : 'Pendiente';
};