# StoreBill Pro+

StoreBill Pro+ is a comprehensive Flutter application designed for small manufacturing and trading businesses. It provides a complete offline solution for managing products, purchases, sales, customers, and invoices, with optional AI and voice-powered features to streamline daily operations.

## Features

- **Product Management**: Add, edit, and delete products with details like name, category, purchase/sale price, stock quantity, and unit.
- **AI-Powered Descriptions**: Automatically generate marketing-style product descriptions using a generative AI model.
- **Purchase Module**: Record procurement entries, including supplier name, date, and a list of items. Stock levels are automatically updated.
- **Sales Module**: Create and manage sales invoices with customer details, items, discounts, and taxes.
- **PDF Invoices**: Generate and share professional-looking PDF invoices via WhatsApp, email, or any other sharing platform.
- **Customer Ledger**: Track customer transactions, total due amounts, and mark payments as received.
- **Dashboard & Reports**: Get a quick overview of your business with daily, weekly, and monthly summaries of sales, purchases, profit, and dues, visualized with charts.
- **Voice-Based Search**: Quickly find products by speaking their names, using the integrated speech-to-text functionality.
- **Dark Mode**: Switch between light and dark themes for a comfortable user experience.
- **PIN Lock**: Secure your app with an optional 4-digit PIN lock.

## Tech Stack

- **Frontend**: Flutter 3.22+
- **State Management**: Provider
- **Local Storage**: Hive
- **PDF Generation**: `pdf` & `printing`
- **Charts**: `fl_chart`
- **Voice Recognition**: `speech_to_text`
- **AI Integration**: `google_generative_ai` (Gemini API)

## Setup Instructions

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/storebill_pro_plus.git
   ```
2. **Install dependencies**:
   ```bash
   flutter pub get
   ```
3. **Provide Gemini API Key**:
   This project uses the Gemini API for AI-powered features. To use these features, you'll need to provide your own API key. You can get one from [Google AI Studio](https://aistudio.google.com/).

   When running the app, provide the API key as an environment variable:
   ```bash
   flutter run --dart-define=GEMINI_API_KEY=YOUR_API_KEY
   ```
4. **Run the app**:
   ```bash
   flutter run
   ```

## How to Execute Tests

To run the test suite, use the following command:

```bash
flutter test
```

## Folder Structure

```
lib/
├── main.dart
├── models/
├── providers/
├── services/
├── screens/
├── widgets/
└── utils/
```

## Deployment

### Android

1.  **Build the APK or App Bundle:**
    ```bash
    # For a release APK
    flutter build apk --release

    # For an Android App Bundle (AAB)
    flutter build appbundle --release
    ```
2.  **Locate the output file:**
    *   The APK will be located at `build/app/outputs/flutter-apk/app-release.apk`.
    *   The App Bundle will be at `build/app/outputs/bundle/release/app-release.aab`.

### iOS

1.  **Build the iOS App:**
    ```bash
    flutter build ios --release
    ```
2.  **Deploy via Xcode:**
    *   Open the `ios/Runner.xcworkspace` file in Xcode.
    *   Configure your app signing and provisioning profiles.
    *   Archive the app and distribute it to the App Store or for ad-hoc deployment.

### Web

1.  **Build the Web App:**
    ```bash
    flutter build web
    ```
2.  **Deploy the output:**
    *   The compiled web app will be in the `build/web` directory.
    *   Deploy the contents of this directory to your web server or hosting provider.

## Screenshots

*A placeholder for screenshots of the app will be added here.*

## Developer Notes

### Modular AI Service Integration

The AI service is designed to be modular and can be easily swapped out. The `AIService` class in `lib/services/ai_service.dart` is the central point of interaction with the AI model. To replace the default Gemini API with another service, simply create a new class that implements the same methods and update the `AIService` class accordingly.

### Backup & Restore

The backup and restore feature is currently a work in progress.

### App Flow & Architecture

The app follows a modular, MVVM-style architecture using Provider for state management. Data is stored locally using Hive, and the UI follows Material 3 design with responsive layouts.

**Navigation Flow:**

```
Splash Screen -> Login Screen (if PIN is set) -> Main Screen (with BottomNavigationBar)
  - Dashboard
  - Products -> Product Form
  - Sales -> Sale Form
  - Purchases -> Purchase Form
  - Customers -> Customer Details
  - Reports
```
