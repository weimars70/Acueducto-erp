/*
  # Create Receipt Types Table

  1. New Table
    - `caja_recibos_tipo` (Receipt Types)
      - `codigo` (serial, primary key)
      - `nombre` (text, unique)
      - Added audit fields for tracking

  2. Security
    - Enable RLS
    - Add read policy for authenticated users
    - Add management policy for admin users

  3. Sample Data
    - Insert common receipt types
*/

-- Create the caja_recibos_tipo table
CREATE TABLE IF NOT EXISTS caja_recibos_tipo (
    codigo serial PRIMARY KEY,
    nombre text NOT NULL UNIQUE,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE caja_recibos_tipo ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Allow read access for authenticated users"
    ON caja_recibos_tipo
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Allow all access for admin users"
    ON caja_recibos_tipo
    TO authenticated
    USING (auth.jwt() ->> 'role' = 'admin')
    WITH CHECK (auth.jwt() ->> 'role' = 'admin');

-- Insert sample receipt types
INSERT INTO caja_recibos_tipo (nombre)
VALUES 
    ('Factura'),
    ('Nota de Crédito'),
    ('Nota de Débito'),
    ('Comprobante de Pago'),
    ('Recibo de Caja')
ON CONFLICT (nombre) DO UPDATE 
SET 
    updated_at = now();

-- Create index for better performance
CREATE INDEX IF NOT EXISTS idx_caja_recibos_tipo_nombre ON caja_recibos_tipo(nombre);

-- Add table comment
COMMENT ON TABLE caja_recibos_tipo IS 'Tipos de recibos y documentos de caja';

-- Create trigger for updated_at
CREATE TRIGGER set_timestamp_caja_recibos_tipo
    BEFORE UPDATE ON caja_recibos_tipo
    FOR EACH ROW
    EXECUTE FUNCTION trigger_set_timestamp();