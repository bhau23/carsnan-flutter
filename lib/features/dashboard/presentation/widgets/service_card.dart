import 'package:flutter/material.dart';
import '../../domain/entities/service.dart';

class ServiceCard extends StatelessWidget {
  final Service service;
  final VoidCallback onTap;

  const ServiceCard({
    super.key,
    required this.service,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
                            Colors.black.withOpacity(0.1),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Price Tag in Bottom Right Corner
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: _buildPriceTag(),
                  ),
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
                    theme.colorScheme.surface.withOpacity(0.9),
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
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 11,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
    return Image.asset(
      service.iconPath,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to gradient background with icon if image is not found
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _getServiceColor(service.type).withOpacity(0.8),
                _getServiceColor(service.type).withOpacity(0.6),
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

  Widget _buildPriceTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFD700), // Gold
            Color(0xFFD4AF37), // Darker Gold
            Color(0xFFB8860B), // Dark Gold
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFFFD700).withOpacity(0.8),
          width: 1,
        ),
      ),
      child: Text(
        '\$${service.price.toStringAsFixed(0)}',
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
