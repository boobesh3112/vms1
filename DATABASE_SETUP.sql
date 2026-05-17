-- VMS (Vendor Management System) Database Schema
-- Run this in your Supabase SQL Editor
-- Dashboard: https://supabase.com/dashboard/project/ozvbqitkzuzbmzuzhmzq/sql

-- =====================================================
-- 1. PROFILES TABLE (extends auth.users)
-- =====================================================
CREATE TABLE IF NOT EXISTS profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  business_name TEXT NOT NULL,
  phone TEXT NOT NULL,
  address TEXT NOT NULL,
  logo TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Policies for profiles
CREATE POLICY "Users can view own profile"
  ON profiles FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
  ON profiles FOR INSERT
  WITH CHECK (auth.uid() = id);

-- =====================================================
-- 2. CLIENTS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS clients (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  phone TEXT NOT NULL,
  shop_name TEXT NOT NULL,
  address TEXT NOT NULL,
  email TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable Row Level Security
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;

-- Policies for clients
CREATE POLICY "Users can view own clients"
  ON clients FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own clients"
  ON clients FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own clients"
  ON clients FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own clients"
  ON clients FOR DELETE
  USING (auth.uid() = user_id);

-- Indexes for better performance
CREATE INDEX IF NOT EXISTS idx_clients_user_id ON clients(user_id);
CREATE INDEX IF NOT EXISTS idx_clients_shop_name ON clients(shop_name);
CREATE INDEX IF NOT EXISTS idx_clients_phone ON clients(phone);

-- =====================================================
-- 3. BILLS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS bills (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  client_id UUID REFERENCES clients(id) ON DELETE CASCADE NOT NULL,
  bill_number TEXT UNIQUE NOT NULL,
  amount NUMERIC(10, 2) NOT NULL CHECK (amount >= 0),
  due_date TIMESTAMP WITH TIME ZONE NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('paid', 'unpaid', 'partial')),
  paid_amount NUMERIC(10, 2) DEFAULT 0 CHECK (paid_amount >= 0),
  items JSONB NOT NULL,
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable Row Level Security
ALTER TABLE bills ENABLE ROW LEVEL SECURITY;

-- Policies for bills
CREATE POLICY "Users can view own bills"
  ON bills FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own bills"
  ON bills FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own bills"
  ON bills FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own bills"
  ON bills FOR DELETE
  USING (auth.uid() = user_id);

-- Indexes for better performance
CREATE INDEX IF NOT EXISTS idx_bills_user_id ON bills(user_id);
CREATE INDEX IF NOT EXISTS idx_bills_client_id ON bills(client_id);
CREATE INDEX IF NOT EXISTS idx_bills_status ON bills(status);
CREATE INDEX IF NOT EXISTS idx_bills_due_date ON bills(due_date);
CREATE INDEX IF NOT EXISTS idx_bills_bill_number ON bills(bill_number);

-- =====================================================
-- 4. PAYMENTS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS payments (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  bill_id UUID REFERENCES bills(id) ON DELETE CASCADE NOT NULL,
  client_id UUID REFERENCES clients(id) ON DELETE CASCADE NOT NULL,
  amount NUMERIC(10, 2) NOT NULL CHECK (amount > 0),
  method TEXT NOT NULL CHECK (method IN ('cash', 'card', 'upi', 'cheque', 'other')),
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable Row Level Security
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;

-- Policies for payments
CREATE POLICY "Users can view own payments"
  ON payments FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own payments"
  ON payments FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Indexes for better performance
CREATE INDEX IF NOT EXISTS idx_payments_user_id ON payments(user_id);
CREATE INDEX IF NOT EXISTS idx_payments_bill_id ON payments(bill_id);
CREATE INDEX IF NOT EXISTS idx_payments_client_id ON payments(client_id);

-- =====================================================
-- 5. FUNCTIONS AND TRIGGERS
-- =====================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = timezone('utc'::text, now());
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers for auto-updating updated_at
CREATE TRIGGER update_profiles_updated_at
  BEFORE UPDATE ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_clients_updated_at
  BEFORE UPDATE ON clients
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_bills_updated_at
  BEFORE UPDATE ON bills
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- 6. VIEWS FOR COMMON QUERIES
-- =====================================================

-- View for client statistics (payment reliability)
CREATE OR REPLACE VIEW client_statistics AS
SELECT
  c.id,
  c.user_id,
  c.name,
  c.shop_name,
  c.phone,
  c.email,
  c.address,
  COUNT(b.id) as total_bills,
  COUNT(CASE WHEN b.status = 'paid' THEN 1 END) as paid_bills,
  COUNT(CASE WHEN b.status = 'unpaid' THEN 1 END) as unpaid_bills,
  COUNT(CASE WHEN b.status = 'partial' THEN 1 END) as partial_bills,
  COALESCE(SUM(b.amount), 0) as total_amount,
  COALESCE(SUM(b.paid_amount), 0) as total_paid,
  COALESCE(SUM(b.amount - b.paid_amount), 0) as total_pending,
  CASE
    WHEN COUNT(b.id) = 0 THEN 0
    ELSE ROUND((COUNT(CASE WHEN b.status = 'paid' THEN 1 END)::NUMERIC / COUNT(b.id)::NUMERIC) * 100, 2)
  END as reliability_score,
  CASE
    WHEN COUNT(b.id) = 0 THEN 'new'
    WHEN ROUND((COUNT(CASE WHEN b.status = 'paid' THEN 1 END)::NUMERIC / COUNT(b.id)::NUMERIC) * 100, 2) >= 80 THEN 'good'
    WHEN ROUND((COUNT(CASE WHEN b.status = 'paid' THEN 1 END)::NUMERIC / COUNT(b.id)::NUMERIC) * 100, 2) >= 50 THEN 'average'
    ELSE 'risky'
  END as reliability_category,
  c.created_at,
  c.updated_at
FROM clients c
LEFT JOIN bills b ON c.id = b.client_id
GROUP BY c.id, c.user_id, c.name, c.shop_name, c.phone, c.email, c.address, c.created_at, c.updated_at;

-- =====================================================
-- 7. INITIAL DATA MIGRATION FUNCTION (OPTIONAL)
-- =====================================================

-- Function to create a profile after user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, name, business_name, phone, address)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'name', 'User'),
    COALESCE(NEW.raw_user_meta_data->>'business_name', 'Business'),
    COALESCE(NEW.raw_user_meta_data->>'phone', ''),
    COALESCE(NEW.raw_user_meta_data->>'address', '')
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to automatically create profile on signup
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================

-- Uncomment to verify setup:
-- SELECT * FROM profiles;
-- SELECT * FROM clients;
-- SELECT * FROM bills;
-- SELECT * FROM payments;
-- SELECT * FROM client_statistics;

-- =====================================================
-- NOTES
-- =====================================================
-- 1. Run this entire SQL script in Supabase SQL Editor
-- 2. Tables have Row Level Security (RLS) enabled
-- 3. Each user can only access their own data
-- 4. Indexes created for performance optimization
-- 5. Triggers auto-update timestamps
-- 6. View provides pre-calculated statistics
-- 7. Foreign keys ensure data integrity
-- 8. Check constraints validate data quality
