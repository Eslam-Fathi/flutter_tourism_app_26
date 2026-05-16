<div align="center">

# 🌍 SeYaha — Tourism Platform

**A full-stack, multi-role tourism management ecosystem built with Flutter**

[![Flutter](https://img.shields.io/badge/Flutter-3.10%2B-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.10%2B-0175C2?logo=dart)](https://dart.dev)
[![Riverpod](https://img.shields.io/badge/State-Riverpod-00B4D8)](https://riverpod.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Deployed on Vercel](https://img.shields.io/badge/Web-Vercel-black?logo=vercel)](https://se-yaha.vercel.app)

[🇺🇸 English](#-english) · [🇸🇦 العربية](#-العربية) · [📖 User Guide](./docs/USER_GUIDE.md) · [🏗️ Architecture & Concepts](./docs/ARCHITECTURE.md)

</div>

---

## 🇺🇸 English

### 🚀 Overview

**SeYaha** is a production-ready, cross-platform tourism management application for **Egypt's travel market**. It connects four distinct user roles — Travellers, Tourism Companies, Tour Guides, and Administrators — through a single, unified Flutter codebase that runs on **Android, iOS, and Web**.

The app is backed by a **Node.js REST API** (hosted on Vercel) for primary data and **Supabase** for real-time avatar storage. Real-time chat is powered by **Socket.IO**. AI-assisted travel advice is provided by **Google Gemini**.

---

### 📸 Screenshots

> _Screenshots and demo video coming soon._

---

### 👥 Multi-Role Architecture

Each role has a completely tailored navigation shell and feature set:

| Role | Home Shell | Key Capabilities |
|------|-----------|-----------------|
| **Traveller** | `MainWrapper` | Browse & book services, chat, AI travel tips, weather |
| **Tour Guide** | `MainWrapper` (guide tabs) | View assigned tours, manage schedule, chat |
| **Company Manager** | `CompanyMainWrapper` | Manage services, approve bookings, assign guides |
| **Administrator** | `AdminMainWrapper` | Full platform oversight, analytics, content management |
| **Guest** | `MainWrapper` (read-only) | Browse services without an account |

---

### ✨ Feature Highlights

#### 🗺️ Exploration & Discovery
- Interactive map via `flutter_map` with 50+ Egyptian city pin-points
- Service filtering by category (Hotels, Tours, Cars, Real Estate), price, and search
- Destination weather widget using the **Open-Meteo API** (no key required)
- Trending services and curated article feed on the home screen

#### 📅 Booking Lifecycle
- Full booking flow: browse → select dates → confirm → track
- Real-time status updates: `pending → confirmed → completed`
- Guide assignment by company managers
- Booking cancellation with instant UI feedback

#### 💬 Real-Time Chat
- Persistent WebSocket connection via `socket_io_client`
- Conversation list with unread badge counters
- In-app push notifications for messages and booking updates

#### 🤖 AI Travel Assistant
- Powered by **Google Gemini** (`google_generative_ai`)
- Contextual travel recommendations, itinerary tips, destination summaries

#### 🏛️ Admin Dashboard
- User & company management (activate, ban, verify)
- Company approval workflow (new companies are `pending` until admin-approved)
- Article / news CMS
- Analytics charts via `fl_chart` (bookings, users, revenue trends)

#### 🎨 Design System
- **Material 3** with a custom "Aurora / Indigo Dusk" colour palette
- **DM Sans** typography (via `google_fonts`) for a premium editorial feel
- **Glassmorphism** cards with `BackdropFilter` blur
- **Aurora animated background** with counter-oscillating glow clouds
- **Shimmer skeleton** loading states for every screen
- Full **Dark Mode** support with a deep-indigo night-sky palette
- Bilingual UI: **English** + **Arabic** (RTL) via Flutter's `Localizations`

---

### 🏗️ Architecture

> **Read the full [Architecture & Concepts Guide](./docs/ARCHITECTURE.md) for a deep dive into the tech stack, core concepts, and data flow.**

The project follows **Clean Architecture** with three main layers:

```
lib/
├── core/                        # Infrastructure (no business logic)
│   ├── extensions/              # BuildContext.l10n shorthand
│   ├── network/
│   │   ├── interceptors/        # SanitizationInterceptor, RateLimitInterceptor
│   │   ├── dio_client.dart      # Configured Dio instance with interceptor pipeline
│   │   ├── socket_service.dart  # Riverpod-managed WebSocket (keepAlive)
│   │   └── supabase_config.dart # Supabase singleton init
│   ├── storage/
│   │   └── token_storage.dart   # JWT in FlutterSecureStorage (Keystore/Keychain)
│   ├── theme/
│   │   ├── app_colors.dart      # Complete colour palette + gradients
│   │   └── app_theme.dart       # Material 3 light/dark ThemeData
│   ├── utils/
│   │   ├── app_enums.dart       # Enums mirroring backend Mongoose schemas
│   │   ├── location_mapper.dart # City name → GPS coordinates (50+ cities)
│   │   ├── responsive.dart      # Breakpoint helpers (mobile/tablet/desktop)
│   │   └── weather_utils.dart   # WMO code → icon + label
│   └── widgets/                 # Reusable design-system widgets
│       ├── aurora_background.dart
│       ├── glass_card.dart
│       ├── section_header.dart
│       ├── shimmer_loader.dart
│       └── skeleton_shimmer.dart
│
├── data/                        # Data layer (models + repositories)
│   ├── models/                  # Freezed + json_serializable DTOs
│   │   ├── auth_models.dart
│   │   ├── booking_model.dart   # Polymorphic service/user fields
│   │   ├── service_model.dart
│   │   ├── company_model.dart
│   │   ├── user_model.dart
│   │   ├── chat_model.dart
│   │   ├── article_model.dart
│   │   ├── interaction_model.dart
│   │   ├── notification_model.dart
│   │   └── weather_model.dart
│   └── repositories/            # One repository per domain entity
│       ├── auth_repository.dart
│       ├── booking_repository.dart
│       ├── service_repository.dart
│       ├── company_repository.dart
│       ├── user_repository.dart
│       ├── profile_repository.dart  # Supabase avatar ops
│       ├── chat_repository.dart
│       ├── article_repository.dart
│       ├── interaction_repository.dart
│       ├── notification_repository.dart
│       └── weather_repository.dart  # Open-Meteo API
│
└── presentation/                # UI layer
    ├── providers/               # Riverpod Notifiers (business logic)
    │   ├── auth/                # AuthNotifier + AuthState + AuthStatus
    │   ├── base/                # Shared provider instances (DioClient, repos)
    │   ├── booking/
    │   ├── chat/
    │   ├── company/
    │   ├── interaction/
    │   ├── profile/
    │   ├── service/
    │   ├── theme/               # ThemeNotifier + LocaleNotifier
    │   ├── user/
    │   └── admin/
    ├── screens/                 # Role-specific UI screens
    │   ├── auth/                # Splash, Onboarding, Login, Register
    │   ├── home/
    │   ├── explore/
    │   ├── bookings/
    │   ├── chat/
    │   ├── profile/
    │   ├── service/
    │   ├── tour_guide/
    │   ├── company/
    │   ├── admin/
    │   └── main_wrapper.dart    # Adaptive nav shell (BottomNav / Rail)
    └── widgets/                 # Screen-specific composite widgets
        ├── article_card.dart
        ├── service_card.dart
        ├── service_location_map.dart
        ├── trending_card.dart
        └── weather_forecast_widget.dart
```

---

### 🛠️ Tech Stack

| Category | Package | Version | Purpose |
|----------|---------|---------|---------|
| **Framework** | Flutter | ≥ 3.10 | Cross-platform UI |
| **State Management** | flutter_riverpod | ^2.6.1 | Reactive state |
| **Code Generation** | riverpod_generator | ^2.6.1 | Provider boilerplate |
| **HTTP Client** | dio | ^5.7.0 | REST API calls |
| **HTTP Logging** | pretty_dio_logger | ^1.4.0 | Debug request logging |
| **Real-time** | socket_io_client | ^3.1.4 | WebSocket / chat |
| **Backend (shadow)** | supabase_flutter | ^2.12.4 | Avatar storage |
| **AI** | google_generative_ai | ^0.4.7 | Gemini travel assistant |
| **Immutable Models** | freezed | ^2.5.7 | Value equality, copyWith |
| **JSON** | json_serializable | ^6.9.3 | fromJson / toJson |
| **Secure Storage** | flutter_secure_storage | ^9.2.2 | JWT (Keystore/Keychain) |
| **Env Variables** | flutter_dotenv | ^6.0.1 | `.env` file loading |
| **Fonts** | google_fonts | ^6.2.1 | DM Sans |
| **Maps** | flutter_map | ^7.0.2 | Interactive OpenStreetMap |
| **Charts** | fl_chart | ^0.68.0 | Admin analytics |
| **Shimmer** | shimmer | ^3.0.0 | Loading skeletons |
| **Icons** | lucide_icons_flutter | ^3.1.13 | Consistent icon set |
| **Images** | cached_network_image | ^3.4.1 | Network image caching |
| **i18n** | flutter_localizations (SDK) | — | EN + AR localisation |

---

### 🔐 Security Model

```
Client ──► SanitizationInterceptor  (XSS escape, 1 MB payload limit)
       ──► RateLimitInterceptor     (5 auth attempts / 15 min, 200 ms throttle)
       ──► Auth Interceptor         (Bearer JWT from FlutterSecureStorage)
       ──► TLS                      (enforced by Vercel + Supabase)
       ──► Node.js REST API         (server-side validation + Mongoose)
```

- **JWT** is stored in the OS keychain/Keystore (not SharedPreferences)
- **Client-side rate limiting** mirrors the server-side brute-force policy
- **Input sanitization** runs on every request before it leaves the device

---

### ⚙️ Getting Started

#### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) **≥ 3.10.3**
- Dart **≥ 3.0**
- A running instance of the [SeYaha Node.js API](https://github.com/3bdulrahman-M3/SeYaha) **or** use the production URL
- A [Supabase](https://supabase.com) project (for avatar storage — optional)
- A [Google Gemini API key](https://ai.google.dev) (for AI assistant — optional)

#### Installation

**1. Clone the repository**
```bash
git clone https://github.com/your-org/flutter_tourism_app_26.git
cd flutter_tourism_app_26
```

**2. Install dependencies**
```bash
flutter pub get
```

**3. Generate code** (Freezed models + Riverpod providers)
```bash
dart run build_runner build --delete-conflicting-outputs
```

**4. Create your `.env` file**
```env
# Required — REST API base URL (defaults to production if omitted)
API_BASE_URL=https://se-yaha.vercel.app

# Optional — Supabase (for avatar uploads)
SUPABASE_URL=https://<project-id>.supabase.co
SUPABASE_ANON_KEY=eyJ...

# Optional — Gemini AI assistant
GEMINI_API_KEY=AIza...
```

> **Note:** The app runs without Supabase and Gemini keys; those features
> will be silently disabled.

**5. Run**
```bash
# Mobile
flutter run

# Web (with hot-reload)
flutter run -d chrome

# Specific device
flutter run -d <device-id>
```

#### Web Deployment (Vercel)

The repository includes a `vercel.json` and `vercel-build.sh` that configure
the Vercel build pipeline for Flutter Web:

```bash
# Build release web bundle
flutter build web --release --base-href /

# Preview locally
flutter run -d web-server --web-port 8080
```

---

### 🔄 Data Flow

```
Widget (ConsumerWidget)
  │
  │  ref.watch(someProvider)
  ▼
Riverpod Notifier  ──► Repository ──► Dio ──► REST API (Node.js)
  │                                      └──► Supabase (avatars)
  │  state = ...                         └──► Open-Meteo (weather)
  ▼
Widget rebuilds with new data
```

**Key Riverpod patterns used:**
- `@riverpod` annotation + code generation (no manual `StateNotifierProvider`)
- `keepAlive: true` on `SocketService` for a persistent WebSocket connection
- `ref.listen` in `MainWrapper` to react to auth changes (connect socket on login)
- `AsyncValue` pattern (`when(data, loading, error)`) in all async screens

---

### 🌐 Localisation

The app ships with full **English** and **Arabic** support:

```
lib/l10n/
├── app_en.arb     # English strings
└── app_ar.arb     # Arabic strings (RTL)
```

Generated via Flutter's `gen-l10n` tool (configured in `l10n.yaml`).

In code, the `L10nExtension` provides a shorthand:
```dart
// Instead of: AppLocalizations.of(context)!.someKey
context.l10n.someKey
```

---

### 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Run the linter: `dart analyze lib`
4. Run tests: `flutter test`
5. Submit a pull request against `main`

**Code style:** Follow the existing patterns — `freezed` models, `@riverpod`-generated providers, `repository → provider → widget` data flow. Do not hardcode strings; add them to the `.arb` files.

---

### 📄 License

MIT © SeYaha Team — see [LICENSE](LICENSE) for details.

---

<br/>

---

## 🇸🇦 العربية

<div dir="rtl">

### 🚀 نظرة عامة

**سيّاحة (SeYaha)** هو تطبيق سياحي متكامل جاهز للإنتاج، مُصمَّم لـ **سوق السياحة المصري**. يربط التطبيق أربعة أدوار مستخدم مختلفة — المسافرين، شركات السياحة، المرشدين السياحيين، والمديرين — من خلال قاعدة كود Flutter موحّدة تعمل على **Android وiOS والويب**.

يعتمد التطبيق على **واجهة برمجية REST** مبنية بـ Node.js (مستضافة على Vercel) للبيانات الرئيسية، و**Supabase** لتخزين الصور الشخصية في الوقت الفعلي. الدردشة الفورية مدعومة بـ **Socket.IO**، والمساعد الذكي يعمل بـ **Google Gemini**.

---

### 👥 هيكل الأدوار المتعددة

| الدور | الواجهة الرئيسية | الصلاحيات الرئيسية |
|-------|----------------|------------------|
| **المسافر** | `MainWrapper` | تصفح وحجز الخدمات، الدردشة، الطقس، نصائح الذكاء الاصطناعي |
| **المرشد السياحي** | `MainWrapper` (تبويبات المرشد) | عرض الجولات المُعيَّنة، إدارة الجدول، الدردشة |
| **مدير الشركة** | `CompanyMainWrapper` | إدارة الخدمات، الموافقة على الحجوزات، تعيين المرشدين |
| **المدير العام** | `AdminMainWrapper` | الإشراف الكامل على المنصة، التحليلات، إدارة المحتوى |
| **ضيف** | `MainWrapper` (للقراءة فقط) | تصفح الخدمات بدون حساب |

---

### ✨ أبرز الميزات

#### 🗺️ الاستكشاف والاكتشاف
- خرائط تفاعلية باستخدام `flutter_map` مع تثبيت 50+ مدينة مصرية
- تصفية الخدمات حسب الفئة (فنادق، جولات، سيارات، عقارات)، السعر، والبحث النصي
- عنصر الطقس باستخدام **Open-Meteo API** (لا يحتاج مفتاح API)
- الخدمات الرائجة وتغذية المقالات المنسقة على الصفحة الرئيسية

#### 📅 دورة حياة الحجز
- مسار حجز كامل: تصفح ← اختيار التواريخ ← تأكيد ← تتبع
- تحديثات الحالة الفورية: `قيد الانتظار → مؤكد → مكتمل`
- تعيين المرشدين من قِبَل مديري الشركات
- إلغاء الحجز مع تغذية راجعة فورية للواجهة

#### 💬 الدردشة الفورية
- اتصال WebSocket مستمر عبر `socket_io_client`
- قائمة المحادثات مع عدّادات الرسائل غير المقروءة
- إشعارات داخل التطبيق للرسائل وتحديثات الحجز

#### 🤖 المساعد الذكي للسياحة
- مدعوم بـ **Google Gemini** (`google_generative_ai`)
- توصيات سفر سياقية، نصائح الجدول الزمني، ملخصات الوجهات

#### 🏛️ لوحة تحكم الإدارة
- إدارة المستخدمين والشركات (تفعيل، حظر، توثيق)
- سير عمل الموافقة على الشركات (الشركات الجديدة في وضع `انتظار` حتى الموافقة)
- نظام إدارة المقالات والأخبار
- رسوم بيانية تحليلية عبر `fl_chart`

---

### ⚙️ خطوات البدء

#### المتطلبات
- [Flutter SDK](https://flutter.dev/docs/get-started/install) **≥ 3.10.3**
- Dart **≥ 3.0**
- [مفتاح Google Gemini API](https://ai.google.dev) (اختياري)
- مشروع [Supabase](https://supabase.com) (اختياري - لتخزين الصور الشخصية)

#### التثبيت

**1. استنساخ المستودع**
```bash
git clone https://github.com/your-org/flutter_tourism_app_26.git
cd flutter_tourism_app_26
```

**2. تثبيت الحزم**
```bash
flutter pub get
```

**3. توليد الكود** (نماذج Freezed + مزودو Riverpod)
```bash
dart run build_runner build --delete-conflicting-outputs
```

**4. إنشاء ملف `.env`**
```env
# مطلوب — رابط API الأساسي (يستخدم الإنتاج افتراضياً إذا لم يُحدَّد)
API_BASE_URL=https://se-yaha.vercel.app

# اختياري — Supabase (لرفع الصور الشخصية)
SUPABASE_URL=https://<project-id>.supabase.co
SUPABASE_ANON_KEY=eyJ...

# اختياري — مساعد Gemini الذكي
GEMINI_API_KEY=AIza...
```

**5. تشغيل التطبيق**
```bash
# موبايل
flutter run

# ويب
flutter run -d chrome
```

---

### 🔐 نموذج الأمان

```
العميل ──► SanitizationInterceptor  (تعقيم XSS، حد الحمولة 1 ميجابايت)
       ──► RateLimitInterceptor     (5 محاولات مصادقة / 15 دقيقة)
       ──► Auth Interceptor         (Bearer JWT من FlutterSecureStorage)
       ──► TLS                      (مُطبَّق من Vercel + Supabase)
       ──► Node.js REST API         (التحقق من جانب الخادم + Mongoose)
```

---

### 🌐 التعريب

يدعم التطبيق **الإنجليزية** و**العربية** بالكامل (RTL):

```
lib/l10n/
├── app_en.arb     # نصوص إنجليزية
└── app_ar.arb     # نصوص عربية (من اليمين لليسار)
```

---

### 📄 الترخيص

MIT © فريق سيّاحة — راجع ملف [LICENSE](LICENSE) للتفاصيل.

</div>
