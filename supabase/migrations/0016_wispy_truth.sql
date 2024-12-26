/*
  # Create Installations Table

  1. New Tables
    - `estratos_tipo` (Usage Types)
      - `codigo` (integer, primary key)
      - `nombre` (text, unique)
    - `instalaciones` (Installations)
      - All fields from the original schema with proper types and constraints
      - Added audit fields (created_at, updated_at)

  2. Security
    - Enable RLS on both tables
    - Add policies for authenticated users

  3. Relationships
    - Foreign keys to all related tables
    - Proper indexing for performance
*/

-- Create estratos_tipo table first (missing dependency)
CREATE TABLE IF NOT EXISTS estratos_tipo (
    codigo integer PRIMARY KEY,
    nombre text NOT NULL UNIQUE,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- Enable RLS for estratos_tipo
ALTER TABLE estratos_tipo ENABLE ROW LEVEL SECURITY;

-- Create policies for estratos_tipo
CREATE POLICY "Allow read access for authenticated users"
    ON estratos_tipo
    FOR SELECT
    TO authenticated
    USING (true);

-- Insert basic usage types
INSERT INTO estratos_tipo (codigo, nombre)
VALUES 
    (1, 'Residencial'),
    (2, 'Comercial'),
    (3, 'Industrial'),
    (4, 'Oficial')
ON CONFLICT (codigo) DO NOTHING;

-- Create instalaciones table
CREATE TABLE IF NOT EXISTS instalaciones (
    codigo integer PRIMARY KEY,
    ciudad_codigo text NOT NULL REFERENCES ciudades(codigo),
    nombre text NOT NULL,
    codigo_medidor varchar(50) NOT NULL,
    activo boolean DEFAULT true NOT NULL,
    direccion text,
    estrato_codigo integer NOT NULL REFERENCES estratos(codigo),
    sector_codigo integer NOT NULL REFERENCES sector(codigo),
    valor_medidor numeric(12,2) DEFAULT 0,
    cuota_medidor numeric(12,2) DEFAULT 0,
    valor_conexion numeric(12,2) DEFAULT 0,
    cuota_conexion numeric(12,2) DEFAULT 0,
    marca text NOT NULL,
    uso integer NOT NULL REFERENCES estratos_tipo(codigo),
    telefono text,
    interes_medidor numeric(12,2) DEFAULT 0,
    interes_conexion numeric(12,2) DEFAULT 0,
    ident text,
    prefijo text DEFAULT 'M' NOT NULL,
    nombres text,
    primer_apellido text,
    segundo_apellido text,
    orden integer,
    email text,
    lectura text,
    factura_fisica boolean,
    dv integer,
    regimen integer REFERENCES tipo_regimen(codigo),
    tipo_persona integer REFERENCES tipo_persona(codigo),
    tipo_impuesto integer REFERENCES tipo_impuesto(codigo),
    cliente integer,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE instalaciones ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Allow read access for authenticated users"
    ON instalaciones
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Allow insert for authenticated users"
    ON instalaciones
    FOR INSERT
    TO authenticated
    WITH CHECK (true);

CREATE POLICY "Allow update for admin users"
    ON instalaciones
    FOR UPDATE
    TO authenticated
    USING (auth.jwt() ->> 'role' = 'admin')
    WITH CHECK (auth.jwt() ->> 'role' = 'admin');

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_instalaciones_ciudad ON instalaciones(ciudad_codigo);
CREATE INDEX IF NOT EXISTS idx_instalaciones_estrato ON instalaciones(estrato_codigo);
CREATE INDEX IF NOT EXISTS idx_instalaciones_sector ON instalaciones(sector_codigo);
CREATE INDEX IF NOT EXISTS idx_instalaciones_uso ON instalaciones(uso);
CREATE INDEX IF NOT EXISTS idx_instalaciones_codigo_medidor ON instalaciones(codigo_medidor);
CREATE INDEX IF NOT EXISTS idx_instalaciones_cliente ON instalaciones(cliente);
CREATE INDEX IF NOT EXISTS idx_instalaciones_activo ON instalaciones(activo);

-- Create trigger for updated_at
CREATE TRIGGER set_timestamp_instalaciones
    BEFORE UPDATE ON instalaciones
    FOR EACH ROW
    EXECUTE FUNCTION trigger_set_timestamp();

-- Add table comments
COMMENT ON TABLE instalaciones IS 'Registro de instalaciones y medidores';
COMMENT ON TABLE estratos_tipo IS 'Tipos de uso para las instalaciones';

-- Add column comments
COMMENT ON COLUMN instalaciones.codigo_medidor IS 'Código único del medidor';
COMMENT ON COLUMN instalaciones.valor_medidor IS 'Costo del medidor';
COMMENT ON COLUMN instalaciones.cuota_medidor IS 'Valor de la cuota mensual del medidor';
COMMENT ON COLUMN instalaciones.valor_conexion IS 'Costo de la conexión';
COMMENT ON COLUMN instalaciones.cuota_conexion IS 'Valor de la cuota mensual de la conexión';
COMMENT ON COLUMN instalaciones.interes_medidor IS 'Interés aplicado al medidor';
COMMENT ON COLUMN instalaciones.interes_conexion IS 'Interés aplicado a la conexión';