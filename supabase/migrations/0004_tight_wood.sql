/*
  # Add username authentication
  
  1. Changes
    - Add username column to users table
    - Update existing users with usernames
    - Add unique constraint on username
  
  2. Security
    - Maintain existing RLS policies
*/

-- Add username column if it doesn't exist
DO $$ 
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'users' AND column_name = 'username') 
  THEN
    ALTER TABLE users ADD COLUMN username text UNIQUE;
  END IF;
END $$;

-- Update existing users with default usernames based on email
UPDATE users 
SET username = SPLIT_PART(email, '@', 1)
WHERE username IS NULL;

-- Make username required
ALTER TABLE users ALTER COLUMN username SET NOT NULL;