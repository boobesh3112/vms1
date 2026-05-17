# 🏗️ VMS Architecture Documentation

## System Overview

VMS is a single-page application (SPA) built with React and TypeScript, following modern frontend architecture patterns with a clean separation of concerns.

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                        User Interface                        │
│  (React Components + Tailwind CSS + shadcn/ui + Motion)     │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                    Application Layer                         │
│                                                              │
│  ┌────────────┐  ┌──────────────┐  ┌──────────────────┐   │
│  │   Pages    │  │   Contexts   │  │    Components    │   │
│  │            │  │              │  │                  │   │
│  │ - Dashboard│  │ - AuthContext│  │ - DashboardLayout│   │
│  │ - Clients  │  │              │  │ - Dialogs        │   │
│  │ - Billing  │  │              │  │ - Cards          │   │
│  │ - QR Scan  │  │              │  │ - Forms          │   │
│  │ - Settings │  │              │  │                  │   │
│  └────────────┘  └──────────────┘  └──────────────────┘   │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                    Business Logic Layer                      │
│                                                              │
│  ┌─────────────────┐  ┌──────────────────────────────┐    │
│  │  Utilities      │  │   Type Definitions           │    │
│  │                 │  │                              │    │
│  │ - Payment Score │  │ - User, Client, Bill        │    │
│  │ - QR Generator  │  │ - Payment, BillItem          │    │
│  │ - PDF Invoice   │  │ - DashboardStats             │    │
│  │ - Dashboard     │  │ - PaymentReliability         │    │
│  │   Stats         │  │                              │    │
│  └─────────────────┘  └──────────────────────────────┘    │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                    Data Access Layer                         │
│                                                              │
│  ┌──────────────────────────────────────────────────┐      │
│  │            Storage Service (storage.ts)          │      │
│  │                                                  │      │
│  │  - getCurrentUser()    - getClients()           │      │
│  │  - addUser()          - addClient()              │      │
│  │  - updateUser()       - updateClient()           │      │
│  │  - getBills()         - deleteClient()           │      │
│  │  - addBill()          - getPayments()            │      │
│  │  - updateBill()       - addPayment()             │      │
│  └──────────────────────────────────────────────────┘      │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                    Data Storage Layer                        │
│                                                              │
│  ┌──────────────────────────────────────────────────┐      │
│  │           Browser localStorage API               │      │
│  │                                                  │      │
│  │  Keys:                                           │      │
│  │  - vms_current_user                             │      │
│  │  - vms_users                                    │      │
│  │  - vms_clients                                  │      │
│  │  - vms_bills                                    │      │
│  │  - vms_payments                                 │      │
│  └──────────────────────────────────────────────────┘      │
└─────────────────────────────────────────────────────────────┘
```

## Data Flow

### Authentication Flow

```
User Action (Login/Signup)
         │
         ▼
   AuthContext
         │
         ├──> storage.getUsers() ──> localStorage
         │
         ├──> Validate credentials
         │
         └──> storage.setCurrentUser() ──> localStorage
                      │
                      ▼
                Update React State
                      │
                      ▼
              Re-render UI with user data
```

### Client Management Flow

```
User Action (Add/Edit/Delete Client)
         │
         ▼
   ClientsPage Component
         │
         ├──> storage.addClient()
         │    storage.updateClient()
         │    storage.deleteClient()
         │           │
         │           ▼
         │    localStorage write
         │
         ├──> loadClients()
         │           │
         │           ▼
         │    storage.getClients(userId)
         │           │
         │           ▼
         │    localStorage read
         │
         └──> Update local state
                   │
                   ▼
             Re-render UI
```

### Billing Flow with Payment Tracking

```
Create Bill
     │
     ▼
BillingPage
     │
     ├──> Collect bill items
     │    Calculate total
     │
     ├──> storage.addBill()
     │         │
     │         ▼
     │    localStorage
     │
     └──> Reload bills

Add Payment
     │
     ▼
BillingPage
     │
     ├──> storage.addPayment()
     │         │
     │         ▼
     │    localStorage
     │
     ├──> storage.updateBill()
     │    (update paidAmount, status)
     │         │
     │         ▼
     │    localStorage
     │
     ├──> Recalculate payment reliability
     │    for client
     │
     └──> Reload data & update UI
```

### QR Code Flow

```
Generate QR Code:
    Client Data (clientId)
         │
         ▼
    generateClientQRCode()
         │
         ├──> Create JSON payload
         │    { type: 'client', id: clientId }
         │
         ├──> QRCode.toDataURL()
         │
         └──> Return data URL
              (base64 encoded image)

