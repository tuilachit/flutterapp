-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Enable Row Level Security
ALTER DEFAULT PRIVILEGES REVOKE EXECUTE ON FUNCTIONS FROM PUBLIC;

-- Create users table (extends auth.users)
CREATE TABLE IF NOT EXISTS public.users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT,
    full_name TEXT,
    avatar_url TEXT,
    preferences JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS on users table
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- Users can read and update their own data
CREATE POLICY "Users can view own profile" ON public.users
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON public.users
    FOR UPDATE USING (auth.uid() = id);

-- Create stores table
CREATE TABLE IF NOT EXISTS public.stores (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name TEXT NOT NULL,
    logo_url TEXT,
    default_return_policy_days INTEGER NOT NULL DEFAULT 30,
    website TEXT,
    customer_service_phone TEXT,
    customer_service_email TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Stores are public readable
ALTER TABLE public.stores ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Stores are publicly readable" ON public.stores
    FOR SELECT TO PUBLIC USING (true);

-- Create return_items table
CREATE TABLE IF NOT EXISTS public.return_items (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
    store_id UUID REFERENCES public.stores(id),
    barcode TEXT,
    item_name TEXT NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    currency TEXT NOT NULL DEFAULT 'USD',
    purchase_date DATE NOT NULL,
    return_deadline DATE NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'expired', 'processing')),
    receipt_image_url TEXT,
    item_image_url TEXT,
    tags TEXT[],
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS on return_items
ALTER TABLE public.return_items ENABLE ROW LEVEL SECURITY;

-- Users can only access their own return items
CREATE POLICY "Users can view own return items" ON public.return_items
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own return items" ON public.return_items
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own return items" ON public.return_items
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own return items" ON public.return_items
    FOR DELETE USING (auth.uid() = user_id);

-- Function to automatically create user profile
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.users (id, email, full_name)
    VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email)
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to call the function when a new user signs up
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Insert default stores
INSERT INTO public.stores (name, default_return_policy_days, website) VALUES
    ('H&M', 30, 'https://hm.com'),
    ('Zara', 30, 'https://zara.com'),
    ('Uniqlo', 30, 'https://uniqlo.com'),
    ('Nike', 30, 'https://nike.com'),
    ('Adidas', 30, 'https://adidas.com'),
    ('Amazon', 30, 'https://amazon.com'),
    ('Target', 90, 'https://target.com'),
    ('Walmart', 90, 'https://walmart.com'),
    ('Other', 30, null)
ON CONFLICT DO NOTHING;

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_return_items_user_id ON public.return_items(user_id);
CREATE INDEX IF NOT EXISTS idx_return_items_status ON public.return_items(status);
CREATE INDEX IF NOT EXISTS idx_return_items_return_deadline ON public.return_items(return_deadline);
CREATE INDEX IF NOT EXISTS idx_users_email ON public.users(email);

-- Create storage buckets (optional - for future file uploads)
INSERT INTO storage.buckets (id, name, public) 
VALUES 
    ('receipts', 'receipts', false),
    ('item_photos', 'item_photos', false)
ON CONFLICT (id) DO NOTHING;

-- Storage policies for receipts bucket
CREATE POLICY "Users can upload their own receipts" ON storage.objects
    FOR INSERT WITH CHECK (bucket_id = 'receipts' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users can view their own receipts" ON storage.objects
    FOR SELECT USING (bucket_id = 'receipts' AND auth.uid()::text = (storage.foldername(name))[1]);

-- Storage policies for item photos bucket
CREATE POLICY "Users can upload their own item photos" ON storage.objects
    FOR INSERT WITH CHECK (bucket_id = 'item_photos' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users can view their own item photos" ON storage.objects
    FOR SELECT USING (bucket_id = 'item_photos' AND auth.uid()::text = (storage.foldername(name))[1]); 