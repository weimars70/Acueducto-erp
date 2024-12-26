/*
  # Create Tax and Identification Type Tables

  1. New Tables
    - `tipo_impuesto` (Tax Types)
      - `codigo` (integer, primary key)
      - `nombre` (text, unique)
      - `code` (text)
      - Added audit fields
    
    - `tipo_ident` (Identification Types)
      - `codigo` (integer, primary key)
      - `nombre` (text, unique)
      - `abreviado` (text)
      - Added audit fields

  2. Security
    - Enable RLS for both tables
    - Add read policies for authenticated users
    - Add management policies for admin users

  3. Sample Data
    - Insert initial tax types
    - Insert common identification types
*/

-- Create the tipo_impuesto table
CREATE TABLE IF NOT EXISTS tipo_impuesto (
    codigo integer PRIMARY KEY,
    nombre text NOT NULL UNIQUE,
    code text NOT NULL,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- Enable RLS for tipo_impuesto
ALTER TABLE tipo_impuesto ENABLE ROW LEVEL SECURITY;

-- Create policies for tipo_impuesto
CREATE POLICY "Allow read access for authenticated users"
    ON tipo_impuesto
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Allow all access for admin users"
    ON tipo_impuesto
    TO authenticated
    USING (auth.jwt() ->> 'role' = 'admin')
    WITH CHECK (auth.jwt() ->> 'role' = 'admin');

-- Insert sample tax types
INSERT INTO tipo_impuesto (codigo, nombre, code)
VALUES 
    (1, 'IVA 12%', 'IVA12'),
    (2, 'IVA 0%', 'IVA0'),
    (3, 'No Objeto de Impuesto', 'NOI'),
    (4, 'Exento de IVA', 'EIVA')
ON CONFLICT (codigo) DO UPDATE 
SET 
    nombre = EXCLUDED.nombre,
    code = EXCLUDED.code,
    updated_at = now();

-- Create the tipo_ident table
CREATE TABLE IF NOT EXISTS tipo_ident (
    codigo integer PRIMARY KEY,
    nombre text NOT NULL UNIQUE,
    abreviado text,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- Enable RLS for tipo_ident
ALTER TABLE tipo_ident ENABLE ROW LEVEL SECURITY;

-- Create policies for tipo_ident
CREATE POLICY "Allow read access for authenticated users"
    ON tipo_ident
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Allow all access for admin users"
    ON tipo_ident
    TO authenticated
    USING (auth.jwt() ->> 'role' = 'admin')
    WITH CHECK (auth.jwt() ->> 'role' = 'admin');

-- Insert sample identification types
INSERT INTO tipo_ident (codigo, nombre, abreviado)
VALUES 
    (1, 'Cédula', 'CED'),
    (2, 'RUC', 'RUC'),
    (3, 'Pasaporte', 'PAS'),
    (4, 'Identificación del Exterior', 'IDE')
ON CONFLICT (codigo) DO UPDATE 
SET 
    nombre = EXCLUDED.nombre,
    abreviado = EXCLUDED.abreviado,
    updated_at = now();

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_tipo_impuesto_code ON tipo_impuesto(code);
CREATE INDEX IF NOT EXISTS idx_tipo_ident_abreviado ON tipo_ident(abreviado);

-- Add table comments
COMMENT ON TABLE tipo_impuesto IS 'Tipos de impuestos aplicables a las transacciones';
COMMENT ON TABLE tipo_ident IS 'Tipos de identificación para personas naturales y jurídicas';