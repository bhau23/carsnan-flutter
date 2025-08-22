import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/dynamic_pricing_service.dart';
import '../../../../core/services/vehicle_selection_service.dart';
import '../../domain/entities/service.dart';
import '../../../car/domain/entities/car.dart';

class ServiceCard extends StatelessWidget {
  final Service service;
  final VoidCallback onTap;

  const ServiceCard({super.key, required this.service, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Car?>(
      stream: getIt<VehicleSelectionService>().selectedVehicleStream,
      initialData: getIt<VehicleSelectionService>().selectedVehicle,
      builder: (context, snapshot) {
        final selectedCar = snapshot.data;
        final pricingService = getIt<DynamicPricingService>();
        final pricingInfo = pricingService.getPricingInfo(service, selectedCar);
        
        return _buildServiceCard(context, pricingInfo);
      },
    );
  }

  Widget _buildServiceCard(BuildContext context, PricingInfo pricingInfo) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Large Service Image (Edge to Edge)
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  _buildServiceImage(),
                  // Subtle gradient overlay for better text readability
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.1),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Price Tag in Bottom Right Corner
                  Positioned(bottom: 8, right: 8, child: _buildPriceTag(pricingInfo)),
                ],
              ),
            ),

            // Text Content at Bottom
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.surface.withValues(alpha: 0.9),
                    theme.colorScheme.surface,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Service Name
                  Text(
                    service.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Service Description
                  Text(
                    service.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Service Type and Duration
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getServiceColor(service.type).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          service.type.name.toUpperCase(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: _getServiceColor(service.type),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${service.estimatedDurationInMinutes}m',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceImage() {
    // Get the correct image path based on service type
    String imagePath;
    switch (service.type) {
      case ServiceType.general:
        imagePath = 'assets/images/services/general_wash.png';
        break;
      case ServiceType.premium:
        imagePath = 'assets/images/services/premium_wash.png';
        break;
      case ServiceType.luxury:
        imagePath = 'assets/images/services/luxury_wash.png';
        break;
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.3),
            ],
          ),
        ),
      ),
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

  Widget _buildPriceTag(PricingInfo pricingInfo) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFFFD700).withValues(alpha: 0.8),
          width: 1,
        ),
      ),
      child: Text(
        '\$${pricingInfo.finalPrice.toStringAsFixed(0)}',
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
