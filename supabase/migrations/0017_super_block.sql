/*
  # Insert Sample Installations Data

  1. Data Insertion
    - Creates 10 sample installations with varied data
    - Covers different sectors, cities, and usage types
    - Includes both active and inactive installations
    - Uses realistic values for all fields

  2. Data Distribution
    - Mix of residential and commercial installations
    - Different tax regimes and person types
    - Varied meter values and connection costs
*/

-- Insert sample installations
INSERT INTO instalaciones (
    codigo,
    ciudad_codigo,
    nombre,
    codigo_medidor,
    activo,
    direccion,
    estrato_codigo,
    sector_codigo,
    valor_medidor,
    cuota_medidor,
    valor_conexion,
    cuota_conexion,
    marca,
    uso,
    telefono,
    interes_medidor,
    interes_conexion,
    ident,
    nombres,
    primer_apellido,
    segundo_apellido,
    email,
    lectura,
    factura_fisica,
    regimen,
    tipo_persona,
    tipo_impuesto
)
VALUES 
    -- Residential Installation 1
    (1001, 'UIO', 'Casa Principal', 'MED001', true, 'Av. 6 de Diciembre N34-45', 3, 1, 
     150.00, 12.50, 200.00, 16.67, 'Neptune', 1, '0991234567', 0.05, 0.05,
     '1712345678', 'Juan Carlos', 'Pérez', 'Gómez', 'juan.perez@email.com', '1000',
     true, 1, 1, 1),

    -- Commercial Installation
    (1002, 'GYE', 'Local Comercial Centro', 'MED002', true, 'Av. 9 de Octubre 123', 4, 3,
     200.00, 16.67, 250.00, 20.83, 'Hydrus', 2, '0987654321', 0.05, 0.05,
     '0992345678001', 'Comercial', 'Express', 'S.A.', 'comercial@express.com', '2000',
     true, 2, 2, 1),

    -- Industrial Installation
    (1003, 'CUE', 'Fábrica Sur', 'MED003', true, 'Parque Industrial Lot 45', 5, 2,
     300.00, 25.00, 400.00, 33.33, 'Industrial Pro', 3, '0976543210', 0.05, 0.05,
     '0193456789001', 'Industrias', 'Modernas', null, 'info@modernas.com', '5000',
     true, 2, 2, 1),

    -- Residential Installation 2
    (1004, 'MTA', 'Departamento 3B', 'MED004', true, 'Cdla. Los Esteros Mz 4', 2, 4,
     150.00, 12.50, 200.00, 16.67, 'Neptune', 1, '0965432109', 0.05, 0.05,
     '1312345678', 'María', 'González', 'López', 'maria.g@email.com', '800',
     true, 1, 1, 2),

    -- Official Installation
    (1005, 'AMB', 'Municipalidad', 'MED005', true, 'Plaza Central', 3, 3,
     250.00, 20.83, 300.00, 25.00, 'Hydrus', 4, '0954321098', 0.00, 0.00,
     '1860000000001', 'Gobierno', 'Municipal', null, 'info@municipio.gob.ec', '3000',
     false, 1, 2, 4),

    -- Inactive Installation
    (1006, 'UIO', 'Local Antiguo', 'MED006', false, 'Calle Sucre 567', 3, 1,
     150.00, 12.50, 200.00, 16.67, 'Neptune', 2, '0943210987', 0.05, 0.05,
     '1712345679', 'Pedro', 'Martínez', 'Ruiz', 'pedro.m@email.com', '500',
     true, 1, 1, 1),

    -- Residential Installation 3
    (1007, 'GYE', 'Villa 123', 'MED007', true, 'Urb. La Joya Et. Rubí', 4, 5,
     150.00, 12.50, 200.00, 16.67, 'Neptune', 1, '0932109876', 0.05, 0.05,
     '0912345678', 'Ana', 'Castro', 'Mendoza', 'ana.c@email.com', '1200',
     true, 1, 1, 2),

    -- Commercial Installation 2
    (1008, 'CUE', 'Centro Comercial', 'MED008', true, 'Av. Remigio Crespo 432', 5, 3,
     250.00, 20.83, 300.00, 25.00, 'Hydrus', 2, '0921098765', 0.05, 0.05,
     '0192345678001', 'Comercial', 'del Sur', 'S.A.', 'info@ccsur.com', '4000',
     true, 2, 2, 1),

    -- Residential Installation 4
    (1009, 'MTA', 'Casa Playa', 'MED009', true, 'Barrio San Pedro 789', 3, 2,
     150.00, 12.50, 200.00, 16.67, 'Neptune', 1, '0910987654', 0.05, 0.05,
     '1312345679', 'Luis', 'Vélez', 'Mora', 'luis.v@email.com', '900',
     true, 1, 1, 2),

    -- Industrial Installation 2
    (1010, 'AMB', 'Planta Procesadora', 'MED010', true, 'Vía Industrial Km 5', 5, 4,
     300.00, 25.00, 400.00, 33.33, 'Industrial Pro', 3, '0909876543', 0.05, 0.05,
     '1860123456001', 'Procesadora', 'Industrial', 'S.A.', 'info@procesadora.com', '6000',
     true, 2, 2, 1)
ON CONFLICT (codigo) DO UPDATE 
SET 
    nombre = EXCLUDED.nombre,
    codigo_medidor = EXCLUDED.codigo_medidor,
    activo = EXCLUDED.activo,
    updated_at = now();