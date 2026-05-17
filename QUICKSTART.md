# ⚡ VMS Quick Start Guide

Get up and running with VMS in 2 minutes!

## 🎬 Getting Started

### 1️⃣ First Launch

The application is already running in your Figma Make environment! Just start using it.

**For standalone development:**
```bash
pnpm install
pnpm run dev
```

### 2️⃣ Create Your Account

1. Click **"Sign up"**
2. Fill in your details:
   - Your Name: `John Doe`
   - Business Name: `ABC Suppliers`
   - Email: `your@email.com`
   - Phone: `+91 98765 43210`
   - Address: `Your business address`
   - Password: `yourpassword`
3. Click **"Create Account"**

🎉 **You're in!** Demo data is automatically loaded.

### 3️⃣ Explore the Dashboard

You'll see:
- 📊 **Stats Cards**: Clients, Bills, Revenue, Pending
- 📈 **Charts**: Payment status, Client reliability
- ⚡ **Quick Actions**: Navigate to different sections

---

## 🎯 Common Tasks

### Add a New Client

```
1. Go to "Clients" page
2. Click "+ Add Client"
3. Fill in details:
   - Name: "Customer Name"
   - Shop: "Shop Name"
   - Phone: "+91 XXXXX XXXXX"
   - Address: "Full address"
4. Click "Add Client"
```

### Create a Bill

```
1. Go to "Billing" page
2. Click "+ Create Bill"
3. Select client from dropdown
4. Add bill items:
   - Description: "Product name"
   - Quantity: 10
   - Price: 1000
5. Set due date
6. Click "Create Bill"
```

### Record a Payment

```
1. Find the bill in "Billing" page
2. Click "Add Payment"
3. Enter amount: 10000
4. Select payment method: UPI/Cash/Card
5. Add notes (optional)
6. Click "Add Payment"

✅ Bill status automatically updates!
```

### Generate QR Code

```
1. Go to "Clients" page
2. Click QR icon on any client card
3. QR code appears
4. Click "Download QR Code"
5. Share with client or print!
```

### Scan QR Code

```
1. Go to "QR Scanner" page
2. Option A: Click "Use Camera"
   - Grant camera permission
   - Point at QR code
3. Option B: Click "Upload Image"
   - Select QR image from device
4. View client details!
```

### Download Invoice

```
1. Go to "Billing" page
2. Find the bill
3. Click download icon (⬇️)
4. PDF automatically saves!
```

---

## 🔍 Quick Features Reference

| I want to... | Go to... | Action |
|--------------|----------|--------|
| See overview | Dashboard | View stats and charts |
| Add client | Clients | "+ Add Client" |
| Edit client | Clients | Click "Edit" icon |
| Generate QR | Clients | Click "QR" icon |
| Filter clients | Clients | Use reliability filter |
| Create bill | Billing | "+ Create Bill" |
| Add payment | Billing | "Add Payment" button |
| Download PDF | Billing | Download icon |
| Print invoice | Billing | Printer icon |
| Scan QR code | QR Scanner | Use camera or upload |
| Update profile | Settings | Edit and save |

---

## 🎨 Understanding the UI

### Color Codes

**Client Reliability:**
- 🟢 **Green (80-100%)**: Good - Reliable payer
- 🟡 **Yellow (50-79%)**: Average - Occasional delays
- 🔴 **Red (<50%)**: Risky - Payment issues

**Bill Status:**
- 🟢 **Paid**: Fully paid
- 🟡 **Partial**: Partially paid
- 🔴 **Unpaid**: No payment yet

### Navigation

**Desktop:**
- Fixed sidebar on left
- All menu items visible
- User profile at top

**Mobile:**
- Hamburger menu (☰) at top
- Tap to open sidebar
- Swipe or tap outside to close

---

## 💡 Pro Tips

### 1. Search Clients Fast
Type in the search box:
- Client name
- Shop name
- Phone number

### 2. Filter by Reliability
Use the dropdown to see only:
- Good clients (trusted)
- Average clients (monitor)
- Risky clients (follow up!)

### 3. Organize Bills
Filter bills by status:
- All Bills
- Paid (completed)
- Partial (in progress)
- Unpaid (need attention)

### 4. Professional Invoices
Your business info from Settings appears on all PDFs:
- Update Settings → Better looking invoices!

### 5. QR Code Workflow
1. Generate QR for new clients
2. Print and give to client
3. Next visit: Scan QR instantly!
4. No typing needed 🎉

---

## 🚨 Troubleshooting

### Camera Not Working?
1. Check browser permissions
2. Must use HTTPS (or localhost)
3. Try "Upload Image" instead

### Data Disappeared?
- Check you're logged in as same user
- Don't use incognito/private mode
- Don't clear browser data

### PDF Not Downloading?
1. Check popup blocker
2. Try "Print" instead
3. Update browser

### Can't Find a Client?
- Check search spelling
- Clear search and try filter
- Client might be deleted

---

## 📱 Mobile Usage

### Best Practices:
- ✅ Portrait mode for forms
- ✅ Landscape for dashboard charts
- ✅ Use camera for QR scanning
- ✅ Swipe gestures for navigation

### Touch Targets:
All buttons are thumb-friendly sized!

---

## 🎓 Learning Path

### Day 1: Basics
1. ✅ Sign up and explore
2. ✅ Add 2-3 test clients
3. ✅ Create a test bill
4. ✅ Record a payment
5. ✅ Download an invoice

### Day 2: Advanced
1. ✅ Generate QR codes
2. ✅ Practice scanning
3. ✅ Use search and filters
4. ✅ Check reliability scores
5. ✅ Customize settings

### Day 3: Master
1. ✅ Real client data
2. ✅ Daily workflow
3. ✅ Regular invoicing
4. ✅ Payment tracking
5. ✅ Analytics review

---

## ⌨️ Keyboard Shortcuts (Coming Soon)

Future enhancement:
- `Ctrl/Cmd + N` - New client
- `Ctrl/Cmd + B` - New bill
- `Ctrl/Cmd + S` - Save
- `/` - Focus search

---

## 🔗 Quick Links

- 📖 [Full Documentation](./README.md)
- 🏗️ [Architecture Guide](./ARCHITECTURE.md)
- 🚀 [Deployment Guide](./DEPLOYMENT.md)
- 📋 [Project Summary](./PROJECT_SUMMARY.md)

---

## ❓ FAQ

**Q: Is my data safe?**  
A: Currently stored in browser localStorage. For production, integrate Supabase for cloud storage.

**Q: Can I use offline?**  
A: Yes! All features work offline (current version).

**Q: Can multiple users access same data?**  
A: Not currently. Each user has separate data. Use Supabase for shared access.

**Q: How many clients can I add?**  
A: Hundreds! localStorage can handle it. For thousands, use Supabase.

**Q: Can I export data?**  
A: PDF export available. CSV/Excel coming in future updates.

**Q: Is it mobile-friendly?**  
A: 100% responsive! Works great on all devices.

---

## 🎉 You're Ready!

Start managing your clients and bills like a pro!

**Need Help?**
- Check README.md for detailed guides
- Review examples in demo data
- Experiment - it's safe to test!

---

**Happy Vendor Management! 📦✨**
