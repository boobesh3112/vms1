# 🚀 Supabase Backend Setup Guide

Your VMS application is now connected to Supabase! Follow these steps to set up the database and start using cloud storage.

---

## ✅ Prerequisites

- ✅ Supabase project connected
- ✅ Project ID: `ozvbqitkzuzbmzuzhmzq`
- ✅ Dashboard: https://supabase.com/dashboard/project/ozvbqitkzuzbmzuzhmzq

---

## 📋 Setup Steps

### Step 1: Create Database Tables

1. **Open Supabase SQL Editor:**
   - Go to: https://supabase.com/dashboard/project/ozvbqitkzuzbmzuzhmzq/sql
   - Or navigate to: Dashboard → SQL Editor

2. **Run the Setup Script:**
   - Open the file `/workspaces/default/code/DATABASE_SETUP.sql` in this project
   - Copy the entire contents
   - Paste into Supabase SQL Editor
   - Click "Run" button

3. **Verify Tables Created:**
   - Go to: Dashboard → Table Editor
   - You should see these tables:
     - ✅ `profiles`
     - ✅ `clients`
     - ✅ `bills`
     - ✅ `payments`
   - And this view:
     - ✅ `client_statistics`

### Step 2: Verify Row Level Security (RLS)

1. Go to: Dashboard → Authentication → Policies
2. Verify that each table has policies:
   - `profiles`: 3 policies (select, update, insert)
   - `clients`: 4 policies (select, insert, update, delete)
   - `bills`: 4 policies (select, insert, update, delete)
   - `payments`: 2 policies (select, insert)

3. **What RLS Does:**
   - Each user can only access their own data
   - No user can see another user's clients, bills, or payments
   - Automatic data isolation

### Step 3: Test Authentication

1. **Enable Email Auth (if not already enabled):**
   - Go to: Dashboard → Authentication → Providers
   - Ensure "Email" is enabled
   - Email confirmations can be disabled for testing

2. **Optional: Configure Email Templates:**
   - Go to: Dashboard → Authentication → Email Templates
   - Customize signup/reset password emails

---

## 🎯 What's Been Set Up

### Database Schema

```
profiles (users)
├── id (UUID, primary key)
├── email (unique)
├── name
├── business_name
├── phone
├── address
├── logo (optional)
├── created_at
└── updated_at

clients
├── id (UUID, primary key)
├── user_id (foreign key → profiles)
├── name
├── phone
├── shop_name
├── address
├── email (optional)
├── created_at
└── updated_at

bills
├── id (UUID, primary key)
├── user_id (foreign key → profiles)
├── client_id (foreign key → clients)
├── bill_number (unique)
├── amount
├── due_date
├── status (paid/unpaid/partial)
├── paid_amount
├── items (JSONB)
├── notes
├── created_at
└── updated_at

payments
├── id (UUID, primary key)
├── user_id (foreign key → profiles)
├── bill_id (foreign key → bills)
├── client_id (foreign key → clients)
├── amount
├── method (cash/card/upi/cheque/other)
├── notes
└── created_at
```

### Automatic Features

✅ **Row Level Security:** Users can only see their own data  
✅ **Auto Timestamps:** `created_at` and `updated_at` auto-managed  
✅ **Profile Creation:** Profile created automatically on signup  
✅ **Data Validation:** Check constraints ensure data quality  
✅ **Foreign Keys:** Maintain referential integrity  
✅ **Indexes:** Optimized for fast queries  
✅ **Views:** Pre-calculated statistics for performance  

---

## 🔄 Migrating from localStorage to Supabase

### Current Implementation

The app is currently using `localStorage` (client-side storage). All your code is ready to use Supabase, but you need to switch the providers.

### How to Switch

**Option A: Use Supabase (Recommended)**

Edit `src/app/App.tsx` and change:

```tsx
// OLD: localStorage version
import { AuthProvider, useAuth } from '../contexts/AuthContext';

// NEW: Supabase version
import { SupabaseAuthProvider as AuthProvider, useSupabaseAuth as useAuth } from '../contexts/SupabaseAuthContext';
```

**Option B: Keep localStorage**

No changes needed! Current implementation works perfectly for single-user, single-device use.

---

## 🧪 Testing the Setup

### Test 1: Create an Account

1. Open your VMS application
2. Click "Sign up"
3. Fill in details:
   - Email: `test@example.com`
   - Password: `password123`
   - Name: `Test User`
   - Business: `Test Business`
   - Phone: `+1234567890`
   - Address: `123 Test St`
4. Click "Create Account"

**What Happens:**
- Supabase Auth creates user account
- Database trigger creates profile automatically
- User is logged in
- Profile data appears in dashboard

### Test 2: Verify Data in Supabase

1. Go to: Dashboard → Table Editor → `profiles`
2. You should see your test user
3. Check `clients`, `bills`, `payments` tables (will be empty initially)

