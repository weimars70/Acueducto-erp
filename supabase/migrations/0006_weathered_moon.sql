/*
  # Create Consumo Table

  1. New Tables
    - `consumo`
      - `codigo` (serial, primary key)
      - `instalacion` (integer, required)
      - `lectura` (integer, required)
      - `fecha` (date, required)
      - `consumo` (integer, required)
      - `mes` (integer)
      - `year` (integer)
      - `medidor` (text)
      - `otros_cobros` (numeric, default 0)
      - `reconexion` (numeric, default 0)
      - `usuario` (text)
      - `facturada` (boolean, default false)

  2. Security
    - Enable RLS on `consumo` table
    - Add policies for authenticated users to:
      - Read all consumos
      - Create new consumos
      - Update their own consumos
*/

-- Create consumo table
CREATE TABLE IF NOT EXISTS consumo (
    codigo serial PRIMARY KEY,
    instalacion integer NOT NULL,
    lectura integer NOT NULL,
    fecha date NOT NULL,
    consumo integer NOT NULL,
    mes integer,
    year integer,
    medidor text,
    otros_cobros numeric(12,0) DEFAULT 0 NOT NULL,
    reconexion numeric(12,0) DEFAULT 0,
    usuario text,
    facturada boolean DEFAULT false NOT NULL,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE consumo ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Allow read access for authenticated users"
    ON consumo
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Allow insert access for authenticated users"
    ON consumo
    FOR INSERT
    TO authenticated
    WITH CHECK (true);

CREATE POLICY "Allow update access for own consumos"
    ON consumo
    FOR UPDATE
    TO authenticated
    USING (auth.uid()::text = usuario)
    WITH CHECK (auth.uid()::text = usuario);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_consumo_instalacion ON consumo(instalacion);
CREATE INDEX IF NOT EXISTS idx_consumo_fecha ON consumo(fecha);
CREATE INDEX IF NOT EXISTS idx_consumo_medidor ON consumo(medidor);
CREATE INDEX IF NOT EXISTS idx_consumo_usuario ON consumo(usuario);

-- Create function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to update updated_at
CREATE TRIGGER update_consumo_updated_at
    BEFORE UPDATE ON consumo
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Add comment to table
COMMENT ON TABLE consumo IS 'Table to store consumption records';