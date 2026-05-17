# VMS (Vendor Management System) - Deployment Guide

## 🚀 Quick Start

This VMS application is built with React + Vite and uses localStorage for data persistence. It's ready to deploy on any static hosting platform.

## 📋 Prerequisites

- Node.js 18+ and pnpm installed
- A Figma Make account (current environment)
- OR Vercel/Netlify account for standalone deployment

## 🏗️ Project Structure

```
code/
├── src/
│   ├── app/
│   │   ├── components/ui/     # shadcn/ui components
│   │   └── App.tsx            # Main application
│   ├── components/            # Custom components
│   │   └── DashboardLayout.tsx
│   ├── contexts/              # React contexts
│   │   └── AuthContext.tsx
│   ├── lib/                   # Utilities and storage
│   │   ├── storage.ts         # localStorage wrapper
│   │   ├── seed-data.ts       # Demo data generator
│   │   └── utils/             # Helper functions
│   ├── pages/                 # Application pages
│   │   ├── LoginPage.tsx
│   │   ├── SignupPage.tsx
│   │   ├── DashboardPage.tsx
│   │   ├── ClientsPage.tsx
│   │   ├── BillingPage.tsx
│   │   ├── QRScannerPage.tsx
│   │   └── SettingsPage.tsx
│   ├── types/                 # TypeScript types
│   │   └── index.ts
│   └── styles/                # CSS files
├── package.json
└── vite.config.ts
```

## 🔧 Local Development

### 1. Install Dependencies

```bash
pnpm install
```

### 2. Run Development Server

The Vite dev server is already running in the Figma Make environment. Just start building!

For standalone development:

```bash
pnpm run dev
```

Open http://localhost:5173 in your browser.

## 📦 Build for Production

```bash
pnpm run build
```

This creates an optimized production build in the `dist/` directory.

## 🌐 Deployment Options

### Option 1: Vercel (Recommended)

1. **Install Vercel CLI**
   ```bash
   npm i -g vercel
   ```

2. **Deploy**
   ```bash
   vercel
   ```

3. **Follow prompts:**
   - Link to existing project or create new
   - Set build command: `pnpm run build`
   - Set output directory: `dist`

