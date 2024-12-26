/*
  # Add Additional Tax Regimes

  1. Changes
    - Add new tax regime types to existing table
    - Update existing regimes with standardized codes
  
  Note: Table and policies already exist from previous migration
*/

-- Insert additional tax regimes
INSERT INTO tipo_regimen (codigo, nombre, code)
VALUES 
    (4, 'Régimen de Microempresas', 'MICRO'),
    (5, 'Régimen Agropecuario', 'AGRO'),
    (6, 'Régimen de Importación', 'IMP'),
    (7, 'Régimen de Exportación', 'EXP'),
    (8, 'Régimen Zona Franca', 'ZF'),
    (9, 'Régimen No Contribuyente', 'NC'),
    (10, 'Régimen RIMPE', 'RIMPE')
ON CONFLICT (codigo) DO UPDATE 
SET 
    nombre = EXCLUDED.nombre,
    code = EXCLUDED.code,
    updated_at = now();

-- Update existing regimes with standardized codes
UPDATE tipo_regimen 
SET 
    code = 'GEN',
    updated_at = now()
WHERE codigo = 1 AND code = 'GENERAL';

UPDATE tipo_regimen 
SET 
    code = 'ESP',
    updated_at = now()
WHERE codigo = 2 AND code = 'ESPECIAL';

UPDATE tipo_regimen 
SET 
    code = 'SIMP',
    updated_at = now()
WHERE codigo = 3 AND code = 'SIMPLIFICADO';