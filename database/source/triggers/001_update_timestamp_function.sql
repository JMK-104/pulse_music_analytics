-- =================================================================
-- Purpose: Reusable trigger function that automatically updates the
-- updated_at timestamp before a row is modified
-- This function is shared across all source tables that
-- contain an updated_at column.
-- =================================================================

CREATE OR REPLACE FUNCTION source.update_updated_at_column()
RETURNS TRIGGER
LANGUAGE plpgsql
AS
$$
BEGIN
    NEW.updated_at := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;
