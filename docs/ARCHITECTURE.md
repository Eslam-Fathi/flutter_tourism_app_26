# 🏗️ SeYaha Architecture & Core Concepts

Welcome to the SeYaha technical overview. This document explains the core concepts, architecture, and tech stack choices behind the platform. It is designed to help developers and contributors understand how the app works without having to read through all the source code.

## 1. Clean Architecture Approach

SeYaha is built using a pragmatic implementation of **Clean Architecture**. The codebase is divided into three distinct layers, ensuring separation of concerns, testability, and scalability.

- **`core/` (Infrastructure):** This layer contains elements that are independent of the business logic. It handles networking setup (Dio, WebSocket, Supabase), theme definitions, local storage (FlutterSecureStorage), extensions, and reusable UI components like loading skeletons and custom buttons.
- **`data/` (Data Layer):** The source of truth for the application's data.
  - **Models:** Built using `freezed` and `json_serializable` for immutability and easy JSON parsing. Models map to the Mongoose schemas used on the backend.
  - **Repositories:** Classes responsible for fetching and saving data. A repository abstracts the data source (REST API, Supabase, local storage) so the rest of the app doesn't need to know where the data comes from.
- **`presentation/` (UI & State Layer):** 
  - **Providers:** The Riverpod notifiers that hold the business logic and coordinate between the UI and the repositories. 
  - **Screens & Widgets:** The visual components built with Flutter.

## 2. The Multi-Role System

SeYaha is a unified app serving four distinct user types. Instead of building separate apps for each role, SeYaha uses **Role-Based Access Control (RBAC)** paired with adaptive navigation shells:

- **Traveller:** Browses services, books tours, and asks the AI for advice.
- **Tour Guide:** Views assigned tours and communicates with travellers.
- **Company Manager:** Manages service listings, approves bookings, and assigns guides.
- **Administrator:** Has full oversight, manages users/companies, and publishes articles.

**How it works technically:**
When a user logs in, the `AuthNotifier` fetches their profile, which includes their `role`. The router (or main navigation shell like `MainWrapper`, `CompanyMainWrapper`, etc.) reads this role and dynamically constructs the bottom navigation bar and the available screens. 

## 3. Tech Stack Deep Dive

Here is a look at the technologies powering SeYaha and why they were chosen:

### 🌊 Riverpod (State Management)
We use `flutter_riverpod` combined with `riverpod_generator`. 
- **Code Generation:** Writing providers by hand can lead to boilerplate. We use `@riverpod` annotations so the system generates the providers for us, minimizing errors.
- **AsyncValue:** Riverpod's `AsyncValue` is used extensively for handling loading states and errors out-of-the-box. When a screen requests data, it uses `.when(data: ..., loading: ..., error: ...)` to render the appropriate UI without manual `isLoading` flags.

### 🌐 Dio & Networking
`dio` is our HTTP client for communicating with the Node.js REST API.
- **Interceptors:** We use Dio interceptors to create a robust pipeline:
  - *SanitizationInterceptor:* Prevents XSS attacks before the payload leaves the device.
  - *RateLimitInterceptor:* Mirrors server-side logic (e.g., locking out after too many failed logins).
  - *Auth Interceptor:* Automatically attaches the JWT bearer token to requests.

### 🗄️ Supabase
While our primary backend is a custom Node.js application, we leverage `supabase_flutter` specifically as a "shadow backend" for storage:
- **Avatars & Media:** User profile pictures and service images are uploaded directly to Supabase Storage, bypassing our Node.js server to reduce load and latency.

### 🤖 Google Gemini (AI Assistant)
The `google_generative_ai` package provides the intelligence behind the "AI Travel Assistant".
- **Contextual Prompts:** The app sends user queries ("Plan a 3-day trip to Luxor") along with a hidden system prompt to ensure the AI acts specifically as an Egyptian travel expert.

### 💬 Socket.IO (Real-Time Chat)
For instant messaging between travellers, guides, and companies, we use `socket_io_client`.
- **Persistent Connection:** The `SocketService` is managed by a `keepAlive: true` Riverpod provider. When the user logs in, the socket connects and listens for events (`new_message`, `booking_update`).

## 4. Data Flow (The "Riverpod Way")

Understanding how data flows through SeYaha is key to navigating the codebase. Here is the standard lifecycle of a data request:

1. **User Action:** The user opens the "Explore" screen.
2. **UI Subscription:** The `ExploreScreen` widget uses `ref.watch(servicesProvider)`.
3. **Provider Logic:** The generated `servicesProvider` calls `ServiceRepository.getServices()`.
4. **Data Fetching:** The `ServiceRepository` uses `DioClient` to make a GET request to the Node.js API.
5. **Model Parsing:** The JSON response is parsed into a list of `ServiceModel` objects using `freezed`.
6. **State Update:** The provider updates its state to `AsyncData(List<ServiceModel>)`.
7. **UI Rebuild:** The `ExploreScreen` automatically rebuilds and displays the list of services.

```text
Widget ──(ref.watch)──► Riverpod Notifier ──► Repository ──► Dio ──► REST API
  ▲                                                                     │
  └────────────────────────── (AsyncValue) ◄────────────────────────────┘
```

## 5. Security & Persistence

- **JWT Storage:** We use `flutter_secure_storage` to keep the authentication token in the device's Keychain (iOS) or Keystore (Android). It is never stored in plain text in SharedPreferences.
- **Navigation Guard:** Screens that require authentication are protected. If a guest tries to access the "Chat" tab, they are shown a friendly prompt to register.

## 6. Design System & Aesthetics

SeYaha prioritizes a premium, visually engaging user experience. The design system is centralized in `core/theme/` and features:
- **Material 3 Foundation:** Custom themes (`app_theme.dart`) built on top of Flutter's Material 3, supporting both light and deep-indigo Dark Mode out of the box.
- **Aurora & Glassmorphism:** We use dynamic, animated "Aurora" backgrounds combined with frosted glass (`BackdropFilter`) cards to create a modern, immersive feel.
- **Typography & Localization:** The app uses the **DM Sans** font for clean readability. It fully supports both **English (LTR)** and **Arabic (RTL)** layouts, managed dynamically by Flutter's `Localizations` and `L10nExtension`.
- **Progressive Loading:** Instead of traditional loading spinners, we implement custom Shimmer Skeletons across all screens to ensure a smooth perceived performance while data loads.

## 7. Cross-Platform Strategy (Mobile & Web)

A major goal of SeYaha is delivering a unified experience across devices from a single codebase.

- **Responsive Layouts:** The `core/utils/responsive.dart` helper defines breakpoints. While the app is "mobile-first", layouts adapt gracefully to wider screens (tablets and web browsers) by utilizing constraint-based widgets and adaptive navigation shells (e.g., switching from a bottom navigation bar to a side navigation rail on larger screens).
- **Web-Specific Handling:** 
  - The app is deployed as a Web application on **Vercel** using custom build scripts (`vercel.json` and `vercel-build.sh`).
  - Web routing is handled transparently by Flutter's router system, ensuring deep linking and browser history work seamlessly.
- **Mobile Native Features:** On Android and iOS, the app leverages native capabilities such as secure storage (Keystore/Keychain) for JWT tokens and optimized rendering engines.

---
*By maintaining clear boundaries between the UI, business logic, and data layers, SeYaha remains maintainable and ready to scale as cross-platform features (like payment integrations or AR maps) are added in the future.*
