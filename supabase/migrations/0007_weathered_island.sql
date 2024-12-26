/*
  # Create Tipo Regimen Table

  1. New Tables
    - `tipo_regimen`
      - `codigo` (integer, primary key)
      - `nombre` (text, unique)
      - `code` (text)

  2. Security
    - Enable RLS on `tipo_regimen` table
    - Add policies for authenticated users to read data
    - Add policies for admin users to manage data

  3. Sample Data
    - Insert initial regimen types
*/

-- Create the tipo_regimen table
CREATE TABLE IF NOT EXISTS tipo_regimen (
    codigo integer PRIMARY KEY,
    nombre text NOT NULL UNIQUE,
    code text NOT NULL,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE tipo_regimen ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Allow read access for authenticated users"
    ON tipo_regimen
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Allow all access for admin users"
    ON tipo_regimen
    TO authenticated
    USING (auth.jwt() ->> 'role' = 'admin')
    WITH CHECK (auth.jwt() ->> 'role' = 'admin');

-- Insert sample data
INSERT INTO tipo_regimen (codigo, nombre, code)
VALUES 
    (1, 'Régimen General', 'GENERAL'),
    (2, 'Régimen Especial', 'ESPECIAL'),
    (3, 'Régimen Simplificado', 'SIMPLIFICADO')
ON CONFLICT (codigo) DO UPDATE 
SET 
    nombre = EXCLUDED.nombre,
    code = EXCLUDED.code,
    updated_at = now();

-- Create updated_at trigger
CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_timestamp
    BEFORE UPDATE ON tipo_regimen
    FOR EACH ROW
    EXECUTE FUNCTION trigger_set_timestamp();

-- Create index for better performance
CREATE INDEX IF NOT EXISTS idx_tipo_regimen_code ON tipo_regimen(code);

-- Add table comment
COMMENT ON TABLE tipo_regimen IS 'Tipos de régimen para clasificación de consumos';