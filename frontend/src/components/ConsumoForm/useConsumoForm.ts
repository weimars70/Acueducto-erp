import { useState } from 'react';

export function useConsumoForm() {
  const [form, setForm] = useState({
    instalacion: '',
    lectura: '',
    fecha: '',
    medidor: '',
    mes: new Date().getMonth() + 1,
    year: new Date().getFullYear(),
    procesado: false
  });

  const updateField = (field: keyof typeof form, value: string | number | boolean) => {
    setForm(prev => ({ ...prev, [field]: value }));
  };

  return {
    form,
    updateField
  };
}