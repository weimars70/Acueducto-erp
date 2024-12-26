/*
  # Update medidor format

  1. Changes
    - Update instalaciones.codigo_medidor to format 'M-{codigo}'
    - Update consumo.medidor to format 'M-{codigo}'
    - Add trigger to automatically format new medidor entries

  2. Data Updates
    - Format existing medidor values in both tables
*/

-- Update instalaciones table
UPDATE instalaciones 
SET codigo_medidor = CONCAT('M-', codigo)
WHERE codigo_medidor NOT LIKE 'M-%';

-- Update consumo table
UPDATE consumo 
SET medidor = CONCAT('M-', instalacion)
WHERE medidor NOT LIKE 'M-%';

-- Create trigger function for instalaciones
CREATE OR REPLACE FUNCTION format_medidor_code()
RETURNS TRIGGER AS $$
BEGIN
  NEW.codigo_medidor = CONCAT('M-', NEW.codigo);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for instalaciones
DROP TRIGGER IF EXISTS format_medidor_on_insert ON instalaciones;
CREATE TRIGGER format_medidor_on_insert
  BEFORE INSERT ON instalaciones
  FOR EACH ROW
  EXECUTE FUNCTION format_medidor_code();

-- Create trigger function for consumo
CREATE OR REPLACE FUNCTION format_consumo_medidor()
RETURNS TRIGGER AS $$
BEGIN
  NEW.medidor = CONCAT('M-', NEW.instalacion);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for consumo
DROP TRIGGER IF EXISTS format_consumo_medidor_on_insert ON consumo;
CREATE TRIGGER format_consumo_medidor_on_insert
  BEFORE INSERT ON consumo
  FOR EACH ROW
  EXECUTE FUNCTION format_consumo_medidor();