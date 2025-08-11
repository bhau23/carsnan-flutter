import 'package:flutter/material.dart';
import '../../domain/entities/service.dart';

class ServiceItemCard extends StatelessWidget {
  final ServiceItem serviceItem;
  final ServiceType serviceType;

  const ServiceItemCard({
    super.key,
    required this.serviceItem,
    required this.serviceType,
  });

  // Centralized mapping of service item names to their shared images
  static String _getSharedItemImagePath(String itemName) {
    final name = itemName.toLowerCase();
    
    if (name.contains('foam') && name.contains('wash')) {
      return 'assets/images/service_items/shared/foam_wash.jpg';
    } else if (name.contains('exterior') && name.contains('wash')) {
      return 'assets/images/service_items/shared/exterior_wash.jpg';
    } else if (name.contains('interior') && (name.contains('vacuum') || name.contains('clean'))) {
      return 'assets/images/service_items/shared/interior_vacuum.jpg';
    } else if (name.contains('interior') && name.contains('detail')) {
      return 'assets/images/service_items/shared/interior_detail.jpg';
    } else if (name.contains('engine') && (name.contains('clean') || name.contains('detail'))) {
      return 'assets/images/service_items/shared/engine_clean.jpg';
    } else if (name.contains('wax') && name.contains('polish')) {
      return 'assets/images/service_items/shared/wax_polish.jpg';
    } else if (name.contains('oil') && name.contains('change')) {
      return 'assets/images/service_items/shared/oil_change.jpg';
    } else if (name.contains('tire') || name.contains('tyre')) {
      if (name.contains('polish')) {
        return 'assets/images/service_items/shared/tire_polish.jpg';
      } else {
        return 'assets/images/service_items/shared/tire_check.jpg';
      }
    } else if (name.contains('full') && name.contains('detail')) {
      return 'assets/images/service_items/shared/full_detailing.jpg';
    } else if (name.contains('paint') && name.contains('protection')) {
      return 'assets/images/service_items/shared/paint_protection.jpg';
    } else if (name.contains('leather') && name.contains('care')) {
      return 'assets/images/service_items/shared/leather_care.jpg';
    } else if (name.contains('premium') && name.contains('wax')) {
      return 'assets/images/service_items/shared/premium_wax.jpg';
    } else if (name.contains('basic') && name.contains('inspection')) {
      return 'assets/images/service_items/shared/basic_inspection.jpg';
    } else {
      // Default fallback image
      return 'assets/images/service_items/shared/default_service.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sharedImagePath = _getSharedItemImagePath(serviceItem.name);
    
    return Container(
      width: 90,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getServiceColor(serviceType).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Service item image
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.asset(
                  sharedImagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            _getServiceColor(serviceType).withOpacity(0.3),
                            _getServiceColor(serviceType).withOpacity(0.1),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          _getItemIcon(serviceItem.name),
                          size: 24,
                          color: _getServiceColor(serviceType),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          
          // Service item name
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              child: Text(
                serviceItem.name,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
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

  IconData _getItemIcon(String itemName) {
    final name = itemName.toLowerCase();
    
    if (name.contains('vacuum')) {
      return Icons.cleaning_services;
    } else if (name.contains('wash') || name.contains('foam')) {
      return Icons.local_car_wash;
    } else if (name.contains('tire') || name.contains('tyre')) {
      return Icons.tire_repair;
    } else if (name.contains('wax')) {
      return Icons.auto_fix_high;
    } else if (name.contains('interior')) {
      return Icons.airline_seat_recline_normal;
    } else if (name.contains('exterior')) {
      return Icons.directions_car;
    } else if (name.contains('engine')) {
      return Icons.precision_manufacturing;
    } else if (name.contains('polish')) {
      return Icons.auto_awesome;
    } else {
      return Icons.build;
    }
  }
}
