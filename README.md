# FreshGrocery - Responsive Flutter E-commerce App

A modern, responsive grocery delivery application built with Flutter using Clean Architecture principles and GetX for state management.

## 🚀 Features

- **Responsive Layout**: Seamlessly works on mobile and desktop/web.
- **Product Discovery**: Browse products by categories (Vegetables, Fruits, Dairy, Pantry).
- **Advanced Search**: Real-time product search functionality.
- **Cart Management**: Reactive cart updates with quantity steppers.
- **Checkout Flow**: Multi-step checkout including address selection and delivery slots.
- **Payment Integration**: 
  - **eSewa ePay v2**: Integrated via WebView for secure digital payments (UAT).
  - **Cash on Delivery**: Traditional payment support.
- **Profile Management**: 
  - Update personal information (Name, Phone, Email).
  - Manage multiple saved delivery addresses.
- **Local Persistence**: User preferences, addresses, and payment methods persist across sessions using `GetStorage`.
- **Local Assets**: All product images are bundled locally for faster loading and offline support.

## 🛠 Tech Stack

- **Framework**: [Flutter](https://flutter.dev)
- **State Management**: [GetX](https://pub.dev/packages/get)
- **Persistence**: [GetStorage](https://pub.dev/packages/get_storage)
- **Networking/UI**: `cached_network_image`, `webview_flutter`
- **Styling**: Google Fonts (Poppins), Material 3 Design
- **Security**: `crypto` for HMAC-SHA256 signatures

## 📦 Getting Started

### Prerequisites

- Flutter SDK: `^3.11.5`
- Android Studio / VS Code
- Android `minSdkVersion`: 21 (Required for WebView)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/grocery-app.git
   cd grocery-app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## 💳 eSewa Integration (Testing)

The app is currently configured for the **eSewa UAT (Testing)** environment. Use the following credentials for testing:

- **Mobile Number**: `9806000000`
- **Password**: `test@123`
- **MPIN**: `1122`
- **OTP**: `123456`

> **Note**: For production, move signature generation to a secure backend server and update the endpoints and secret keys in `lib/screens/esewa_payment_screen.dart`.

## 📁 Project Structure

```text
lib/
├── controllers/    # GetX Controllers (Business Logic)
├── models/         # Data Models
├── services/       # Mock Data, Storage, and API Services
├── widgets/        # Reusable UI Components
├── views/          # Screen-level UI
│   ├── home/
│   ├── product_details/
│   ├── cart/
│   ├── checkout/
│   └── profile/
└── screens/        # Independent screens (e.g., Payment WebView)
```

## 🎨 Design System

- **Primary Color**: Crisp Green (`0xFF2E7D32`)
- **Secondary Color**: Warm Orange (`0xFFF57C00`)
- **Font**: Poppins (via Google Fonts)

## 🌐 Hosting & Deployment

### 1. Web Hosting (Firebase Hosting)
Ideal for showcasing the responsive web version of the app.
1. Build for web:
   ```bash
   flutter build web --release
   ```
2. Initialize Firebase (if not already):
   ```bash
   firebase init hosting
   ```
   - Select `build/web` as the public directory.
   - Configure as a single-page app (Yes).
3. Deploy:
   ```bash
   firebase deploy
   ```

### 2. Web Hosting (GitHub Pages)
1. Build for web with base-href (replace `<repo-name>`):
   ```bash
   flutter build web --release --base-href "/<repo-name>/"
   ```
2. Deploy the contents of `build/web` to the `gh-pages` branch.

### 3. Android Distribution
To share the app for testing:
1. Build the APK:
   ```bash
   flutter build apk --release
   ```
2. Share the file found at: `build/app/outputs/flutter-apk/app-release.apk`.

## 📄 License

This project is open-source. Feel free to use it as a base for your own projects.
