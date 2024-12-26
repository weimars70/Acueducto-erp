/*
  # Create Instalaciones View

  1. New View
    - view_instalaciones: Comprehensive view joining installation data with related tables
    
  2. Purpose
    - Provides a denormalized view of installations with all related information
    - Simplifies queries by combining data from multiple tables
    - Includes descriptive names for all foreign key relationships
*/

CREATE OR REPLACE VIEW view_instalaciones AS
SELECT 
    ins.codigo,
    ins.nombre,
    ins.ident,
    ins.direccion,
    ins.telefono,
    ins.ciudad_codigo,
    ciu.nombre AS ciudad_nombre,
    ins.estrato_codigo,
    est.nombre AS estrato_nombre,
    ins.sector_codigo,
    sec.nombre AS sector_nombre,
    ins.activo,
    ins.marca AS marca_codigo,
    mar.nombre AS marca_nombre,
    ins.uso AS uso_codigo,
    et.nombre AS uso_nombre,
    ins.codigo_medidor,
    ins.valor_medidor,
    ins.cuota_medidor,
    ins.valor_conexion,
    ins.cuota_conexion,
    ins.interes_medidor,
    ins.interes_conexion,
    ins.prefijo,
    ins.nombres,
    ins.primer_apellido,
    ins.segundo_apellido,
    ins.factura_fisica,
    ins.orden,
    ins.email,
    ins.dv,
    ins.regimen,
    tr.nombre AS n_regimen,
    ins.tipo_persona,
    tp.nombre AS n_tipo_persona,
    ins.tipo_impuesto,
    ti.nombre AS n_tipo_impuesto,
    ins.cliente
FROM instalaciones ins
JOIN ciudades ciu ON ins.ciudad_codigo = ciu.codigo
JOIN estratos est ON ins.estrato_codigo = est.codigo
JOIN sector sec ON ins.sector_codigo = sec.codigo
JOIN marcas_medidor mar ON ins.marca = mar.codigo::text
JOIN estratos_tipo et ON ins.uso = et.codigo
LEFT JOIN tipo_regimen tr ON tr.codigo = ins.regimen
LEFT JOIN tipo_persona tp ON tp.codigo = ins.tipo_persona
LEFT JOIN tipo_impuesto ti ON ti.codigo = ins.tipo_impuesto;

-- Add comment to view
COMMENT ON VIEW view_instalaciones IS 'Comprehensive view of installations with related information from all dependent tables';

-- Grant permissions
GRANT SELECT ON view_instalaciones TO authenticated;