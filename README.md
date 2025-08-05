# CarsNan - Car Service App

A premium car washing and service app built with Flutter following Clean Architecture principles.

## 🎨 Features

- **Premium Black & Gold Theme**: Modern, elegant design with customizable colors
- **Service Dashboard**: Grid layout showcasing three service tiers
- **Clean Architecture**: MVVM pattern with proper separation of concerns
- **Custom Service Images**: Support for custom service images

## 🖼️ Adding Service Images

### Image Requirements
- **Format**: PNG, JPG, or JPEG
- **Recommended Size**: 300x200 pixels
- **Content**: Professional car service images
- **Style**: Should match the premium theme

### How to Add Images

1. **Navigate to the assets folder**:
   ```
   assets/images/services/
   ```

2. **Replace the placeholder files** with your actual images:
   - `general_wash.png` - Basic car washing service
   - `premium_wash.png` - Enhanced detailing service  
   - `luxury_wash.png` - Premium luxury service

3. **Keep the same filenames** for automatic integration

4. **Run the app** - Images will be automatically loaded

## 🚀 Getting Started

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code
- Firebase account (for backend features)

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/bhau23/carsnan.git
   cd carsnan
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

## 🎨 Customizing Theme

The app uses a configurable theme system located in `lib/core/theme/app_theme.dart`.

### Color Customization
- **Primary Gold**: `Color(0xFFD4AF37)`
- **Secondary Gold**: `Color(0xFFFFD700)`
- **Deep Black**: `Color(0xFF000000)`
- **Charcoal Black**: `Color(0xFF1C1C1C)`

You can easily modify these colors to match your brand.
