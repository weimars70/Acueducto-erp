/*
  # Create Ciudades Table

  1. New Tables
    - `ciudades`
      - `codigo` (text, primary key)
      - `nombre` (text)
      - Added audit fields (created_at, updated_at)

  2. Security
    - Enable RLS on `ciudades` table
    - Add policies for authenticated users to read data
    - Add policies for admin users to manage data

  3. Sample Data
    - Insert initial cities
*/

-- Create the ciudades table
CREATE TABLE IF NOT EXISTS ciudades (
    codigo text PRIMARY KEY,
    nombre text NOT NULL,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE ciudades ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Allow read access for authenticated users"
    ON ciudades
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Allow all access for admin users"
    ON ciudades
    TO authenticated
    USING (auth.jwt() ->> 'role' = 'admin')
    WITH CHECK (auth.jwt() ->> 'role' = 'admin');

-- Insert sample data
INSERT INTO ciudades (codigo, nombre)
VALUES 
    ('UIO', 'Quito'),
    ('GYE', 'Guayaquil'),
    ('CUE', 'Cuenca'),
    ('MTA', 'Manta'),
    ('AMB', 'Ambato')
ON CONFLICT (codigo) DO UPDATE 
SET 
    nombre = EXCLUDED.nombre,
    updated_at = now();

-- Create updated_at trigger
CREATE TRIGGER set_timestamp
    BEFORE UPDATE ON ciudades
    FOR EACH ROW
    EXECUTE FUNCTION trigger_set_timestamp();

-- Create index for better performance
CREATE INDEX IF NOT EXISTS idx_ciudades_nombre ON ciudades(nombre);

-- Add table comment
COMMENT ON TABLE ciudades IS 'Catálogo de ciudades del sistema';