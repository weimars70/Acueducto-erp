/*
  # Create Tipo Persona Table

  1. New Table
    - `tipo_persona`
      - `codigo` (integer, primary key)
      - `nombre` (text, unique)
      - Added audit fields (created_at, updated_at)

  2. Security
    - Enable RLS
    - Add policies for authenticated users to read
    - Add policies for admin users to manage data

  3. Sample Data
    - Insert initial person types
*/

-- Create the tipo_persona table
CREATE TABLE IF NOT EXISTS tipo_persona (
    codigo integer PRIMARY KEY,
    nombre text NOT NULL UNIQUE,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE tipo_persona ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Allow read access for authenticated users"
    ON tipo_persona
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Allow all access for admin users"
    ON tipo_persona
    TO authenticated
    USING (auth.jwt() ->> 'role' = 'admin')
    WITH CHECK (auth.jwt() ->> 'role' = 'admin');

-- Insert sample data
INSERT INTO tipo_persona (codigo, nombre)
VALUES 
    (1, 'Natural'),
    (2, 'Jurídica'),
    (3, 'Extranjero')
ON CONFLICT (codigo) DO UPDATE 
SET 
    nombre = EXCLUDED.nombre,
    updated_at = now();

-- Create index for better performance
CREATE INDEX IF NOT EXISTS idx_tipo_persona_nombre ON tipo_persona(nombre);

-- Add table comment
COMMENT ON TABLE tipo_persona IS 'Tipos de persona para clasificación de usuarios';