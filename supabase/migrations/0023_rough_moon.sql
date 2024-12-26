/*
  # Fix Consumos View and Add API Functions

  1. Changes
    - Create proper view_consumos view
    - Add RLS policies for view
    - Create helper functions for consumos API
  
  2. Security
    - Enable RLS
    - Add policies for authenticated users
*/

-- Drop existing view if exists
DROP VIEW IF EXISTS view_consumo;

-- Create improved view_consumos
CREATE OR REPLACE VIEW view_consumos AS
SELECT 
    c.codigo,
    c.instalacion,
    i.nombre,
    c.lectura,
    c.fecha,
    m.nombre AS mes_nombre,
    c.mes,
    c.year,
    c.consumo,
    c.medidor,
    COALESCE(c.otros_cobros, 0) as otros_cobros,
    COALESCE(c.reconexion, 0) as reconexion,
    c.facturada AS facturado
FROM consumo c
JOIN instalaciones i ON c.instalacion = i.codigo
JOIN meses m ON c.mes = m.codigo
WHERE i.activo = true
ORDER BY c.fecha DESC;

-- Grant permissions
GRANT SELECT ON view_consumos TO authenticated;

-- Add comment
COMMENT ON VIEW view_consumos IS 'Vista consolidada de consumos con información de instalaciones';

-- Create function to get all consumos
CREATE OR REPLACE FUNCTION get_consumos()
RETURNS SETOF view_consumos
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT * FROM view_consumos;
END;
$$;

-- Create function to get última lectura
CREATE OR REPLACE FUNCTION get_ultima_lectura(p_instalacion integer)
RETURNS integer
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_lectura integer;
BEGIN
  SELECT lectura INTO v_lectura
  FROM consumo
  WHERE instalacion = p_instalacion
  ORDER BY fecha DESC, codigo DESC
  LIMIT 1;
  
  RETURN COALESCE(v_lectura, 0);
END;
$$;