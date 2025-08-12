# Cart Feature Implementation

## Overview

This document outlines the implementation of the cart feature for the CarsNan car wash service booking app. The feature allows users to:

1. Select a service from the dashboard
2. Choose a car from their available vehicles
3. Add the service+car combination to cart
4. View cart items with a dynamic cart icon
5. Manage cart items (view, remove)

## Architecture

Following Clean Architecture and MVVM patterns:

### Domain Layer

- **CartItem Entity**: Represents a service-car combination in the cart
- **Cart Entity**: Represents the complete cart with multiple items
- **CartRepository**: Interface for cart operations
- **AddToCartUseCase**: Business logic for adding items
- **GetCartItemsUseCase**: Business logic for retrieving cart
- **RemoveFromCartUseCase**: Business logic for removing items
- **ClearCartUseCase**: Business logic for clearing cart

### Data Layer

- **CartLocalDataSource**: Local storage implementation using Hive/SharedPreferences
- **CartRepositoryImpl**: Implementation of CartRepository

### Presentation Layer

- **CartCubit**: State management for cart operations
- **CartState**: Immutable state representation
- **CartPage**: Full cart view page
- **CartIconWidget**: Dynamic cart icon with item count
- **CarSelectionBottomSheet**: Modal for car selection
- **CartItemWidget**: Individual cart item display

## User Flow

1. User taps on service card → Opens service details
2. User taps "Add to Cart" → Shows car selection modal
3. User selects a car → Item added to cart with confirmation
4. Cart icon updates with item count
5. User can tap cart icon to view full cart

## Demo Data

All data will use demo/mock data sources for initial implementation:

- Mock car data from existing car feature
- Service data from existing dashboard feature
- Cart storage will be local (Hive/SharedPreferences)

## Features

- ✅ Add service+car combination to cart
- ✅ Dynamic cart icon with item count
- ✅ Car selection modal
- ✅ Cart items management
- ✅ Price calculation with car type multiplier
- ✅ Remove individual items
- ✅ Clear entire cart
- ✅ Persistent cart storage

## Technical Decisions

- **State Management**: Cubit for simpler state management
- **Storage**: Local storage for cart persistence
- **Navigation**: Modal bottom sheets for car selection
- **Price Calculation**: Car type multiplier applied to service price
- **Cart Icon**: Positioned in app bar with badge showing count
