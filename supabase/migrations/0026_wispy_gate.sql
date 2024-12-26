-- First drop the function that depends on view_consumos
DROP FUNCTION IF EXISTS get_consumos();

-- Now we can safely drop the views
DROP VIEW IF EXISTS view_consumos CASCADE;
DROP VIEW IF EXISTS view_consumo CASCADE;

-- Create view_consumo
CREATE OR REPLACE VIEW view_consumo AS
SELECT 
    a.codigo,
    a.instalacion,
    d.nombre,
    a.lectura,
    a.fecha,
    b.nombre AS mes_nombre,
    a.mes,
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

-- Grant permissions
GRANT SELECT ON view_consumo TO authenticated;

-- Add comment
COMMENT ON VIEW view_consumo IS 'Vista consolidada de consumos con información de instalaciones y meses';

-- Recreate the get_consumos function
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