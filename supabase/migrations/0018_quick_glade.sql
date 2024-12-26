/*
  # Insert Sample Data for Receipts and Details

  1. Data Insertion
    - Creates sample receipts with varied payment methods and types
    - Includes receipt details with different values and documents
    - Links to existing installations
    - Covers different scenarios (active/inactive, with/without notes)

  2. Data Distribution
    - Mix of payment methods
    - Different receipt types
    - Various amounts and dates
*/

-- Insert sample receipts
INSERT INTO caja_recibos (
    codigo,
    fecha,
    observacion,
    tipo,
    instalacion_codigo,
    activo,
    factura,
    valor,
    documento,
    forma_pago,
    nro_nota,
    valor_nota
)
VALUES 
    -- Regular payment receipt
    (1001, '2024-03-01 09:00:00', 'Pago mensual', 1, 1001, true, 'F001-001', 150.00, 'TRANS-001', 1, 0, 0),
    
    -- Credit card payment
    (1002, '2024-03-01 10:30:00', 'Pago con tarjeta', 1, 1002, true, 'F001-002', 200.00, 'CC-4589', 2, 0, 0),
    
    -- Payment with credit note
    (1003, '2024-03-01 11:45:00', 'Pago parcial con nota de crédito', 1, 1003, true, 'F001-003', 300.00, 'TRANS-002', 1, 1, 50.00),
    
    -- Bank transfer
    (1004, '2024-03-01 14:20:00', 'Transferencia bancaria', 1, 1004, true, 'F001-004', 175.00, 'TRF-2024001', 4, 0, 0),
    
    -- Inactive receipt
    (1005, '2024-03-01 15:30:00', 'Anulado por error', 1, 1005, false, 'F001-005', 225.00, 'CHQ-001', 5, 0, 0),
    
    -- Large payment
    (1006, '2024-03-02 09:15:00', 'Pago trimestral', 1, 1006, true, 'F001-006', 450.00, 'TRANS-003', 4, 0, 0),
    
    -- Multiple payments
    (1007, '2024-03-02 10:45:00', 'Pago mixto', 1, 1007, true, 'F001-007', 180.00, 'MIX-001', 1, 0, 0),
    
    -- Commercial client
    (1008, '2024-03-02 11:30:00', 'Pago comercial', 1, 1008, true, 'F001-008', 550.00, 'TRANS-004', 2, 0, 0),
    
    -- Industrial client
    (1009, '2024-03-02 14:00:00', 'Pago industrial', 1, 1009, true, 'F001-009', 800.00, 'TRF-2024002', 4, 0, 0),
    
    -- Payment with note
    (1010, '2024-03-02 15:45:00', 'Pago con observaciones', 1, 1010, true, 'F001-010', 275.00, 'CC-4590', 2, 2, 25.00);

-- Insert sample receipt details
INSERT INTO caja_recibos_detalle (
    recibo_id,
    codigo,
    valor,
    documento,
    activo
)
VALUES 
    -- Details for receipt 1001
    (1, 1, 150.00, 'DET-001', true),
    
    -- Details for receipt 1002
    (2, 1, 200.00, 'DET-002', true),
    
    -- Details for receipt 1003 (split payment)
    (3, 1, 250.00, 'DET-003-1', true),
    (3, 2, 50.00, 'DET-003-2', true),
    
    -- Details for receipt 1004
    (4, 1, 175.00, 'DET-004', true),
    
    -- Details for receipt 1005 (inactive)
    (5, 1, 225.00, 'DET-005', false),
    
    -- Details for receipt 1006 (multiple items)
    (6, 1, 300.00, 'DET-006-1', true),
    (6, 2, 150.00, 'DET-006-2', true),
    
    -- Details for receipt 1007
    (7, 1, 180.00, 'DET-007', true),
    
    -- Details for receipt 1008
    (8, 1, 550.00, 'DET-008', true),
    
    -- Details for receipt 1009 (split payment)
    (9, 1, 500.00, 'DET-009-1', true),
    (9, 2, 300.00, 'DET-009-2', true),
    
    -- Details for receipt 1010
    (10, 1, 275.00, 'DET-010', true);