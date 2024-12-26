/*
  # Update view_consumo and related functions

  1. Changes
    - Drop function that depends on the view first
    - Drop and recreate view with correct mes_codigo reference
    - Recreate function with updated view reference

  2. Order of Operations
    - Drop dependent function
    - Drop view
    - Create new view
    - Create new function
*/

-- First drop the dependent function
DROP FUNCTION IF EXISTS get_consumos();

-- Now we can safely drop the view
DROP VIEW IF EXISTS view_consumo;

-- Create improved view_consumo
CREATE OR REPLACE VIEW view_consumo AS
SELECT 
    a.codigo,
    a.instalacion,
    d.nombre,
    a.lectura,
    a.fecha,
    b.nombre AS mes_nombre,
    a.mes AS mes_codigo,
    a.year,
    a.consumo,
    CONCAT('M-', a.instalacion) as medidor,
    COALESCE(a.otros_cobros, 0) as otros_cobros,
    COALESCE(a.reconexion, 0) as reconexion,
    a.facturada AS facturado
FROM consumo a
JOIN meses b ON b.codigo = a.mes
JOIN instalaciones d ON a.instalacion = d.codigo
WHERE d.activo = true;

-- Recreate the function using the new view
CREATE OR REPLACE FUNCTION get_consumos()
RETURNS SETOF view_consumo
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT * FROM view_consumo;
END;
$$;

-- Grant permissions
GRANT SELECT ON view_consumo TO authenticated;

-- Add comment
COMMENT ON VIEW view_consumo IS 'Vista consolidada de consumos con información de instalaciones y meses';