# CarsNan - Premium Car Service App

A Flutter-based mobile application for premium car service bookings with a modern black and gold aesthetic theme.

## 🎨 Design Features

### Theme
- **Premium Color Scheme**: Black and Gold combination for a luxurious feel
- **Dynamic Theming**: Configurable light and dark themes
- **Material 3 Design**: Modern UI components and styling

### Dashboard Layout
- **Top Action Bar**: Add Address (left) and Add Vehicle (right) buttons
- **Service Cards**: Three service tiers - General, Premium, and Luxury
- **Bottom Navigation**: Home, My Orders, and My Profile tabs
- **Premium Typography**: Clean, modern font styling with gold accents

## 🏗️ Architecture

### Clean Architecture Structure
```
lib/
├── core/
│   ├── constants/         # App constants and sizes
│   ├── theme/            # Theme configuration
│   ├── injection/        # Dependency injection setup
│   └── router/           # Navigation configuration
└── features/
    └── dashboard/
        ├── data/
        │   ├── datasources/    # Local data sources
        │   └── repositories/   # Repository implementations
        ├── domain/
        │   ├── entities/       # Business entities
        │   ├── repositories/   # Repository interfaces
        │   └── usecases/       # Business logic
        └── presentation/
            ├── cubit/          # State management (Cubit)
            ├── pages/          # UI pages
            └── widgets/        # Reusable UI components
```

### Key Components

#### Entities
- **Service**: Car service offerings (General, Premium, Luxury)
- **Address**: User address management
- **Vehicle**: User vehicle information

#### Services
- **General Service** ($29.99): Basic car maintenance and cleaning
- **Premium Service** ($59.99): Enhanced service with detailed cleaning
- **Luxury Service** ($129.99): Premium experience with pick-up/delivery

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.8.1+)
- Dart SDK
- Android Studio / VS Code
- Firebase project setup

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd carsnan
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Dependencies

#### Core
- `flutter_bloc`: State management
- `get_it`: Dependency injection
- `injectable`: Code generation for DI
- `go_router`: Navigation

#### Development
- `build_runner`: Code generation
- `freezed`: Immutable data classes
- `json_serializable`: JSON serialization

## 📱 Features

### Current Implementation
- ✅ Premium black/gold theme system
- ✅ Dashboard with service cards
- ✅ Top action buttons (Add Address/Vehicle)
- ✅ Bottom navigation bar
- ✅ Clean Architecture structure
- ✅ State management with Cubit
- ✅ Mock service data

### Upcoming Features
- 🔲 Address management system
- 🔲 Vehicle management system
- 🔲 Service booking flow
- 🔲 Order tracking
- 🔲 User profile management
- 🔲 Firebase backend integration
- 🔲 Payment integration
- 🔲 Push notifications

## 🎯 Usage

### Theme Customization
The app uses a centralized theme system that can be easily modified:

```dart
// Located in: lib/core/theme/app_theme.dart
static const Color _primaryGold = Color(0xFFD4AF37);
static const Color _secondaryGold = Color(0xFFFFD700);
static const Color _deepBlack = Color(0xFF000000);
```

### Adding New Services
Services are currently defined in the local datasource:

```dart
// Located in: lib/features/dashboard/data/datasources/service_local_datasource.dart
// Add new Service objects to the getServices() method
```

## 🔧 Development

### State Management
The app uses **Cubit** (flutter_bloc) for state management:

```dart
// Dashboard state management
class DashboardCubit extends Cubit<DashboardState> {
  // Handle service loading, navigation, etc.
}
```

### Adding New Features
1. Create feature folder under `lib/features/`
2. Follow Clean Architecture structure
3. Add entities, repositories, and use cases
4. Implement data sources
5. Create UI with Cubit for state management

## 📋 Project Status

- **Phase 1**: Dashboard UI ✅ (Current)
- **Phase 2**: Address & Vehicle Management (Next)
- **Phase 3**: Service Booking Flow
- **Phase 4**: Backend Integration
- **Phase 5**: Advanced Features

## 🤝 Contributing

1. Follow Clean Architecture principles
2. Use the established theming system
3. Implement proper error handling
4. Add unit tests for business logic
5. Follow Dart/Flutter best practices

## 📄 License

This project is part of the CarsNan mobile application.
