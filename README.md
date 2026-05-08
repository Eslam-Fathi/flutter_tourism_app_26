# 🌍 Flutter Tourism App 26

[English Version](#english-version) | [النسخة العربية](#النسخة-العربية) | [📖 User Guide](./docs/USER_GUIDE.md)


---

## English Version

### 🚀 Overview
**Flutter Tourism App 26** is a state-of-the-art, multi-role tourism management ecosystem. It bridges the gap between travelers, tourism agencies, tour guides, and administrators through a seamless, real-time interface. Built with performance and scalability in mind, it leverages modern technologies like Supabase for backend services and Google Gemini for AI-driven intelligence.

---

### 👥 Multi-Role Ecosystem
The application serves four distinct user types, each with a tailored experience:
1.  **Travelers (Users)**: Explore destinations, book tours, chat with guides, and receive AI-driven travel advice.
2.  **Tourism Companies**: Manage service listings, track bookings, and interact with customers.
3.  **Tour Guides**: Professional profiles, schedule management, and real-time communication with travelers.
4.  **Administrators**: A powerful dashboard to oversee users, companies, articles, and system analytics.

---

### ✨ Comprehensive Features

#### 🏛️ Administrative Dashboard
- **User Management**: Oversee and manage all registered accounts.
- **Company Verification**: Review and approve tourism agency applications.
- **Content Hub**: Create and publish tourism articles and news.
- **Analytics Overview**: Visualized insights into system growth and activity using `fl_chart`.

#### 🗺️ Exploration & Services
- **Smart Discovery**: Interactive map integration using `flutter_map` with custom tile providers.
- **Booking Lifecycle**: Complete flow from service discovery to reservation and payment tracking.
- **Interactions**: User reviews, ratings, and likes for services and articles.
- **Weather Integration**: Real-time weather updates for destinations to help travelers plan better.

#### 💬 Real-time Communication
- **Instant Messaging**: Low-latency chat system powered by `Socket.io`.
- **Notifications**: In-app notifications to keep users updated on bookings and messages.

#### 🤖 AI Intelligence
- **Gemini AI Assistant**: An integrated AI companion that provides smart recommendations, destination summaries, and travel tips.

---

### 🛠️ Technical Stack & Architecture

#### **Core Technologies**
- **State Management**: `Riverpod` with `riverpod_generator` for robust and testable state handling.
- **Backend**: `Supabase` (Authentication, PostgreSQL Database, and Storage).
- **Networking**: `Dio` with custom interceptors for rate limiting and logging.
- **Data Handling**: `Freezed` & `Json_Serializable` for immutable models and type-safe JSON parsing.
- **Real-time**: `socket_io_client`.

#### **Project Structure (Clean Architecture)**
- **`lib/core/`**:
    - `network/`: Interceptors, API clients, and rate limiters.
    - `theme/`: Dynamic Material 3 design system.
    - `storage/`: Secure storage implementations for sensitive data.
- **`lib/data/`**:
    - `models/`: Immutable data structures (Articles, Bookings, Users, etc.).
    - `repositories/`: Abstracted data access layers.
- **`lib/presentation/`**:
    - `screens/`: Role-specific UI (Admin, Auth, Company, Explore, etc.).
    - `providers/`: Business logic and state management using Riverpod.
    - `widgets/`: Reusable UI components.

---

### ⚙️ Getting Started

#### **Prerequisites**
- Flutter SDK (>=3.10.3)
- A Supabase Project
- A Google Gemini API Key

#### **Installation**
1.  **Clone the repository**:
    ```bash
    git clone [repository-url]
    ```
2.  **Fetch dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Code Generation**:
    Run build_runner to generate models and providers:
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
4.  **Environment Setup**:
    Create a `.env` file in the root:
    ```env
    SUPABASE_URL=your_supabase_url
    SUPABASE_ANON_KEY=your_anon_key
    GEMINI_API_KEY=your_gemini_key
    ```
5.  **Run the application**:
    ```bash
    flutter run
    ```

---

## النسخة العربية

### 🚀 نظرة عامة | [📖 دليل المستخدم](./docs/USER_GUIDE.md)

**تطبيق السياحة المطور (نسخة 26)** هو منظومة متكاملة لإدارة السياحة بنظام الأدوار المتعددة. يعمل التطبيق كحلقة وصل متطورة بين المسافرين، وكالات السياحة، المرشدين السياحيين، والمديرين من خلال واجهة مستخدم سلسة وفورية. تم تصميم التطبيق مع التركيز على الأداء والقابلية للتوسع، معتمداً على تقنيات حديثة مثل Supabase للخدمات الخلفية و Google Gemini للذكاء الاصطناعي.

---

### 👥 منظومة الأدوار المتعددة
يخدم التطبيق أربعة أنواع من المستخدمين، لكل منهم تجربة مخصصة:
1.  **المسافرون (المستخدمون)**: استكشاف الوجهات، حجز الرحلات، الدردشة مع المرشدين، والحصول على نصائح سفر ذكية.
2.  **شركات السياحة**: إدارة قوائم الخدمات، تتبع الحجوزات، والتواصل مع العملاء.
3.  **المرشدون السياحيون**: ملفات شخصية احترافية، إدارة الجداول الزمنية، والتواصل الفوري مع المسافرين.
4.  **المديرون**: لوحة تحكم قوية للإشراف على المستخدمين، الشركات، المقالات، وتحليلات النظام.

---

### ✨ المميزات الشاملة

#### 🏛️ لوحة تحكم الإدارة
- **إدارة المستخدمين**: الإشراف على جميع الحسابات المسجلة وإدارتها.
- **توثيق الشركات**: مراجعة واعتماد طلبات وكالات السياحة.
- **مركز المحتوى**: إنشاء ونشر المقالات والأخبار السياحية.
- **نظرة عامة على التحليلات**: رؤى مرئية حول نمو النظام ونشاطه باستخدام `fl_chart`.

#### 🗺️ الاستكشاف والخدمات
- **الاكتشاف الذكي**: تكامل الخرائط التفاعلية باستخدام `flutter_map` مع مزودي خرائط مخصصين.
- **دورة حياة الحجز**: تدفق كامل من اكتشاف الخدمة إلى الحجز وتتبع الدفع.
- **التفاعلات**: مراجعات المستخدمين، التقييمات، والإعجابات للخدمات والمقالات.
- **تكامل الطقس**: تحديثات الطقس الفورية للوجهات لمساعدة المسافرين على التخطيط بشكل أفضل.

#### 💬 التواصل الفوري
- **المراسلة الفورية**: نظام دردشة سريع الاستجابة مدعوم بـ `Socket.io`.
- **التنبيهات**: إشعارات داخل التطبيق لإبقاء المستخدمين على اطلاع دائم بالحجوزات والرسائل.

#### 🤖 الذكاء الاصطناعي
- **مساعد Gemini الذكي**: رفيق سفر ذكي مدمج يقدم توصيات مخصصة، ملخصات للوجهات، ونصائح سفر احترافية.

---

### 🛠️ البناء التقني والمعمارية

#### **التقنيات الأساسية**
- **إدارة الحالة**: `Riverpod` مع `riverpod_generator` لمعالجة حالة قوية وقابلة للاختبار.
- **الخدمات الخلفية**: `Supabase` (الهوية، قاعدة بيانات PostgreSQL، والتخزين السحابي).
- **الشبكات**: `Dio` مع معترضات (Interceptors) مخصصة لتحديد معدل الطلبات والتسجيل.
- **معالجة البيانات**: `Freezed` و `Json_Serializable` للنماذج الثابتة وتحليل JSON الآمن.
- **التواصل الفوري**: `socket_io_client`.

#### **هيكل المشروع (Clean Architecture)**
- **`lib/core/`**:
    - `network/`: المعترضات، عملاء البرمجة، ومحددات السرعة.
    - `theme/`: نظام تصميم Material 3 ديناميكي.
    - `storage/`: تنفيذات التخزين الآمن للبيانات الحساسة.
- **`lib/data/`**:
    - `models/`: هياكل بيانات ثابتة (مقالات، حجوزات، مستخدمون، إلخ).
    - `repositories/`: طبقات الوصول إلى البيانات المجردة.
- **`lib/presentation/`**:
    - `screens/`: واجهات مستخدم مخصصة حسب الدور (مدير، توثيق، شركة، استكشاف، إلخ).
    - `providers/`: منطق الأعمال وإدارة الحالة باستخدام Riverpod.
    - `widgets/`: عناصر واجهة مستخدم قابلة لإعادة الاستخدام.

---

### ⚙️ البدء بالعمل

#### **المتطلبات الأساسية**
- Flutter SDK (>=3.10.3)
- مشروع Supabase قائم
- مفتاح Google Gemini API

#### **خطوات التثبيت**
1.  **استنساخ المستودع**:
    ```bash
    git clone [repository-url]
    ```
2.  **تحميل الحزم**:
    ```bash
    flutter pub get
    ```
3.  **توليد الكود**:
    قم بتشغيل build_runner لتوليد النماذج ومزودي الحالة:
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
4.  **إعداد البيئة**:
    قم بإنشاء ملف `.env` في المجلد الرئيسي:
    ```env
    SUPABASE_URL=your_supabase_url
    SUPABASE_ANON_KEY=your_anon_key
    GEMINI_API_KEY=your_gemini_key
    ```
5.  **تشغيل التطبيق**:
    ```bash
    flutter run
    ```
