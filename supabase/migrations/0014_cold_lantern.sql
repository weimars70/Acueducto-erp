/*
  # Create Receipts Table

  1. New Table
    - `caja_recibos` (Receipts)
      - `id` (serial, primary key)
      - `codigo` (integer, required)
      - `fecha` (timestamp)
      - `observacion` (text)
      - `tipo` (integer, FK to caja_recibos_tipo)
      - `cliente_codigo` (integer)
      - `instalacion_codigo` (integer, FK to instalaciones)
      - `activo` (boolean, default true)
      - `factura` (text)
      - `valor` (numeric(15,2), default 0)
      - `documento` (text)
      - `forma_pago` (integer, FK to formas_pagos)
      - `nro_nota` (integer, default 0)
      - `valor_nota` (numeric(15,2), default 0)

  2. Security
    - Enable RLS
    - Add policies for authenticated users
*/

-- Create the caja_recibos table
CREATE TABLE IF NOT EXISTS caja_recibos (
    id serial PRIMARY KEY,
    codigo integer NOT NULL,
    fecha timestamp,
    observacion text,
    tipo integer REFERENCES caja_recibos_tipo(codigo),
    cliente_codigo integer,
    instalacion_codigo integer,
    activo boolean DEFAULT true,
    factura text,
    valor numeric(15,2) DEFAULT 0 NOT NULL,
    documento text,
    forma_pago integer NOT NULL REFERENCES formas_pagos(codigo),
    nro_nota integer DEFAULT 0,
    valor_nota numeric(15,2) DEFAULT 0,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE caja_recibos ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Allow read access for authenticated users"
    ON caja_recibos
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Allow insert for authenticated users"
    ON caja_recibos
    FOR INSERT
    TO authenticated
    WITH CHECK (true);

CREATE POLICY "Allow update for admin users"
    ON caja_recibos
    FOR UPDATE
    TO authenticated
    USING (auth.jwt() ->> 'role' = 'admin')
    WITH CHECK (auth.jwt() ->> 'role' = 'admin');

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_caja_recibos_codigo ON caja_recibos(codigo);
CREATE INDEX IF NOT EXISTS idx_caja_recibos_fecha ON caja_recibos(fecha);
CREATE INDEX IF NOT EXISTS idx_caja_recibos_cliente ON caja_recibos(cliente_codigo);
CREATE INDEX IF NOT EXISTS idx_caja_recibos_instalacion ON caja_recibos(instalacion_codigo);
CREATE INDEX IF NOT EXISTS idx_caja_recibos_factura ON caja_recibos(factura);

-- Add column comments
COMMENT ON COLUMN caja_recibos.factura IS 'Campo factura para cuando el recibo de caja aplique a una factura';
COMMENT ON COLUMN caja_recibos.documento IS 'Puede ser por ejemplo numero transaccion';

-- Create trigger for updated_at
CREATE TRIGGER set_timestamp_caja_recibos
    BEFORE UPDATE ON caja_recibos
    FOR EACH ROW
    EXECUTE FUNCTION trigger_set_timestamp();

-- Add table comment
COMMENT ON TABLE caja_recibos IS 'Registro de recibos y documentos de caja';