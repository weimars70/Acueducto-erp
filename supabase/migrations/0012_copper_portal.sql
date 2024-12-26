/*
  # Create Payment Methods Table

  1. New Table
    - `formas_pagos` (Payment Methods)
      - `codigo` (serial, primary key)
      - `descripcion` (text, unique)
      - Added audit fields for tracking

  2. Security
    - Enable RLS
    - Add read policy for authenticated users
    - Add management policy for admin users

  3. Sample Data
    - Insert common payment methods
*/

-- Create the formas_pagos table
CREATE TABLE IF NOT EXISTS formas_pagos (
    codigo serial PRIMARY KEY,
    descripcion text NOT NULL UNIQUE,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE formas_pagos ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Allow read access for authenticated users"
    ON formas_pagos
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Allow all access for admin users"
    ON formas_pagos
    TO authenticated
    USING (auth.jwt() ->> 'role' = 'admin')
    WITH CHECK (auth.jwt() ->> 'role' = 'admin');

-- Insert sample payment methods
INSERT INTO formas_pagos (descripcion)
VALUES 
    ('Efectivo'),
    ('Tarjeta de Crédito'),
    ('Tarjeta de Débito'),
    ('Transferencia Bancaria'),
    ('Cheque')
ON CONFLICT (descripcion) DO UPDATE 
SET 
    updated_at = now();

-- Create index for better performance
CREATE INDEX IF NOT EXISTS idx_formas_pagos_descripcion ON formas_pagos(descripcion);

-- Add table comment
COMMENT ON TABLE formas_pagos IS 'Métodos de pago disponibles en el sistema';

-- Create trigger for updated_at
CREATE TRIGGER set_timestamp_formas_pagos
    BEFORE UPDATE ON formas_pagos
    FOR EACH ROW
    EXECUTE FUNCTION trigger_set_timestamp();