import 'package:injectable/injectable.dart';
import '../../features/car/domain/entities/car.dart';
import '../../features/dashboard/domain/entities/service.dart';

/// Service to handle dynamic pricing based on vehicle type
@injectable
class DynamicPricingService {
  
  /// Calculate service price based on vehicle type and service type
  double calculateServicePrice(Service service, Car? vehicle) {
    if (vehicle == null) {
      // Default to sedan prices if no vehicle selected
      return _getServicePrice(service.type, CarType.sedan);
    }
    
    return _getServicePrice(service.type, vehicle.type);
  }

  /// Get specific price based on service type and car type
  double _getServicePrice(ServiceType serviceType, CarType carType) {
    switch (carType) {
      case CarType.mini:
        switch (serviceType) {
          case ServiceType.general:
            return 100.0;
          case ServiceType.premium:
            return 150.0;
          case ServiceType.luxury:
            return 200.0;
        }
      case CarType.sedan:
        switch (serviceType) {
          case ServiceType.general:
            return 120.0;
          case ServiceType.premium:
            return 170.0;
          case ServiceType.luxury:
            return 220.0;
        }
      case CarType.suv:
        switch (serviceType) {
          case ServiceType.general:
            return 140.0;
          case ServiceType.premium:
            return 190.0;
          case ServiceType.luxury:
            return 240.0;
        }
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