4. **Environment Variables** (if using Supabase later):
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`

### Option 2: Netlify

1. **Install Netlify CLI**
   ```bash
   npm i -g netlify-cli
   ```

2. **Build**
   ```bash
   pnpm run build
   ```

3. **Deploy**
   ```bash
   netlify deploy --prod --dir=dist
   ```

### Option 3: GitHub Pages

1. **Install gh-pages**
   ```bash
   pnpm add -D gh-pages
   ```

2. **Add to package.json scripts**:
   ```json
   {
     "scripts": {
       "predeploy": "pnpm run build",
       "deploy": "gh-pages -d dist"
     }
   }
   ```

3. **Update vite.config.ts** for GitHub Pages:
   ```ts
   export default defineConfig({
     base: '/your-repo-name/',
     // ... rest of config
   })
   ```

4. **Deploy**
   ```bash
   pnpm run deploy
   ```

## 🔐 Current Implementation Notes

### Data Storage
- **Current**: localStorage (browser-based, client-side only)
- **Limitations**: 
  - Data is per-browser, not synced across devices
  - Clearing browser data will delete all records
  - No multi-user support (data is local to each user's browser)

### Authentication
- **Current**: Simple email-based local authentication
- **No passwords are stored** (demo mode)
- Each signup creates a local user record

### Future Enhancements (Supabase Integration)

To make this production-ready with real backend:

1. **Connect Supabase** (in Figma Make settings)
2. **Create Tables**:
   ```sql
   -- Users table (extends Supabase auth.users)
   create table profiles (
     id uuid references auth.users on delete cascade,
     name text,
     business_name text,
     phone text,
     address text,
     created_at timestamp with time zone default timezone('utc'::text, now()),
     primary key (id)
   );

   -- Clients table
   create table clients (
     id uuid default uuid_generate_v4() primary key,
     user_id uuid references profiles(id) on delete cascade,
     name text not null,
     phone text not null,
     shop_name text not null,
     address text,
     email text,
     created_at timestamp with time zone default timezone('utc'::text, now()),
     updated_at timestamp with time zone default timezone('utc'::text, now())
   );

   -- Bills table
   create table bills (
     id uuid default uuid_generate_v4() primary key,
     user_id uuid references profiles(id) on delete cascade,
     client_id uuid references clients(id) on delete cascade,
     bill_number text not null,
     amount numeric not null,
     due_date timestamp with time zone,
     status text check (status in ('paid', 'unpaid', 'partial')),
     paid_amount numeric default 0,
     items jsonb,
     notes text,
     created_at timestamp with time zone default timezone('utc'::text, now()),
     updated_at timestamp with time zone default timezone('utc'::text, now())
   );

   -- Payments table
   create table payments (
     id uuid default uuid_generate_v4() primary key,
     user_id uuid references profiles(id) on delete cascade,
     bill_id uuid references bills(id) on delete cascade,
     client_id uuid references clients(id) on delete cascade,
     amount numeric not null,
     method text,
     notes text,
     created_at timestamp with time zone default timezone('utc'::text, now())
   );
   ```

3. **Enable Row Level Security (RLS)**:
   ```sql
   alter table profiles enable row level security;
   alter table clients enable row level security;
   alter table bills enable row level security;
   alter table payments enable row level security;

   -- Policies: users can only access their own data
   create policy "Users can view own profile" 
     on profiles for select using (auth.uid() = id);

   create policy "Users can view own clients" 
     on clients for select using (auth.uid() = user_id);

   -- Add similar policies for bills and payments
   ```

4. **Replace localStorage with Supabase client**:
   - Update `src/lib/storage.ts` to use Supabase queries
   - Replace `AuthContext` with Supabase Auth

## 🧪 Testing

### Demo Account
When you first sign up, the app automatically seeds demo data:
- 3 sample clients
- 5 sample bills (paid, partial, unpaid)
- Payment history
- Calculated reliability scores

### Features to Test
1. **Authentication**: Sign up → Login → Logout
2. **Client Management**: Add, edit, delete, search, filter by reliability
3. **QR Codes**: Generate QR code → Download → Scan (use phone to scan)
4. **Billing**: Create bill → Add payment → Download PDF → Print
5. **Dashboard**: View stats and charts
6. **Settings**: Update profile → Check invoice preview

## 📱 Mobile Responsiveness

The app is fully responsive and works on:
- Desktop (1920px+)
- Laptop (1280px - 1920px)
- Tablet (768px - 1280px)
- Mobile (320px - 768px)

## 🎨 Customization

### Theme Colors
Edit `src/styles/theme.css` to customize:
- Primary colors
- Typography
- Spacing
- Border radius

### Invoice Branding
Update in Settings page:
- Business name
- Logo (future enhancement)
- Contact information
- Address

## 🐛 Troubleshooting

### QR Scanner Not Working
- **Camera permissions**: Browser needs camera access
- **HTTPS required**: Camera only works on localhost or HTTPS
- **Alternative**: Use "Upload Image" option

### Data Lost After Refresh
- Check browser localStorage is enabled
- Don't use incognito/private mode
- For persistence across devices, integrate Supabase

### PDF Generation Issues
- Check browser popup blocker settings
- Try "Download" instead of "Print"

## 📞 Support

For issues or questions:
- Check browser console for errors
- Ensure all dependencies are installed
- Verify Node.js version (18+)

## 🎉 Features Implemented

✅ Client Management with CRUD operations
✅ QR Code generation and scanning
✅ Bill creation and tracking
✅ Payment recording (multiple methods)
✅ Payment reliability scoring (Good/Average/Risky)
✅ PDF invoice generation with customization
✅ Analytics dashboard with charts
✅ Responsive design with smooth animations
✅ Search and filter functionality
✅ Demo data seeding

## 🔮 Future Enhancements

- [ ] Supabase backend integration
- [ ] Real-time notifications
- [ ] WhatsApp/SMS payment reminders
- [ ] Export reports (CSV, Excel)
- [ ] Dark mode
- [ ] Multi-currency support
- [ ] Recurring bills
- [ ] Email invoice sending

---

**Built with ❤️ using React, TypeScript, Tailwind CSS, and shadcn/ui**
