/*
  # Insert Demo Users

  1. Data Insertion
    - Add demo users with hashed passwords
    - Include admin and regular user roles
  
  2. Security
    - Passwords are hashed using pgcrypto
    - Using temporary passwords that should be changed on first login
*/

-- Insert demo users with hashed passwords
INSERT INTO users (id, email, password_hash, full_name, role)
VALUES 
  (
    'd0d4ad7a-4df4-4ee6-811a-b2db187ca262',
    'admin@demo.com',
    crypt('admin123456', gen_salt('bf')),
    'Admin User',
    'admin'
  ),
  (
    'e1e5ad7b-5df5-5ee7-922a-c3ec187ca373',
    'user@demo.com',
    crypt('user123456', gen_salt('bf')),
    'Regular User',
    'user'
  )
ON CONFLICT (email) DO 
  UPDATE SET 
    password_hash = EXCLUDED.password_hash,
    full_name = EXCLUDED.full_name,
    role = EXCLUDED.role,
    updated_at = CURRENT_TIMESTAMP;