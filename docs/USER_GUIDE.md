# 📖 SeYaha — User Guide | دليل المستخدم

> **SeYaha** is a multi-role tourism platform for Egypt.
> This guide covers every role in the app — Traveller, Company Manager, Tour Guide, and Administrator.

---

## 📑 Table of Contents

1. [Getting Started](#-getting-started)
2. [Traveller Guide](#-traveller-guide)
3. [Company Manager Guide](#-company-manager-guide)
4. [Tour Guide Guide](#️-tour-guide-guide)
5. [Administrator Guide](#️-administrator-guide)
6. [Common Features](#-common-features)
7. [Troubleshooting](#-troubleshooting)

---

## 🚀 Getting Started

### Creating an Account

1. Open the app — you will land on the **Splash / Onboarding screen**.
2. Tap **Get Started** to view the onboarding carousel (new users only).
3. On the **Register** screen, fill in:
   - Full name
   - Email address
   - Password (min. 8 characters)
   - **Role** — choose one:
     - `Traveller` — browse and book services
     - `Manager` — manage a tourism company
     - `Tour Guide` — receive and manage tour assignments
4. Tap **Create Account**.  
   > Company registrations go through an additional step — see [Company Registration](#company-registration).

### Signing In

1. Tap **Sign In** on the welcome screen.
2. Enter your email and password.
3. Tap **Login**.

> **Too many attempts?** After 5 failed login attempts in 15 minutes the button is temporarily locked. Wait for the countdown to finish, then try again.

### Browse Without an Account

Tap **Continue as Guest** on the welcome screen to explore services and destinations without creating an account. Bookings, chat, and profile features require a registered account.

---

## 🌍 Traveller Guide

The traveller role is the default role for new users who want to discover and book Egyptian tourism experiences.

### Home Screen

| Section | What you see |
|---------|-------------|
| **Weather banner** | Current conditions for featured destinations (powered by Open-Meteo) |
| **Trending Now** | Top-rated services — tap any card to view details |
| **Categories** | Quick-filter chips: Hotels · Tours · Cars · Real Estate |
| **Articles** | Travel tips and news published by the admin team |

### Exploring Services

1. Tap **Explore** in the bottom navigation bar.
2. Use the **Search bar** to find services by name or keyword.
3. Use **filter chips** (Hotels / Tours / Cars / Real Estate) to narrow results.
4. Tap a service card to open the **Service Details** screen.

On the Service Details screen you can:
- View photos, description, price, and location
- See the service on an **interactive map** (OpenStreetMap)
- Read and leave **reviews & ratings**
- Tap the heart icon to **save as a favourite**
- Tap **Book Now** to start the booking flow

### Booking a Service

```
Service Details → Book Now
       ↓
Select Start Date & End Date
       ↓
Add optional Notes (special requests)
       ↓
Confirm Booking
       ↓
Status: PENDING  →  CONFIRMED  →  COMPLETED
```

Track all your bookings in **My Bookings** (Profile → My Bookings). You can cancel a pending booking at any time.

### AI Travel Assistant

1. Tap the **AI** tab or the sparkle icon on the home screen.
2. Type your travel question or request, e.g.:
   - *"Plan a 4-day itinerary in Luxor"*
   - *"Best time to visit Aswan?"*
   - *"Budget-friendly activities in Cairo"*
3. The **Google Gemini** assistant replies with tailored recommendations.

### Chat

1. Tap **Messages** in the navigation bar.
2. Open an existing conversation or start a new one by selecting a company or guide.
3. Messages are delivered in real time over WebSocket — you'll see a notification badge when new messages arrive.

---

## 🏢 Company Manager Guide

Company managers control service listings, bookings, and guide assignments for their tourism company.

### Company Registration

When you register with the **Manager** role, you are prompted to fill in your company profile immediately after account creation:

| Field | Notes |
|-------|-------|
| Company Name | Shown to travellers on service cards |
| Category | Hotel · Tours · Cars · Real Estate |
| Description | Appears on the company profile page |
| Address | Optional |
| Phone | Optional |

Your company starts with status **Pending** until an Administrator approves it. You will be notified in-app when approved.

### Company Dashboard

The dashboard loads automatically when you log in. It shows:
- Total bookings count
- Active services count
- Recent booking activity

### Managing Services

Navigate to **Services** from the bottom navigation bar.

**To create a service:**
1. Tap the **+** button.
2. Fill in: Title, Description, Price, Location, Category.
3. Upload at least one photo.
4. Tap **Publish**.

**To edit a service:**
1. Find the service in your list.
2. Tap the **edit** (pencil) icon.
3. Update fields and tap **Save**.

**To delete a service:**  
Tap the **delete** (trash) icon on the service card and confirm. This also cancels any pending bookings for that service.

### Managing Bookings

Navigate to **Bookings** from the bottom navigation bar. Each booking shows:
- Traveller name and contact
- Service name and dates
- Current status (`pending` / `confirmed` / `rejected` / `completed`)

**Actions you can take:**

| Status | Available actions |
|--------|------------------|
| `pending` | **Confirm** or **Reject** |
| `confirmed` | **Assign Guide**, mark as **Completed** |
| `completed` | View only |

### Assigning a Tour Guide

1. Open a **confirmed** booking.
2. Tap **Assign Guide**.
3. Select a guide from your registered team.
4. Tap **Save** — the guide is notified automatically.

---

## 🗺️ Tour Guide Guide

Tour guides see their assigned tours and communicate with travellers in real time.

### Guide Dashboard

Shows:
- Upcoming assigned bookings (date, service name, traveller)
- Completed tour count

### My Assignments

Navigate to **Assignments** to see the full list of bookings assigned to you, sorted by date. Tap a booking to view traveller details and contact information.

### Chat

Use the **Messages** tab to communicate with travellers and the company managers who assigned you.

### Profile

Keep your profile updated with your specialties and bio — company managers use this information when deciding which guide to assign to a booking.

---

## 🛡️ Administrator Guide

Administrators have full oversight of the entire SeYaha platform.

### Admin Dashboard

The admin dashboard is shown automatically on login and includes:
- Total users, companies, services, and bookings (summary cards)
- Analytics charts (registration trends, booking volume) powered by `fl_chart`

### User Management

Navigate to **Users**:
- View all registered travellers, guides, and managers
- Search by name or email
- **Deactivate** an account to block access without deleting data

### Company Management

Navigate to **Companies**:

| Status | What it means | Admin action |
|--------|--------------|-------------|
| `pending` | Just registered, not visible to travellers | **Approve** or **Reject** |
| `active` | Visible and operational | **Deactivate** if needed |
| `rejected` | Registration declined | No further action |

Approving a company makes its services appear in the Explore screen.

### Content Management (Articles)

Navigate to **Articles**:
1. Tap **New Article** to open the editor.
2. Enter Title, Body, and an optional cover image.
3. Tap **Publish** — the article appears immediately on travellers' home screens.

To edit or delete an existing article, tap it in the article list and use the action buttons.

---

## ✨ Common Features

### 🌗 Dark Mode

Toggle dark/light mode from **Profile → Appearance**. The app uses an "Aurora / Indigo Dusk" palette in both modes.

### 🌐 Language (EN / AR)

Switch between English and Arabic from **Profile → Language**. The interface switches fully, including right-to-left layout for Arabic.

### 🔔 Notifications

The notification bell in the top bar shows:
- Booking status changes (confirmed, rejected, completed)
- New chat messages
- Admin announcements

Tap a notification to navigate directly to the relevant screen.

### 👤 Profile & Avatar

1. Go to **Profile** tab.
2. Tap your avatar to upload a new photo (from gallery or camera).
3. Tap **Edit Profile** to update your name.
4. Tap **Change Password** to update your credentials.

---

## 💡 Pro Tips

| Tip | Detail |
|-----|--------|
| **Offline browsing** | Previously loaded service cards and articles are cached — you can browse them without internet |
| **Map pin search** | On the Explore map, tap any pin to jump straight to that service's detail page |
| **Weather planning** | The home screen weather banner updates every time you open the app — use it to pick the best travel day |
| **AI itineraries** | Ask the Gemini assistant for a full multi-day itinerary and then copy it to your notes app |
| **Guest → Account** | If you started as a guest and want to book, tap the profile icon — you'll be prompted to register without losing your browsing history |

---

## 🛠️ Troubleshooting

| Problem | Solution |
|---------|----------|
| **"Too many attempts" lockout** | Wait 15 minutes, then try again. If you forgot your password, use the reset option. |
| **Map not loading** | Check your internet connection. The map requires network access to download tiles. |
| **Chat messages not sending** | A lost WebSocket connection can cause this. Pull-to-refresh on the chat screen to reconnect. |
| **Service images not loading** | May be a slow connection. The app caches images after the first load — they appear instantly on revisit. |
| **Company status stuck on "pending"** | Contact an Administrator. Company approvals are manual and may take up to 24 hours. |
| **App stuck on splash screen** | Force-close and reopen the app. If the issue persists, clear the app cache in device settings. |

---

## 🇸🇦 النسخة العربية

<div dir="rtl">

### البدء

**إنشاء حساب جديد:**
1. افتح التطبيق وستصل إلى **شاشة البداية / الإعداد الأولي**.
2. اضغط على **ابدأ الآن** لمشاهدة شاشات الترحيب (للمستخدمين الجدد فقط).
3. في شاشة **التسجيل**، أدخل الاسم والبريد الإلكتروني وكلمة المرور، ثم اختر دورك:
   - **مسافر** — تصفح وحجز الخدمات
   - **مدير** — إدارة شركة سياحية
   - **مرشد سياحي** — استقبال مهام الجولات

**تسجيل الدخول:**  
أدخل بريدك الإلكتروني وكلمة المرور ثم اضغط **دخول**.

> بعد 5 محاولات فاشلة خلال 15 دقيقة، سيُقفَل الزر مؤقتاً. انتظر انتهاء العد التنازلي ثم حاول مجدداً.

---

### 🌍 دليل المسافر

**الشاشة الرئيسية** تعرض: حالة الطقس، الخدمات الرائجة، فلاتر الفئات، والمقالات السياحية.

**استكشاف الخدمات:**
1. اضغط على **استكشاف** في شريط التنقل السفلي.
2. استخدم شريط البحث أو فلاتر الفئات للتصفية.
3. اضغط على أي بطاقة خدمة لعرض التفاصيل والخريطة التفاعلية.

**حجز خدمة:**
- من صفحة تفاصيل الخدمة اضغط **احجز الآن**.
- اختر تاريخ البداية والنهاية.
- أضف ملاحظات اختيارية ثم أكد الحجز.
- تابع حالة حجزك في **ملفي ← حجوزاتي**.

**مساعد الذكاء الاصطناعي:**  
اضغط على تبويب الذكاء الاصطناعي واكتب سؤالك مثل: *"خطط رحلة 3 أيام في الأقصر"*.

---

### 🏢 دليل مدير الشركة

**تسجيل الشركة:** عند التسجيل بدور مدير، تُعبئ بيانات الشركة مباشرةً. تبقى الشركة في وضع **انتظار** حتى يوافق عليها المسؤول.

**إدارة الخدمات:** اضغط **+** لإنشاء خدمة جديدة (عنوان، وصف، سعر، موقع، صور). اضغط أيقونة القلم لتعديل خدمة موجودة.

**إدارة الحجوزات:**
- **انتظار** → اضغط **قبول** أو **رفض**
- **مؤكد** → اضغط **تعيين مرشد** ثم اختر المرشد المناسب

---

### 🗺️ دليل المرشد السياحي

تعرض لوحة التحكم الخاصة بك المهام القادمة المُعيَّنة إليك. استخدم تبويب **الرسائل** للتواصل مع المسافرين وإدارة الشركة. حافظ على تحديث ملفك الشخصي لزيادة فرص تعيينك.

---

### 🛡️ دليل المسؤول

**لوحة التحليلات:** تعرض إجمالي المستخدمين والشركات والخدمات والحجوزات مع رسوم بيانية تفاعلية.

**إدارة الشركات:** راجع الشركات في وضع **انتظار** وافقق عليها أو ارفضها.

**مركز المقالات:** اضغط **مقالة جديدة** لإنشاء محتوى يظهر فوراً على الشاشة الرئيسية للمسافرين.

---

### 🛠️ حل المشكلات الشائعة

| المشكلة | الحل |
|---------|------|
| **قفل "محاولات كثيرة"** | انتظر 15 دقيقة ثم حاول مجدداً |
| **الخريطة لا تحمّل** | تحقق من اتصال الإنترنت |
| **رسائل الدردشة لا تُرسَل** | اسحب للأسفل لإعادة الاتصال |
| **حالة الشركة عالقة على "انتظار"** | تواصل مع مسؤول — المراجعة يدوية وقد تستغرق 24 ساعة |

</div>

---

*Last updated: May 2026 · SeYaha Team*
