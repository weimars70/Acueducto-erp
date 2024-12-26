/*
  # Authentication Setup Update

  1. Extensions
    - Enable pgcrypto for password hashing
  
  2. Updates
    - Add authentication-related fields to users table
    - Create demo user with proper UUID
*/

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Add new fields to users table if they don't exist
DO $$ 
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'users' AND column_name = 'password_hash') 
  THEN
    ALTER TABLE users ADD COLUMN password_hash text;
  END IF;

  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'users' AND column_name = 'role') 
  THEN
    ALTER TABLE users ADD COLUMN role text DEFAULT 'user';
  END IF;
END $$;

-- Update or insert demo user with proper UUID
INSERT INTO users (id, email, password_hash, full_name, role)
VALUES (
    'a1b2c3d4-e5f6-4321-a123-123456789abc'::uuid,
    'admin@demo.com',
    crypt('admin123456', gen_salt('bf')),
    'Admin Demo',
    'admin'
) 
ON CONFLICT (email) 
DO UPDATE SET 
    password_hash = EXCLUDED.password_hash,
    full_name = EXCLUDED.full_name,
    role = EXCLUDED.role,
    updated_at = CURRENT_TIMESTAMP;