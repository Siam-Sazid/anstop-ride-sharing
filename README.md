# RideShare — Flutter Ride-Sharing App

A full-featured, cross-platform ride-sharing mobile application built with Flutter, supporting both **passengers** and **drivers** in a single codebase.

> 📱 This app is already published on the Google Play Store.

---

## Overview

RideShare connects passengers looking for rides with nearby drivers in real time. The app provides a seamless experience from booking a ride to completing payment, with live tracking, in-app messaging, and post-trip rating — all powered by a real-time backend via WebSockets.

---

## Key Features

### For Passengers
- **Book a Ride** — Search for available drivers, select a pickup and drop-off location using Google Maps/Places, and request a ride.
- **Live Trip Tracking** — Track the driver's location on a live map from pickup to destination.
- **In-App Messaging** — Chat with the driver before and during the trip.
- **Payment** — Pay for trips securely via Stripe (card payments).
- **Wallet** — Manage a built-in wallet for easy top-up and ride payments.
- **Trip History** — View past rides with full trip details and invoices.
- **Driver Rating** — Rate drivers after trip completion.
- **Support** — Submit support tickets directly from the app.

### For Drivers
- **Trip Requests** — Receive and accept incoming ride requests in real time.
- **Navigation** — Get directions to passenger pickup and destination.
- **Trip Management** — Manage active trips through the full flow: accept → arrive → pickup → complete.
- **In-App Messaging** — Chat with passengers during a trip.
- **Earnings & Wallet** — View earnings and manage wallet balance.
- **Trip History** — Review completed trips and invoices.
- **Profile Management** — Update profile, vehicle details, and documents.
- **Support** — Access in-app support.

### General
- **Authentication** — Phone number-based OTP login for both passengers and drivers.
- **Push Notifications** — Firebase Cloud Messaging (FCM) for ride requests, status updates, and alerts.
- **Real-Time Updates** — Socket.IO integration for live driver location, trip status, and chat messages.
- **Onboarding** — Guided onboarding flow for new users.
- **Localization** — Multi-language support via Flutter's built-in localization system.
- **Connectivity Awareness** — Detects and handles loss of internet connection gracefully.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| State Management | GetX |
| Maps & Location | Google Maps, Google Places, Geolocator, Geocoding |
| Real-Time | Socket.IO |
| Payments | Stripe |
| Push Notifications | Firebase Cloud Messaging |
| Auth / Storage | Shared Preferences |
| Media | Image Picker, Cached Network Image |

---

## Platforms

- Android
- iOS
- (Web / Desktop scaffolding present)

---

## Getting Started

### Prerequisites
- Flutter SDK `^3.9.0`
- A configured `.env` file with API base URL, Google Maps API key, and Stripe publishable key.
- `google-services.json` placed in `android/app/` for Firebase.

### Install & Run

```bash
flutter pub get
flutter run
```

### Generate Assets & Icons

```bash
# Generate asset classes
flutter pub run build_runner build --delete-conflicting-outputs

# Generate launcher icons
flutter pub run flutter_launcher_icons
```





## License

This project is private and not published to pub.dev.
