/*
  # Update view_consumo

  1. Changes
    - Fix mes_codigo to correctly reference meses.codigo instead of medidor
    - Maintain all existing fields and joins
    - Improve field naming for clarity

  2. View Updates
    - Drop existing view
    - Create updated view with correct mes join
*/

-- Drop existing view
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
    a.mes AS mes_codigo, -- Fix: Use mes field as mes_codigo
    a.year,
    a.consumo,
    a.medidor,
    COALESCE(a.otros_cobros, 0) as otros_cobros,
    COALESCE(a.reconexion, 0) as reconexion,
    a.facturada AS facturado
FROM consumo a
JOIN meses b ON b.codigo = a.mes -- Fix: Join using mes field
JOIN instalaciones d ON a.instalacion = d.codigo
WHERE d.activo = true;

-- Grant permissions
GRANT SELECT ON view_consumo TO authenticated;

-- Add comment
COMMENT ON VIEW view_consumo IS 'Vista consolidada de consumos con información de instalaciones y meses';