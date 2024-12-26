/*
  # Create Meses Table and View Consumo

  1. New Tables
    - `meses`: Stores month information
      - `codigo` (integer, primary key)
      - `nombre` (text, month name)
      - `created_at` (timestamp)
      - `updated_at` (timestamp)

  2. Views
    - `view_consumo`: Combines consumption data with installation and month information
    
  3. Security
    - Enable RLS on meses table
    - Add policies for authenticated users
*/

-- Create meses table
CREATE TABLE IF NOT EXISTS meses (
    codigo integer PRIMARY KEY,
    nombre text NOT NULL UNIQUE,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE meses ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Allow read access for authenticated users"
    ON meses
    FOR SELECT
    TO authenticated
    USING (true);

-- Insert months data
INSERT INTO meses (codigo, nombre)
VALUES 
    (1, 'Enero'),
    (2, 'Febrero'),
    (3, 'Marzo'),
    (4, 'Abril'),
    (5, 'Mayo'),
    (6, 'Junio'),
    (7, 'Julio'),
    (8, 'Agosto'),
    (9, 'Septiembre'),
    (10, 'Octubre'),
    (11, 'Noviembre'),
    (12, 'Diciembre')
ON CONFLICT (codigo) DO UPDATE 
SET 
    nombre = EXCLUDED.nombre,
    updated_at = now();

-- Create index for better performance
CREATE INDEX IF NOT EXISTS idx_meses_nombre ON meses(nombre);

-- Create trigger for updated_at
CREATE TRIGGER set_timestamp_meses
    BEFORE UPDATE ON meses
    FOR EACH ROW
    EXECUTE FUNCTION trigger_set_timestamp();

-- Create view_consumo
CREATE OR REPLACE VIEW view_consumo AS
SELECT 
    a.codigo,
    a.instalacion,
    d.nombre,
    a.lectura,
    a.fecha,
    b.nombre AS mes,
    a.year,
    a.medidor AS mes_codigo,
    a.consumo,
    a.medidor,
    a.otros_cobros,
    a.reconexion,
    a.facturada AS facturado
FROM consumo a
JOIN meses b ON b.codigo = a.mes
JOIN instalaciones d ON a.instalacion = d.codigo;

-- Add comments
COMMENT ON TABLE meses IS 'Catálogo de meses del año';
COMMENT ON VIEW view_consumo IS 'Vista que combina información de consumos con instalaciones y meses';