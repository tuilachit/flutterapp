/*
  # Initial Schema Setup for ReturnPal App

  1. New Tables
    - `users` - User profiles linked to auth.users
    - `return_items` - Return items with all tracking information
  
  2. Security
    - Enable RLS on all tables
    - Add policies for user-specific data access
    - Set up auth triggers
*/

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

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

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_return_items_user_id ON public.return_items(user_id);
CREATE INDEX IF NOT EXISTS idx_return_items_status ON public.return_items(status);
CREATE INDEX IF NOT EXISTS idx_return_items_deadline ON public.return_items(return_deadline);

-- Enable Row Level Security
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.return_items ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
-- Users can manage their own data
CREATE POLICY "Users can insert own data" ON public.users
    FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update own data" ON public.users
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can view own data" ON public.users
    FOR SELECT USING (auth.uid() = id);

-- Return items policies
CREATE POLICY "Users can manage own return items" ON public.return_items
    FOR ALL USING (auth.uid() = user_id);

-- Function to handle new user creation
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, full_name)
  VALUES (NEW.id, NEW.email, NEW.raw_user_meta_data->>'full_name');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to create user profile on signup
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();