import React from 'react';
import { useNavigate } from 'react-router-dom';
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { consumosApi } from '../../lib/api/consumos';
import { useConsumoForm } from './useConsumoForm';

export function ConsumoForm() {
  const navigate = useNavigate();
  const queryClient = useQueryClient();
  const { form, updateField } = useConsumoForm();

  const mutation = useMutation({
    mutationFn: consumosApi.create,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['consumos'] });
      navigate('/consumos');
    }
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    mutation.mutate({
      ...form,
      instalacion: Number(form.instalacion),
      lectura: Number(form.lectura)
    });
  };

  return (
    <div className="max-w-xl mx-auto">
      <h1 className="text-2xl font-bold mb-6">Nuevo Consumo</h1>
      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label className="block text-sm font-medium text-gray-700">
            Instalación
            <input
              type="number"
              value={form.instalacion}
              onChange={e => updateField('instalacion', e.target.value)}
              className="mt-1 block w-full rounded-md border-gray-300 shadow-sm"
              required
            />
          </label>
        </div>
        
        {/* Other form fields remain the same */}
      </form>
    </div>
  );
}