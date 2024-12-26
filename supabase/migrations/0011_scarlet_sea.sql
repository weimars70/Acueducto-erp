/*
  # Create Sector and Social Strata Tables

  1. New Tables
    - `sector` (Sectors)
      - `codigo` (serial, primary key)
      - `nombre` (text, unique)
      - Added audit fields
    
    - `estratos` (Social Strata)
      - `codigo` (serial, primary key)
      - `nombre` (text, unique)
      - Added audit fields

  2. Security
    - Enable RLS for both tables
    - Add read policies for authenticated users
    - Add management policies for admin users

  3. Sample Data
    - Insert initial sectors
    - Insert common social strata levels
*/

-- Create the sector table
CREATE TABLE IF NOT EXISTS sector (
    codigo serial PRIMARY KEY,
    nombre text NOT NULL UNIQUE,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- Enable RLS for sector
ALTER TABLE sector ENABLE ROW LEVEL SECURITY;

-- Create policies for sector
CREATE POLICY "Allow read access for authenticated users"
    ON sector
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Allow all access for admin users"
    ON sector
    TO authenticated
    USING (auth.jwt() ->> 'role' = 'admin')
    WITH CHECK (auth.jwt() ->> 'role' = 'admin');

-- Insert sample sectors
INSERT INTO sector (nombre)
VALUES 
    ('Norte'),
    ('Sur'),
    ('Centro'),
    ('Este'),
    ('Oeste')
ON CONFLICT (nombre) DO UPDATE 
SET 
    updated_at = now();

-- Create the estratos table
CREATE TABLE IF NOT EXISTS estratos (
    codigo serial PRIMARY KEY,
    nombre text NOT NULL UNIQUE,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- Enable RLS for estratos
ALTER TABLE estratos ENABLE ROW LEVEL SECURITY;

-- Create policies for estratos
CREATE POLICY "Allow read access for authenticated users"
    ON estratos
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Allow all access for admin users"
    ON estratos
    TO authenticated
    USING (auth.jwt() ->> 'role' = 'admin')
    WITH CHECK (auth.jwt() ->> 'role' = 'admin');

-- Insert sample social strata
INSERT INTO estratos (nombre)
VALUES 
    ('Bajo'),
    ('Medio Bajo'),
    ('Medio'),
    ('Medio Alto'),
    ('Alto')
ON CONFLICT (nombre) DO UPDATE 
SET 
    updated_at = now();

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_sector_nombre ON sector(nombre);
CREATE INDEX IF NOT EXISTS idx_estratos_nombre ON estratos(nombre);

-- Add table comments
COMMENT ON TABLE sector IS 'Sectores geográficos para clasificación de ubicaciones';
COMMENT ON TABLE estratos IS 'Niveles de estrato social para clasificación de usuarios';

-- Create triggers for updated_at
CREATE TRIGGER set_timestamp_sector
    BEFORE UPDATE ON sector
    FOR EACH ROW
    EXECUTE FUNCTION trigger_set_timestamp();

CREATE TRIGGER set_timestamp_estratos
    BEFORE UPDATE ON estratos
    FOR EACH ROW
    EXECUTE FUNCTION trigger_set_timestamp();