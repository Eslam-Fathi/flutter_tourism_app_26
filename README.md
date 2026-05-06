# 🌍 Flutter Tourism App 26

[English Version](#english-version) | [النسخة العربية](#النسخة-العربية)

---

## English Version

### 🚀 Overview
A premium Tourism & Management application built with Flutter. This project provides a comprehensive platform for travelers to explore destinations, book tours, and interact with tour guides, while offering a robust administrative dashboard for managing users, companies, and content.

### ✨ Key Features
*   **👤 Multi-Role System**: Dedicated interfaces for Users, Tour Guides, Companies, and Administrators.
*   **🏢 Admin Dashboard**: Comprehensive management of users, tourism companies, and published articles.
*   **🗺️ Explore & Discover**: Interactive maps and destination lists to find the best spots.
*   **📅 Booking System**: Seamless booking process for tours and tourism services.
*   **💬 Real-time Chat**: Integrated chat system using Socket.io for instant communication.
*   **🤖 AI Assistant**: Powered by Google Gemini AI to provide smart travel recommendations.
*   **📊 Analytics**: Visualized data charts for administrative insights.
*   **📱 Responsive Design**: Optimized for Mobile, Tablet, and Web (Vercel deployment ready).
*   **🌐 Localization**: Full support for English and Arabic with RTL layout handling.

### 🛠️ Tech Stack
*   **Framework**: Flutter (Dart)
*   **State Management**: Riverpod (with Code Generation)
*   **Backend & Database**: Supabase
*   **Networking**: Dio & Pretty Dio Logger
*   **Real-time**: Socket.io
*   **AI**: Google Generative AI (Gemini)
*   **Maps**: Flutter Map & LatLong2
*   **UI/UX**: Google Fonts, Lucide Icons, Shimmer, badges, and more.

### 🏗️ Architecture
The project follows **Clean Architecture** principles to ensure scalability and maintainability:
- `core/`: Common utilities, themes, and network configurations.
- `data/`: Models, repositories, and data sources (Supabase/API).
- `presentation/`: UI screens, widgets, and Riverpod providers.
- `l10n/`: Localization files (ARB).

### ⚙️ Getting Started
1.  **Clone the repository**:
    ```bash
    git clone [repository-url]
    ```
2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Environment Variables**:
    Create a `.env` file in the root directory and add your keys:
    ```env
    SUPABASE_URL=your_url
    SUPABASE_ANON_KEY=your_key
    GEMINI_API_KEY=your_api_key
    ```
4.  **Run the app**:
    ```bash
    flutter run
    ```

---

## النسخة العربية

### 🚀 نظرة عامة
تطبيق سياحي وإداري متميز تم بناؤه باستخدام Flutter. يوفر هذا المشروع منصة شاملة للمسافرين لاستكشاف الوجهات، وحجز الجولات، والتفاعل مع المرشدين السياحيين، مع تقديم لوحة تحكم إدارية قوية لإدارة المستخدمين والشركات والمحتوى.

### ✨ المميزات الرئيسية
*   **👤 نظام متعدد الأدوار**: واجهات مخصصة للمستخدمين، المرشدين السياحيين، الشركات، والمديرين.
*   **🏢 لوحة تحكم الإدارة**: إدارة شاملة للمستخدمين، شركات السياحة، والمقالات المنشورة.
*   **🗺️ الاستكشاف والاكتشاف**: خرائط تفاعلية وقوائم وجهات للعثور على أفضل الأماكن.
*   **📅 نظام الحجز**: عملية حجز سلسة للجولات والخدمات السياحية.
*   **💬 دردشة فورية**: نظام دردشة متكامل باستخدام Socket.io للتواصل الفوري.
*   **🤖 مساعد ذكاء اصطناعي**: مدعوم بـ Google Gemini AI لتقديم توصيات سفر ذكية.
*   **📊 التحليلات**: رسوم بيانية للبيانات لتوفير رؤى إدارية.
*   **📱 تصميم متجاوب**: محسن للجوال، الجهاز اللوحي، والويب (جاهز للنشر على Vercel).
*   **🌐 التعريب**: دعم كامل للغتين الإنجليزية والعربية مع التعامل مع اتجاه النص (RTL).

### 🛠️ التقنيات المستخدمة
*   **إطار العمل**: Flutter (Dart)
*   **إدارة الحالة**: Riverpod (مع توليد الكود تلقائياً)
*   **الخلفية وقاعدة البيانات**: Supabase
*   **الشبكات**: Dio & Pretty Dio Logger
*   **التواصل الفوري**: Socket.io
*   **الذكاء الاصطناعي**: Google Generative AI (Gemini)
*   **الخرائط**: Flutter Map & LatLong2
*   **الواجهة والتصميم**: Google Fonts, Lucide Icons, Shimmer, badges, وغيرها.

### 🏗️ المعمارية
يتبع المشروع مبادئ **Clean Architecture** لضمان القابلية للتوسع وسهولة الصيانة:
- `core/`: الأدوات المشتركة، الثيمات، وإعدادات الشبكة.
- `data/`: النماذج، المستودعات، ومصادر البيانات (Supabase/API).
- `presentation/`: واجهات المستخدم، العناصر (Widgets)، ومزودي الحالة (Providers).
- `l10n/`: ملفات الترجمة (ARB).

### ⚙️ البدء بالعمل
1.  **استنساخ المستودع**:
    ```bash
    git clone [repository-url]
    ```
2.  **تثبيت الحزم**:
    ```bash
    flutter pub get
    ```
3.  **متغيرات البيئة**:
    قم بإنشاء ملف `.env` في المجلد الرئيسي وأضف مفاتيحك:
    ```env
    SUPABASE_URL=your_url
    SUPABASE_ANON_KEY=your_key
    GEMINI_API_KEY=your_api_key
    ```
4.  **تشغيل التطبيق**:
    ```bash
    flutter run
    ```
