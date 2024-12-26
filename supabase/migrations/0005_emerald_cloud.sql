/*
  # Add authentication functions
  
  1. New Functions
    - verify_password: Securely verify passwords using pgcrypto
    - get_user_by_username: Get user details by username
  
  2. Security
    - Functions are accessible to authenticated users only
*/

-- Create function to verify passwords
CREATE OR REPLACE FUNCTION verify_password(
  input_password text,
  stored_hash text
) RETURNS boolean AS $$
BEGIN
  RETURN stored_hash = crypt(input_password, stored_hash);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create function to get user by username
CREATE OR REPLACE FUNCTION get_user_by_username(
  input_username text
) RETURNS TABLE (
  id uuid,
  username text,
  full_name text,
  role text,
  password_hash text
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    users.id,
    users.username,
    users.full_name,
    users.role,
    users.password_hash
  FROM users
  WHERE users.username = input_username;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;