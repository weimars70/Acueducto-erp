/*
  # Update view_consumo field order

  1. Changes
    - Drop existing function and view
    - Recreate view with fields in the specified order:
      codigo, instalacion, nombre, medidor, mes, year, lectura, consumo, otros_cobros, reconexion, facturado
    - Recreate function
*/

-- First drop the dependent function
DROP FUNCTION IF EXISTS get_consumos();

-- Now we can safely drop the view
DROP VIEW IF EXISTS view_consumo;

-- Create improved view_consumo with correct field order
CREATE OR REPLACE VIEW view_consumo AS
SELECT 
    a.codigo,
    a.instalacion,
    d.nombre,
    CONCAT('M-', a.instalacion) as medidor,
    a.mes,
    a.year,
    a.lectura,
    a.consumo,
    COALESCE(a.otros_cobros, 0) as otros_cobros,
    COALESCE(a.reconexion, 0) as reconexion,
    a.facturada AS facturado
FROM consumo a
JOIN instalaciones d ON a.instalacion = d.codigo
WHERE d.activo = true
ORDER BY a.codigo DESC;

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
COMMENT ON VIEW view_consumo IS 'Vista consolidada de consumos con información de instalaciones en orden específico';