Scan QR Code:
    QR Image/Camera
         │
         ▼
    BrowserMultiFormatReader
         │
         ├──> Decode QR data
         │
         ├──> parseQRCodeData()
         │
         ├──> storage.getClientById()
         │
         ├──> calculatePaymentReliability()
         │
         └──> Display client info
```

## Component Hierarchy

```
App (Root)
├── AuthProvider (Context)
│   └── AppContent
│       ├── LoginPage (unauthenticated)
│       ├── SignupPage (unauthenticated)
│       └── DashboardLayout (authenticated)
│           ├── Sidebar Navigation
│           │   ├── Menu Items
│           │   └── User Profile
│           └── Page Content
│               ├── DashboardPage
│               │   ├── Stat Cards
│               │   ├── Pie Chart (Payment Status)
│               │   ├── Bar Chart (Reliability)
│               │   └── Quick Stats
│               ├── ClientsPage
│               │   ├── Search & Filter
│               │   ├── Client Cards
│               │   ├── Add Client Dialog
│               │   ├── Edit Client Dialog
│               │   └── QR Code Dialog
│               ├── BillingPage
│               │   ├── Filter Controls
│               │   ├── Bill Cards
│               │   ├── Create Bill Dialog
│               │   └── Add Payment Dialog
│               ├── QRScannerPage
│               │   ├── Scanner Interface
│               │   │   ├── Camera View
│               │   │   └── Upload Option
│               │   └── Scanned Client Display
│               └── SettingsPage
│                   ├── Personal Info Form
│                   ├── Business Info Form
│                   └── Invoice Preview
└── Toaster (Notifications)
```

## State Management

### Global State (Context)
```typescript
AuthContext:
- user: User | null
- isLoading: boolean
- login(email, password)
- signup(userData)
- logout()
- updateProfile(updates)
```

### Local State (Component Level)
Each page manages its own state:
- Form data
- UI state (dialogs, loading)
- Filtered/sorted data
- Selected items

### Data Persistence
- All data stored in localStorage
- Automatic serialization/deserialization
- No external API calls (current version)

## Core Algorithms

### 1. Payment Reliability Score

```typescript
Score Formula:
score = (paidBills / totalBills) × 100

Categorization:
- score >= 80  → "good"    (Green)
- score >= 50  → "average" (Yellow)
- score < 50   → "risky"   (Red)

Example:
Client A: 8 paid / 10 total = 80% → "good"
Client B: 3 paid / 6 total  = 50% → "average"
Client C: 1 paid / 5 total  = 20% → "risky"
```

### 2. Bill Status Calculation

```typescript
Status Logic:
- paidAmount >= amount    → "paid"
- paidAmount > 0          → "partial"
- paidAmount === 0        → "unpaid"

Auto-update on payment:
1. Add payment record
2. Update bill.paidAmount
3. Recalculate status
4. Save to storage
```

### 3. Dashboard Statistics

```typescript
Aggregate Calculations:
- totalClients = clients.length
- totalBills = bills.length
- paidBills = bills.filter(b => b.status === 'paid').length
- totalRevenue = sum(paidBills.map(b => b.amount))
- pendingAmount = sum(unpaidBills.map(b => b.amount))

Reliability Distribution:
- goodClients = clients where score >= 80
- averageClients = clients where 50 <= score < 80
- riskyClients = clients where score < 50
```

## Security Considerations

### Current Implementation (localStorage)
⚠️ **Limitations:**
- Data stored in plaintext
- Accessible via browser DevTools
- No encryption
- No server-side validation
- Per-browser isolation only

### Recommended for Production (Supabase)
✅ **Improvements:**
- Row-level security (RLS)
- Server-side validation
- Encrypted connections (HTTPS)
- User authentication (JWT)
- Data backup and recovery

### Input Validation
- Client-side form validation
- Required field checks
- Email format validation
- Phone number formatting
- Amount validation (positive numbers)

## Performance Optimizations

### Current Optimizations
1. **React.memo** for expensive components
2. **useMemo** for filtered/sorted data
3. **Lazy loading** for charts (Recharts)
4. **AnimatePresence** for smooth transitions
5. **Debounced search** (could be added)

### Storage Performance
- localStorage reads are synchronous but fast
- Filtering done in-memory (JavaScript)
- No pagination (suitable for <1000 records)

### Future Optimizations
- Virtual scrolling for large lists
- Pagination for bills/clients
- Server-side search and filtering
- Image lazy loading
- Code splitting by route

## Testing Strategy

### Unit Tests (Recommended)
```bash
# Test utilities
- payment-score.test.ts
- qr-code.test.ts
- dashboard-stats.test.ts

