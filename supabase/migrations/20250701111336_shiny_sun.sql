-- Migration: Create Return Clothing Tracker Schema
-- This migration creates the necessary tables, policies, and functions for the Return Clothing Tracker app

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Drop existing policies if they exist to avoid conflicts
DO $$ 
BEGIN
    -- Drop policies for users table
    DROP POLICY IF EXISTS "Users can insert own data" ON public.users;
    DROP POLICY IF EXISTS "Users can update own data" ON public.users;
    DROP POLICY IF EXISTS "Users can view own data" ON public.users;
    
    -- Drop policies for return_items table
    DROP POLICY IF EXISTS "Users can manage own return items" ON public.return_items;
    
    -- Drop trigger and function if they exist
    DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
    DROP FUNCTION IF EXISTS public.handle_new_user();
EXCEPTION
    WHEN OTHERS THEN
        -- Ignore errors if objects don't exist
        NULL;
END $$;

-- Create users table (extends auth.users)
CREATE TABLE IF NOT EXISTS public.users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL,
    full_name TEXT,
    avatar_url TEXT,
    phone TEXT,
    preferences JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Create return_items table
CREATE TABLE IF NOT EXISTS public.return_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    item_name TEXT NOT NULL,
    brand TEXT NOT NULL,
    store TEXT NOT NULL,
    category TEXT NOT NULL,
    size TEXT NOT NULL,
    color TEXT NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    purchase_date DATE NOT NULL,
    return_deadline DATE NOT NULL,
    receipt_number TEXT,
    order_number TEXT,
    item_photos TEXT[] DEFAULT '{}'::text[],
    condition TEXT NOT NULL,
    reason_for_return TEXT,
    is_online_purchase BOOLEAN DEFAULT false,
    store_location TEXT,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'inProgress', 'completed', 'expired')),
    notes TEXT,
    receipt_url TEXT,
    returned_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Create indexes for performance (only if they don't exist)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_return_items_user_id') THEN
        CREATE INDEX idx_return_items_user_id ON public.return_items(user_id);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_return_items_status') THEN
        CREATE INDEX idx_return_items_status ON public.return_items(status);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_return_items_deadline') THEN
        CREATE INDEX idx_return_items_deadline ON public.return_items(return_deadline);
    END IF;
END $$;

-- Enable Row Level Security
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.return_items ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for users table
CREATE POLICY "Users can insert own data" ON public.users
    FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update own data" ON public.users
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can view own data" ON public.users
    FOR SELECT USING (auth.uid() = id);

-- Create RLS policy for return_items table
CREATE POLICY "Users can manage own return items" ON public.return_items
    FOR ALL USING (auth.uid() = user_id);

-- Function to handle new user creation
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, full_name)
  VALUES (
    NEW.id, 
    NEW.email, 
    COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email)
  )
  ON CONFLICT (id) DO UPDATE SET
    email = EXCLUDED.email,
    full_name = COALESCE(EXCLUDED.full_name, users.full_name),
    updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger to handle new user creation
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Insert some sample data for testing (optional)
DO $$
BEGIN
    -- Only insert if no data exists
    IF NOT EXISTS (SELECT 1 FROM public.users LIMIT 1) THEN
        -- This will be populated when users sign up
        NULL;
    END IF;
END $$;