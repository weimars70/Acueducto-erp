-- Insert sample consumos data
INSERT INTO consumo (
    codigo,
    instalacion,
    lectura,
    fecha,
    consumo,
    mes,
    year,
    medidor,
    otros_cobros,
    reconexion,
    facturada
)
VALUES 
    (146003, 1001, 3103, '2024-01-15', 6, 1, 2024, '1', 0, 0, true),
    (146004, 1002, 632, '2024-01-15', 9, 1, 2024, '2', 0, 0, true),
    (146005, 1003, 5460, '2024-01-15', 17, 1, 2024, '3', 0, 0, true),
    (146006, 1004, 625, '2024-01-15', 13, 1, 2024, '20251141', 0, 0, true),
    (146007, 1005, 4172, '2024-01-15', 20, 1, 2024, '5', 0, 0, true),
    (146008, 1006, 1173, '2024-01-15', 12, 1, 2024, '6', 0, 0, true),
    (146009, 1007, 2194, '2024-01-15', 10, 1, 2024, '7', 0, 0, true),
    (146010, 1008, 7189, '2024-01-15', 36, 1, 2024, '8', 0, 0, true),
    (146011, 1009, 2940, '2024-01-15', 6, 1, 2024, '9', 0, 0, true),
    (146012, 1010, 31, '2024-01-15', 12, 1, 2024, '23025583', 0, 0, true)
ON CONFLICT (codigo) DO UPDATE 
SET 
    instalacion = EXCLUDED.instalacion,
    lectura = EXCLUDED.lectura,
    fecha = EXCLUDED.fecha,
    consumo = EXCLUDED.consumo,
    mes = EXCLUDED.mes,
    year = EXCLUDED.year,
    medidor = EXCLUDED.medidor,
    otros_cobros = EXCLUDED.otros_cobros,
    reconexion = EXCLUDED.reconexion,
    facturada = EXCLUDED.facturada;

-- Update instalaciones names to match the view
UPDATE instalaciones 
SET 
    nombre = CASE codigo
        WHEN 1001 THEN 'VASQUEZ DANIEL'
        WHEN 1002 THEN 'ILDEMIR VASQUEZ'
        WHEN 1003 THEN 'VASQUEZ LOAIZA LEIDY'
        WHEN 1004 THEN 'VASQUEZ SAMUEL'
        WHEN 1005 THEN 'MARIA VICTORIA REINOSA'
        WHEN 1006 THEN 'CASTAÑO OSCAR'
        WHEN 1007 THEN 'CASTAÑO OSCAR'
        WHEN 1008 THEN 'VICTORIA PELAEZ'
        WHEN 1009 THEN 'JORGE AGUDELO'
        WHEN 1010 THEN 'QUIROZ ANA DEL CARMEN'
    END
WHERE codigo IN (1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010);