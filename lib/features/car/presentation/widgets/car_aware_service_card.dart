import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/vehicle_selection_service.dart';
import '../../../../core/services/dynamic_pricing_service.dart';
import '../../../dashboard/domain/entities/service.dart';
import '../../domain/entities/car.dart';

class CarAwareServiceCard extends StatelessWidget {
  const CarAwareServiceCard({
    super.key,
    required this.service,
    required this.onTap,
  });

  final Service service;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Car?>(
      stream: getIt<VehicleSelectionService>().selectedVehicleStream,
      initialData: getIt<VehicleSelectionService>().selectedVehicle,
      builder: (context, snapshot) {
        final selectedCar = snapshot.data;
        final pricingService = getIt<DynamicPricingService>();
        final pricingInfo = pricingService.getPricingInfo(service, selectedCar);
        
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Service image
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          _getServiceColor(service.type).withValues(alpha: 0.8),
                          _getServiceColor(service.type).withValues(alpha: 0.6),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        _getServiceIcon(service.type),
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Service details
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Service title
                        Text(
                          service.title,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),

                        // Service description
                        Text(
                          service.description,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey[600]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const Spacer(),

                        // Price with car type consideration
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Car type indicator (if available)
                            if (selectedCar != null) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).primaryColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      selectedCar.type.icon,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      selectedCar.type.displayName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(
                                              context,
                                            ).primaryColor,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            // Price
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFFFD700), // Gold
                                    Color(0xFFD4AF37), // Darker Gold
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '\$${pricingInfo.finalPrice.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getServiceColor(ServiceType type) {
    switch (type) {
      case ServiceType.general:
        return const Color(0xFF4CAF50); // Green
      case ServiceType.premium:
        return const Color(0xFF2196F3); // Blue
      case ServiceType.luxury:
        return const Color(0xFFD4AF37); // Gold
    }
  }

  IconData _getServiceIcon(ServiceType type) {
    switch (type) {
      case ServiceType.general:
        return Icons.local_car_wash;
      case ServiceType.premium:
        return Icons.car_repair;
      case ServiceType.luxury:
        return Icons.diamond;
    }
  }
}
