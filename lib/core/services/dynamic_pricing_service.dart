import 'package:injectable/injectable.dart';
import '../../features/car/domain/entities/car.dart';
import '../../features/dashboard/domain/entities/service.dart';

/// Service to handle dynamic pricing based on vehicle type
@injectable
class DynamicPricingService {
  /// Calculate service price based on vehicle type and service type
  /// Updated to work with Firestore price maps
  double calculateServicePrice(Service service, Car? vehicle) {
    if (vehicle == null) {
      // Default to sedan prices if no vehicle selected
      return _getServicePriceFromMap(service, CarType.sedan);
    }

    return _getServicePriceFromMap(service, vehicle.type);
  }

  /// Get price from service's price map based on car type
  double _getServicePriceFromMap(Service service, CarType carType) {
    // For now, return the service.price as fallback (backward compatibility)
    // In a real Firestore implementation, this would access a price map
    final multiplier = _getCarTypeMultiplier(carType);
    return service.price * multiplier;
  }

  /// Get car type multiplier for pricing
  double _getCarTypeMultiplier(CarType carType) {
    switch (carType) {
      case CarType.mini:
        return 0.8; // 20% discount
      case CarType.sedan:
        return 1.0; // Base price
      case CarType.suv:
        return 1.2; // 20% premium
    }
  }

  /// Get pricing information with breakdown
  PricingInfo getPricingInfo(Service service, Car? vehicle) {
    final finalPrice = calculateServicePrice(service, vehicle);

    return PricingInfo(
      basePrice: service.price, // Keep original for reference
      finalPrice: finalPrice,
      vehicleType: vehicle?.type,
    );
  }
}

/// Contains pricing breakdown information
class PricingInfo {
  final double basePrice;
  final double finalPrice;
  final CarType? vehicleType;

  const PricingInfo({
    required this.basePrice,
    required this.finalPrice,
    this.vehicleType,
  });
}
