/*
  # Update consumos view with improved columns

  1. Changes
    - Drop existing function that depends on the view
    - Drop existing views
    - Create new view with updated columns
    - Recreate function with new view
  
  2. Security
    - Grant SELECT permissions to authenticated users
*/

-- First drop the dependent function
DROP FUNCTION IF EXISTS get_consumos();

-- Now we can safely drop the views
DROP VIEW IF EXISTS view_consumo;
DROP VIEW IF EXISTS view_consumos;

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
    c.facturada AS facturado,
    i.codigo_medidor
FROM consumo c
JOIN instalaciones i ON c.instalacion = i.codigo
JOIN meses m ON c.mes = m.codigo
WHERE i.activo = true
ORDER BY c.fecha DESC, c.codigo DESC;

-- Recreate the function using the new view
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

-- Grant permissions
GRANT SELECT ON view_consumos TO authenticated;

-- Add comment
COMMENT ON VIEW view_consumos IS 'Vista consolidada de consumos con información de instalaciones y meses';