# 📦 VMS - Vendor Management System

A modern, full-featured web application for suppliers and vendors to manage clients, track bills, and monitor payment reliability.

![VMS Dashboard](https://img.shields.io/badge/Status-Production%20Ready-brightgreen)
![React](https://img.shields.io/badge/React-18.3.1-blue)
![TypeScript](https://img.shields.io/badge/TypeScript-5.0-blue)
![Tailwind CSS](https://img.shields.io/badge/Tailwind-4.1-06B6D4)

## 🎯 Overview

VMS helps suppliers and vendors efficiently manage their client relationships, track pending bills, and maintain comprehensive payment histories. Built with modern technologies, it offers a clean, responsive interface with powerful features.

## ✨ Key Features

### 📊 Client Management
- Store complete client details (Name, Phone, Shop Name, Address, Email)
- Unique client ID generation
- Advanced search and filtering
- Payment reliability scoring
- Client categorization (Good/Average/Risky)

### 📱 QR Code Integration
- Generate unique QR codes for each client
- Scan QR codes via camera or uploaded image
- Instant access to client details and payment history
- Downloadable QR codes

### 💰 Billing & Payment Tracking
- Create professional itemized bills
- Track paid, unpaid, and partial payments
- Record multiple payment methods (Cash, Card, UPI, Cheque)
- Complete payment history per client
- Due date tracking

### 📈 Payment Reliability System
**Smart scoring algorithm:**
```
Score = (Paid Bills / Total Bills) × 100

Categories:
- Good: 80-100% (Green badge)
- Average: 50-79% (Yellow badge)
- Risky: <50% (Red badge)
```

Filter clients by reliability category to prioritize business relationships.

### 🧾 Professional Invoice System
- Generate beautiful PDF invoices
- Customizable with your business branding
- Download or print directly
- Includes:
  - Business information
  - Client details
  - Itemized billing
  - Payment status
  - Notes and terms

### 📊 Analytics Dashboard
- Real-time statistics
- Interactive charts (Pie charts, Bar graphs)
- Key metrics:
  - Total clients and bills
  - Revenue tracking
  - Pending amounts
  - Client reliability distribution
- Payment status visualization

### 🎨 Modern UI/UX
- Clean, professional design
- Smooth animations and transitions
- Responsive layout (desktop + mobile)
- Modal dialogs with fade effects
- Intuitive navigation
- Loading states and error handling

## 🛠️ Tech Stack

### Frontend
- **React 18.3.1** - UI library
- **TypeScript** - Type safety
- **Vite** - Build tool
- **Tailwind CSS 4.1** - Styling
- **shadcn/ui** - Component library

### Libraries
- **Motion (Framer Motion)** - Animations
- **Recharts** - Data visualization
- **QRCode** - QR generation
- **jsPDF** - PDF generation
- **@zxing/library** - QR scanning
- **date-fns** - Date formatting
- **Sonner** - Toast notifications

### Data Management
- **localStorage** - Client-side storage (current)
- **Supabase** - Backend integration (optional)

## 🚀 Getting Started

### Prerequisites
- Node.js 18+ 
- pnpm (or npm/yarn)

### Installation

```bash
# Clone the repository
git clone <your-repo-url>
cd vms

# Install dependencies
pnpm install

# Run development server
pnpm run dev

# Build for production
pnpm run build
```

### First Time Setup

1. **Sign Up**: Create an account with your business details
2. **Demo Data**: App automatically seeds sample data on first login
3. **Explore**: Check out the dashboard, clients, and billing features
4. **Customize**: Update your business info in Settings

### Demo Credentials
When you sign up, you get:
- 3 sample clients
- 5 sample bills (various statuses)
- Complete payment history
- Pre-calculated reliability scores

## 📖 User Guide

### Managing Clients

**Add Client:**
1. Navigate to Clients page
2. Click "Add Client"
3. Fill in client details
4. Save

**Generate QR Code:**
1. Click QR icon on client card
2. Download the QR code image
3. Share with client or print

**View Reliability:**
- Each client card shows reliability score
- Filter clients by category
- View detailed payment history

### Creating Bills

**New Bill:**
1. Go to Billing page
2. Click "Create Bill"
3. Select client
4. Add bill items (description, quantity, price)
5. Set due date and notes
6. Create bill

**Record Payment:**
1. Find the bill
2. Click "Add Payment"
3. Enter amount and payment method
4. Add notes if needed
5. Submit

**Generate Invoice:**
- Click Download icon → Saves PDF
- Click Print icon → Opens print dialog

### QR Scanner

**Scan Options:**
1. **Use Camera**: Real-time scanning
2. **Upload Image**: Select QR code image

**After Scanning:**
- View complete client profile
- See payment reliability
- Check recent bills
- Review payment history

### Settings

Update your business information:
- Business name
- Contact details
- Address
- Email

All invoices use this information automatically.

## 📁 Project Structure

```
src/
├── app/
│   ├── components/
│   │   └── ui/              # shadcn/ui components
│   └── App.tsx              # Main app component
├── components/
│   └── DashboardLayout.tsx  # Layout wrapper
├── contexts/
│   └── AuthContext.tsx      # Authentication state
├── lib/
│   ├── storage.ts           # localStorage wrapper
│   ├── seed-data.ts         # Demo data
│   └── utils/
│       ├── payment-score.ts # Reliability calculation
│       ├── qr-code.ts       # QR generation/parsing
│       ├── pdf-invoice.ts   # Invoice generation
│       └── dashboard-stats.ts # Statistics
├── pages/
│   ├── LoginPage.tsx
│   ├── SignupPage.tsx
│   ├── DashboardPage.tsx
│   ├── ClientsPage.tsx
│   ├── BillingPage.tsx
│   ├── QRScannerPage.tsx
│   └── SettingsPage.tsx
├── types/
│   └── index.ts             # TypeScript definitions
└── styles/
    └── theme.css            # Tailwind theme
```

## 🎨 Customization

### Colors
Edit `src/styles/theme.css`:

```css
@theme {
  --color-primary: #2563eb;
  --color-secondary: #7c3aed;
  /* ... more colors */
}
```

### Invoice Template
Customize in `src/lib/utils/pdf-invoice.ts`:
- Header colors
- Font sizes
- Layout spacing
- Logo placement (future)

## 🔐 Security Notes

### Current Implementation
- Client-side authentication (demo)
- localStorage data storage
- No sensitive data encryption
- Per-browser data isolation

### For Production
⚠️ **Important**: This is a demo/prototype. For production use:

1. **Integrate Supabase** for:
   - Real authentication
   - Server-side data storage
   - Row-level security
   - Data encryption

2. **Enable HTTPS**:
   - Required for QR camera access
   - Secure data transmission

3. **Add validation**:
   - Input sanitization
   - SQL injection prevention
   - XSS protection

4. **Implement backups**:
   - Regular database backups
   - Data export functionality

## 📊 Payment Reliability Algorithm

```typescript
function calculateReliability(userId: string, clientId: string) {
  const bills = getBillsByClient(userId, clientId);
  
  const totalBills = bills.length;
  const paidBills = bills.filter(b => b.status === 'paid').length;
  
  const score = totalBills > 0 
    ? Math.round((paidBills / totalBills) * 100) 
    : 0;
  
  const category = score >= 80 ? 'good' 
    : score >= 50 ? 'average' 
    : 'risky';
  
  return { score, category, totalBills, paidBills };
}
```

## 🚀 Deployment

See [DEPLOYMENT.md](./DEPLOYMENT.md) for detailed deployment instructions for:
- Vercel
- Netlify
- GitHub Pages
- Supabase integration

## 🐛 Known Limitations

### Current Version (localStorage)
- ❌ No multi-device sync
- ❌ Data lost on browser cache clear
- ❌ No real-time collaboration
- ❌ Limited to ~5-10MB storage

### Solutions
✅ Integrate Supabase for:
- ✅ Cloud database
- ✅ Multi-device access
- ✅ Data persistence
- ✅ Scalability

## 🔮 Roadmap

### Phase 1 (Current) ✅
- [x] Client management
- [x] QR code system
- [x] Billing and payments
- [x] PDF invoices
- [x] Analytics dashboard
- [x] Responsive design

### Phase 2 (Planned)
- [ ] Supabase integration
- [ ] Real-time notifications
- [ ] Payment reminders (WhatsApp/SMS)
- [ ] Email invoices
- [ ] Dark mode
- [ ] Export reports (CSV/Excel)

### Phase 3 (Future)
- [ ] Multi-currency support
- [ ] Recurring bills
- [ ] Client portal
- [ ] Mobile app (React Native)
- [ ] Inventory management
- [ ] Advanced analytics

## 🤝 Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create feature branch
3. Commit changes
4. Push to branch
5. Open pull request

## 📄 License

MIT License - feel free to use for personal or commercial projects.

## 👨‍💻 Author

Built with ❤️ using modern web technologies.

## 🙏 Acknowledgments

- **shadcn/ui** - Beautiful component library
- **Tailwind CSS** - Utility-first CSS framework
- **Recharts** - Composable charting library
- **Motion** - Production-ready animations

## 📞 Support

### Issues
- Check browser console for errors
- Ensure camera permissions for QR scanner
- Clear cache if data seems corrupted

### Feature Requests
Open an issue with:
- Feature description
- Use case
- Expected behavior

---

**Made for suppliers, vendors, and small businesses worldwide 🌍**

**Star ⭐ this repo if you find it useful!**
