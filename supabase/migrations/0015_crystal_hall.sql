/*
  # Create Receipt Details Table

  1. New Table
    - `caja_recibos_detalle` (Receipt Details)
      - `id` (serial, primary key)
      - `recibo_id` (integer, FK to caja_recibos)
      - `codigo` (integer, required)
      - `valor` (numeric(12,2), required)
      - `documento` (text)
      - `activo` (boolean, default true)

  2. Security
    - Enable RLS
    - Add policies for authenticated users
*/

-- Create the caja_recibos_detalle table
CREATE TABLE IF NOT EXISTS caja_recibos_detalle (
    id serial PRIMARY KEY,
    recibo_id integer NOT NULL REFERENCES caja_recibos(id),
    codigo integer NOT NULL,
    valor numeric(12,2) NOT NULL,
    documento text,
    activo boolean DEFAULT true,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE caja_recibos_detalle ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Allow read access for authenticated users"
    ON caja_recibos_detalle
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Allow insert for authenticated users"
    ON caja_recibos_detalle
    FOR INSERT
    TO authenticated
    WITH CHECK (true);

CREATE POLICY "Allow update for admin users"
    ON caja_recibos_detalle
    FOR UPDATE
    TO authenticated
    USING (auth.jwt() ->> 'role' = 'admin')
    WITH CHECK (auth.jwt() ->> 'role' = 'admin');

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_caja_recibos_detalle_recibo ON caja_recibos_detalle(recibo_id);
CREATE INDEX IF NOT EXISTS idx_caja_recibos_detalle_codigo ON caja_recibos_detalle(codigo);

-- Create trigger for updated_at
CREATE TRIGGER set_timestamp_caja_recibos_detalle
    BEFORE UPDATE ON caja_recibos_detalle
    FOR EACH ROW
    EXECUTE FUNCTION trigger_set_timestamp();

-- Add table comment
COMMENT ON TABLE caja_recibos_detalle IS 'Detalles de los recibos de caja';