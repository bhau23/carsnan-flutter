# CarsNan

A premium car wash and car care booking app built with Flutter, Firebase, and Clean Architecture.

CarsNan lets users pick a service tier, attach one of their saved cars, choose an address and time slot, and check out. The codebase is organised as a feature-first Clean Architecture project with BLoC/Cubit state management, and it also carries the design specifications for the companion Worker and Admin apps.

---

## Tech stack

| Area | Choice |
|---|---|
| Framework | Flutter (Dart SDK `^3.8.1`) |
| Backend | Firebase Auth, Cloud Firestore, Firebase Storage |
| State management | `flutter_bloc` (BLoC + Cubit) |
| Dependency injection | `get_it` + `injectable` |
| Routing | `go_router` |
| Code generation | `freezed`, `json_serializable`, `build_runner` |
| Networking | `dio` |
| Local storage | `hive`, `shared_preferences` |
| Maps & location | `google_maps_flutter`, `geolocator`, `geocoding` |
| Functional helpers | `dartz`, `equatable` |

---

## Features

**Authentication**
- Phone OTP sign-in through Firebase Auth
- Email/password sign-in
- Session persistence and profile bootstrapping

**Service dashboard**
- Three service tiers (General, Premium, Luxury) with tier-specific banners
- Service detail sheets with inclusions and pricing
- Black-and-gold premium theme driven by a central theme config

**Car management**
- Add, edit, and delete cars
- Car types (Sedan, SUV, Mini) with pricing multipliers applied at booking time
- Default car selection used to prefill bookings

**Cart and checkout**
- Add service + car combinations to a cart
- Live price recalculation, add-on products, cart badge count
- Time slot selection and a validated checkout flow

**Address management**
- Multiple saved addresses with a default address
- GPS-assisted address capture via geolocator/geocoding

**Profile**
- Profile details, preferences, and logout

---

## Project structure

```
lib/
├── main.dart                 # Entry point, Firebase + DI bootstrap
├── app.dart                  # Root widget and router wiring
├── theme.dart                # Theme entry
├── firebase_options.dart      # Generated Firebase config (not committed)
├── core/
│   ├── constants/            # App-wide constants
│   ├── di/                   # get_it / injectable setup
│   ├── errors/               # Failures and exceptions
│   ├── models/               # Shared models
│   ├── router/               # go_router configuration
│   ├── services/             # Firebase and platform services
│   ├── theme/                # Colours, typography, component themes
│   └── utils/                # Helpers and extensions
└── features/
    ├── authentication/
    ├── dashboard/
    ├── home/
    ├── car/
    ├── cart/
    ├── address/
    └── profile/
```

Every feature follows the same three-layer split:

```
feature/
├── data/          # datasources, models, repository implementations
├── domain/        # entities, repository contracts, use cases
└── presentation/  # bloc or cubit, pages, widgets
```

Dependencies point inward only: `presentation` → `domain` ← `data`. Domain code has no Flutter or Firebase imports.

---

## Getting started

### Prerequisites

- Flutter SDK 3.8.1 or newer
- A Firebase project with Auth, Firestore, and Storage enabled
- Android Studio or VS Code with the Flutter extension
- Google Maps API key (for the address picker)

### 1. Clone and install

```bash
git clone https://github.com/bhau23/carsnan-flutter.git
cd carsnan-flutter
flutter pub get
```

### 2. Configure Firebase

The repo ships with config for the original Firebase project. To point the app at your own project, regenerate it:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This creates `lib/firebase_options.dart` and drops `android/app/google-services.json` (and `ios/Runner/GoogleService-Info.plist`) into place.

In the Firebase console, enable:
- **Authentication** → Phone and Email/Password providers
- **Cloud Firestore** → in production mode, then apply your security rules
- **Storage** → for car and profile images

### 3. Add your Google Maps API key

Android — in `android/app/src/main/AndroidManifest.xml`:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY" />
```

### 4. Run code generation

Needed after changing any `freezed`, `json_serializable`, or `injectable` annotated file:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 5. Run the app

```bash
flutter run
```

---

## Development commands

```bash
flutter analyze                                        # static analysis
flutter test                                           # run tests
dart run build_runner watch --delete-conflicting-outputs  # codegen in watch mode
flutter build apk --release                            # release Android build
```

---

## Theming

Colours live in the core theme layer and are the single place to rebrand the app.

| Token | Value |
|---|---|
| Primary gold | `#D4AF37` |
| Secondary gold | `#FFD700` |
| Deep black | `#000000` |
| Charcoal black | `#1C1C1C` |

---

## Assets

Service imagery is loaded from `assets/images/`:

```
assets/images/
├── services/
│   └── banners/
│       ├── general/
│       ├── premium/
│       └── luxury/
└── service_items/
    └── shared/
```

To swap a service image, replace the file and keep the existing filename — no code change required.

---

## Documentation

Feature specs and implementation notes are kept in the repo:

- `USER_APP_SPECIFICATION.md` — user app scope and implementation status
- `WORKER_APP_SPECIFICATION.md` — companion worker app specification
- `ADMIN_APP_SPECIFICATION.md` — companion admin app specification
- `ADDRESS_IMPLEMENTATION_GUIDE.md` — address feature walkthrough
- `IMAGE_UPLOAD_GUIDE.md` — Firebase Storage upload flow
- `DASHBOARD_README.md` — dashboard layout notes
- `docs/` — per-feature design and implementation records

---

## Security notes

This repository is **private**. It currently contains committed Firebase client config (`lib/firebase_options.dart` and `android/app/google-services.json`). These files hold public client identifiers rather than server secrets, but if this repo is ever made public you should:

1. Restrict the Firebase API keys by application and API in the Google Cloud console.
2. Lock down Firestore and Storage security rules — they are the only real access boundary, since client-side checks can be bypassed.
3. Consider removing the files from history and switching to locally generated config via `flutterfire configure`.

Signing keystores and release credentials must never be committed.

---

## License

No license has been declared for this project yet. All rights reserved by the author until one is added.