### Test 3: Add a Client

1. In VMS app, go to "Clients"
2. Click "+ Add Client"
3. Fill in client details
4. Save

**Verify:**
- Go to Supabase → Table Editor → `clients`
- You should see the new client
- Note the `user_id` matches your profile ID

### Test 4: Create a Bill

1. Create a bill for the client
2. Check Supabase → Table Editor → `bills`
3. Verify bill appears with correct client_id

---

## 🔐 Security Best Practices

### ✅ What's Already Secured

- Row Level Security (RLS) enabled on all tables
- Users can only access their own data
- SQL injection prevention (parameterized queries)
- Authentication tokens (JWT) managed by Supabase
- HTTPS connections enforced

### 🔒 Additional Recommendations

1. **Email Verification:**
   - Enable in: Dashboard → Authentication → Settings
   - Prevents fake signups

2. **Password Requirements:**
   - Enforce strong passwords
   - Consider password reset flow

3. **Rate Limiting:**
   - Configure in Supabase dashboard
   - Prevent abuse

4. **Backup Strategy:**
   - Supabase provides automatic backups
   - Consider additional export strategy

---

## 📊 Using the Statistics View

The `client_statistics` view provides pre-calculated reliability scores:

```typescript
// Example query
const stats = await supabaseStorage.getClientStatistics(userId);

// Returns:
{
  id: "client-uuid",
  name: "Client Name",
  shop_name: "Shop Name",
  total_bills: 10,
  paid_bills: 8,
  unpaid_bills: 2,
  reliability_score: 80,
  reliability_category: "good",
  total_amount: 50000,
  total_paid: 40000,
  total_pending: 10000,
  // ... more fields
}
```

**Categories:**
- `new`: No bills yet (0%)
- `good`: 80-100% payment rate
- `average`: 50-79% payment rate
- `risky`: <50% payment rate

---

## 🐛 Troubleshooting

### Problem: "relation 'profiles' does not exist"

**Solution:** You haven't run the SQL setup script yet.
- Go to SQL Editor and run `DATABASE_SETUP.sql`

### Problem: "new row violates row-level security policy"

**Solution:** User isn't authenticated or trying to access wrong data.
- Check user is logged in: `await supabase.auth.getUser()`
- Verify userId matches data being accessed

### Problem: "duplicate key value violates unique constraint"

**Solution:** Trying to create duplicate data.
- Bill numbers must be unique
- Email addresses must be unique
- Check for existing records first

### Problem: Authentication not working

**Solution:**
1. Verify email auth is enabled in Supabase dashboard
2. Check if email confirmation is required (disable for testing)
3. Look at browser console for errors
4. Check Network tab for API call failures

### Problem: Data not appearing

**Solution:**
1. Open browser DevTools → Network tab
2. Filter for "supabase"
3. Check if API calls are succeeding (status 200)
4. Look at response data
5. Verify RLS policies are correct

---

## 📈 Performance Optimization

### Indexes Created

The setup script creates indexes on commonly queried fields:
- `clients.user_id`
- `clients.shop_name`
- `clients.phone`
- `bills.user_id`
- `bills.client_id`
- `bills.status`
- `bills.due_date`
- `payments.user_id`
- `payments.bill_id`

### Query Optimization Tips

1. **Use `select('*')` carefully:**
   - Only select fields you need
   - Example: `.select('id, name, shop_name')`

2. **Paginate large datasets:**
   ```typescript
   .range(0, 49) // First 50 records
   .range(50, 99) // Next 50 records
   ```

3. **Use `single()` for one record:**
   ```typescript
   .eq('id', clientId)
   .single() // Expects exactly one result
   ```

4. **Filter on indexed columns:**
   - Filtering by `user_id`, `status`, etc. is fast
   - Complex JSON queries may be slower

---

## 🚀 Next Steps

1. ✅ Run `DATABASE_SETUP.sql` in Supabase SQL Editor
2. ✅ Verify tables and policies created
3. ✅ Update `App.tsx` to use Supabase auth (if desired)
4. ✅ Test signup and login
5. ✅ Create test data (clients, bills)
6. ✅ Verify data appears in Supabase dashboard
7. ✅ Deploy to production!

---

## 📞 Support Resources

- **Supabase Docs:** https://supabase.com/docs
- **Your Dashboard:** https://supabase.com/dashboard/project/ozvbqitkzuzbmzuzhmzq
- **SQL Reference:** https://supabase.com/docs/guides/database/overview
- **Auth Guide:** https://supabase.com/docs/guides/auth

---

## 🎉 You're Ready!

Your VMS now has:
- ✅ Production-grade PostgreSQL database
- ✅ Secure authentication
- ✅ Row-level security
- ✅ Cloud storage
- ✅ Multi-device sync
- ✅ Automatic backups
- ✅ Scalable infrastructure

**Start building with confidence!** 🚀
