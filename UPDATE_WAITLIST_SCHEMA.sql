-- Update waitlist table schema - Remove code system, add name and phone
-- Run this in your Supabase SQL Editor

-- Remove code-related columns
ALTER TABLE public.waitlist 
  DROP COLUMN IF EXISTS access_code,
  DROP COLUMN IF EXISTS status,
  DROP COLUMN IF EXISTS code_used_at,
  DROP COLUMN IF EXISTS expires_at;

-- Add name and phone columns
ALTER TABLE public.waitlist 
  ADD COLUMN IF NOT EXISTS name VARCHAR(255),
  ADD COLUMN IF NOT EXISTS phone VARCHAR(20);

-- Update existing records to have empty name and phone (optional)
UPDATE public.waitlist 
SET name = '', phone = '' 
WHERE name IS NULL OR phone IS NULL;

-- Make name and phone required for new records
ALTER TABLE public.waitlist 
  ALTER COLUMN name SET NOT NULL,
  ALTER COLUMN phone SET NOT NULL;

-- Add indexes for better performance
CREATE INDEX IF NOT EXISTS idx_waitlist_name ON public.waitlist(name);
CREATE INDEX IF NOT EXISTS idx_waitlist_phone ON public.waitlist(phone);

-- Drop the old RPC functions (no longer needed)
DROP FUNCTION IF EXISTS public.generate_access_code();
DROP FUNCTION IF EXISTS public.validate_access_code(VARCHAR);

-- Update the waitlist_stats view to remove code-related stats
CREATE OR REPLACE VIEW public.waitlist_stats AS
SELECT 
    COUNT(*) as total_signups,
    COUNT(*) FILTER (WHERE created_at >= CURRENT_DATE) as today_signups,
    COUNT(*) FILTER (WHERE created_at >= CURRENT_DATE - INTERVAL '7 days') as week_signups,
    COUNT(*) FILTER (WHERE created_at >= CURRENT_DATE - INTERVAL '30 days') as month_signups,
    COUNT(DISTINCT source) as unique_sources,
    source,
    COUNT(*) as signups_by_source
FROM public.waitlist
GROUP BY ROLLUP(source);

-- Grant permissions
GRANT SELECT ON public.waitlist_stats TO anon, authenticated;