# Test storage layer
- storage.test.ts
```

### Integration Tests
```bash
# Test user flows
- Authentication flow
- Client creation flow
- Bill creation and payment
- QR code generation and scanning
```

### E2E Tests (Cypress/Playwright)
```bash
# Test complete scenarios
- User signup → Add client → Create bill → Record payment
- QR code generation → Scan → View details
- Dashboard stats accuracy
```

## Error Handling

### Current Error Handling
- Try-catch blocks for QR operations
- Validation before storage operations
- User-friendly error messages (toast)
- Fallback UI for empty states

### Edge Cases Handled
- Empty client list → "No clients found"
- No bills for client → Show zero stats
- Invalid QR code → Display error message
- Camera permission denied → Offer upload option

## Accessibility (a11y)

### Current Implementation
- Semantic HTML elements
- ARIA labels on interactive elements
- Keyboard navigation support
- Focus management in dialogs
- Color contrast ratios (WCAG AA)

### Improvements Needed
- Screen reader testing
- Keyboard shortcuts
- Skip navigation links
- Form error announcements

## Browser Compatibility

### Supported Browsers
- Chrome 90+ ✅
- Firefox 88+ ✅
- Safari 14+ ✅
- Edge 90+ ✅

### Required APIs
- localStorage
- MediaDevices (camera)
- Canvas API (QR/PDF)
- ES6+ JavaScript

## Deployment Architecture

### Static Hosting (Current)
```
User Browser
     │
     ├──> CDN (Vercel/Netlify)
     │    │
     │    └──> Static Files (HTML, CSS, JS)
     │
     └──> localStorage (Client-side DB)
```

### Future (Supabase Backend)
```
User Browser
     │
     ├──> CDN (Frontend)
     │    └──> React App
     │
     └──> Supabase
          ├──> Auth Service
          ├──> PostgreSQL Database
          ├──> Edge Functions
          └──> Storage (Files)
```

## Database Schema (Future Supabase)

```sql
-- Users (extends auth.users)
profiles (
  id UUID PRIMARY KEY,
  name TEXT,
  business_name TEXT,
  phone TEXT,
  address TEXT,
  created_at TIMESTAMP
)

-- Clients
clients (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES profiles(id),
  name TEXT NOT NULL,
  phone TEXT NOT NULL,
  shop_name TEXT NOT NULL,
  address TEXT,
  email TEXT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
)

-- Bills
bills (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES profiles(id),
  client_id UUID REFERENCES clients(id),
  bill_number TEXT UNIQUE NOT NULL,
  amount NUMERIC NOT NULL,
  due_date TIMESTAMP,
  status TEXT CHECK (status IN ('paid', 'unpaid', 'partial')),
  paid_amount NUMERIC DEFAULT 0,
  items JSONB,
  notes TEXT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
)

-- Payments
payments (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES profiles(id),
  bill_id UUID REFERENCES bills(id),
  client_id UUID REFERENCES clients(id),
  amount NUMERIC NOT NULL,
  method TEXT,
  notes TEXT,
  created_at TIMESTAMP
)

-- Indexes for performance
CREATE INDEX idx_clients_user_id ON clients(user_id);
CREATE INDEX idx_bills_user_id ON bills(user_id);
CREATE INDEX idx_bills_client_id ON bills(client_id);
CREATE INDEX idx_payments_bill_id ON payments(bill_id);
```

## API Design (Future Backend)

### RESTful Endpoints
```
Auth:
POST   /auth/signup       - Create account
POST   /auth/login        - Login
POST   /auth/logout       - Logout
GET    /auth/user         - Get current user

Clients:
GET    /clients           - List clients
POST   /clients           - Create client
GET    /clients/:id       - Get client
PUT    /clients/:id       - Update client
DELETE /clients/:id       - Delete client

Bills:
GET    /bills             - List bills
POST   /bills             - Create bill
GET    /bills/:id         - Get bill
PUT    /bills/:id         - Update bill
DELETE /bills/:id         - Delete bill

Payments:
GET    /payments          - List payments
POST   /payments          - Add payment
GET    /payments/:id      - Get payment

Analytics:
GET    /analytics/dashboard    - Dashboard stats
GET    /analytics/client/:id   - Client stats
```

## Monitoring & Analytics (Future)

### Metrics to Track
- User engagement (DAU, MAU)
- Feature usage (most used pages)
- Performance (page load times)
- Error rates
- Payment completion rates
- Client reliability trends

### Tools
- Google Analytics
- Sentry (error tracking)
- Vercel Analytics
- Supabase Dashboard

---

**Architecture Version:** 1.0  
**Last Updated:** May 2026  
**Status:** Production Ready (localStorage version)
