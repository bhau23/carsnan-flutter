# Add Car Feature Specification

## Overview

The Add Car feature allows users to add, manage, and select their vehicles for car washing services. The feature follows clean architecture principles with proper separation of concerns across presentation, domain, and data layers.

## Requirements

### Functional Requirements

1. **Car Management**
   - Users can add new cars to their profile
   - Users can view their list of cars
   - Users can edit existing car details
   - Users can delete cars from their profile
   - Users can set a default car

2. **Car Types**
   - Support for 3 main vehicle types: Sedan, SUV, Mini
   - Each type has different pricing for services
   - Visual representation for each car type

3. **Car Information**
   - Make (e.g., Toyota, Honda, BMW)
   - Model (e.g., Camry, Accord, X5)
   - Year
   - Color
   - License Plate
   - Nickname (optional user-friendly name)
   - Car Type (Sedan, SUV, Mini)

4. **Integration with Services**
   - Car selection affects service pricing
   - Default car is pre-selected in service booking
   - Service recommendations based on car type

### Non-Functional Requirements

1. **Performance**: Fast loading and smooth animations
2. **Usability**: Intuitive UI/UX for car management
3. **Reliability**: Data persistence and error handling
4. **Maintainability**: Clean architecture with proper separation

## Architecture

### Domain Layer

- **Entities**: Car, CarType
- **Repositories**: CarRepository (abstract)
- **Use Cases**:
  - AddCarUseCase
  - GetCarsUseCase
  - UpdateCarUseCase
  - DeleteCarUseCase
  - SetDefaultCarUseCase

### Data Layer

- **Models**: CarModel (with JSON serialization)
- **Data Sources**: CarLocalDataSource (demo data)
- **Repositories**: CarRepositoryImpl

### Presentation Layer

- **State Management**: CarCubit with CarState
- **Pages**:
  - AddCarPage
  - CarListPage
  - EditCarPage
- **Widgets**:
  - CarCard
  - CarTypeSelector
  - CarForm
  - AddCarButton

## Navigation Flow

1. Dashboard → Add Car Button → Car List Page
2. Car List Page → Add Car Button → Add Car Page
3. Car List Page → Car Card → Edit Car Page
4. Service Selection → Car Selector → Car List (if no default)

## Data Models

### Car Entity

```dart
class Car {
  final String id;
  final String make;
  final String model;
  final int year;
  final String color;
  final String licensePlate;
  final String? nickname;
  final CarType type;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;
}

enum CarType {
  sedan(displayName: 'Sedan', priceMultiplier: 1.0),
  suv(displayName: 'SUV', priceMultiplier: 1.2),
  mini(displayName: 'Mini', priceMultiplier: 0.8);
}
```

## Demo Data

Initial demo data will include:

- 3 sample cars (one of each type)
- Different makes and models
- Realistic car information
- One default car

## Testing Strategy

- Unit tests for all use cases
- Unit tests for CarCubit
- Widget tests for forms and car cards
- Integration tests for the complete flow

## Future Enhancements

- Photo upload for cars
- Car maintenance tracking
- Service history per car
- Advanced car search and filtering
- Multiple owner support
