/*
  # Create Marcas Medidor Table

  1. New Tables
    - `marcas_medidor`: Stores meter brands
      - `codigo` (integer, primary key, auto-generated)
      - `nombre` (text, unique, brand name)
      - `created_at` (timestamp)
      - `updated_at` (timestamp)

  2. Security
    - Enable RLS
    - Add policies for authenticated users
    - Add policy for admin users to manage brands

  3. Sample Data
    - Insert common meter brands
*/

-- Create marcas_medidor table
CREATE TABLE IF NOT EXISTS marcas_medidor (
    codigo integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre text NOT NULL,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now(),
    CONSTRAINT marcas_medidor_nombre_key UNIQUE(nombre)
);

-- Enable RLS
ALTER TABLE marcas_medidor ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Allow read access for authenticated users"
    ON marcas_medidor
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Allow all access for admin users"
    ON marcas_medidor
    TO authenticated
    USING (auth.jwt() ->> 'role' = 'admin')
    WITH CHECK (auth.jwt() ->> 'role' = 'admin');

-- Insert sample meter brands
INSERT INTO marcas_medidor (nombre)
VALUES 
    ('Neptune'),
    ('Sensus'),
    ('Itron'),
    ('Badger Meter'),
    ('Kamstrup'),
    ('Elster'),
    ('Arad'),
    ('Mueller Systems'),
    ('Zenner'),
    ('Diehl Metering')
ON CONFLICT (nombre) DO UPDATE 
SET 
    updated_at = now();

-- Create index for better performance
CREATE INDEX IF NOT EXISTS idx_marcas_medidor_nombre ON marcas_medidor(nombre);

-- Create trigger for updated_at
CREATE TRIGGER set_timestamp_marcas_medidor
    BEFORE UPDATE ON marcas_medidor
    FOR EACH ROW
    EXECUTE FUNCTION trigger_set_timestamp();

-- Add table comment
COMMENT ON TABLE marcas_medidor IS 'Catálogo de marcas de medidores de agua';