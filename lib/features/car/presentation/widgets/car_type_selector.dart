import 'package:flutter/material.dart';

import '../../domain/entities/car.dart';

class CarTypeSelector extends StatelessWidget {
  const CarTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  final CarType selectedType;
  final Function(CarType) onTypeSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Car Type *',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Select your car type for accurate pricing',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),
        Row(
          children: CarType.values.map((type) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: type == CarType.values.last ? 0 : 8,
                ),
                child: _CarTypeCard(
                  type: type,
                  isSelected: selectedType == type,
                  onTap: () => onTypeSelected(type),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _CarTypeCard extends StatelessWidget {
  const _CarTypeCard({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  final CarType type;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.1)
              : Colors.grey[50],
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Car type icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary.withValues(alpha: 0.2)
                    : Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Text(type.icon, style: const TextStyle(fontSize: 32)),
            ),

            const SizedBox(height: 8),

            // Car type name
            Text(
              type.displayName,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? colorScheme.primary : null,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 4),

            // Price multiplier
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getPriceColor(type.priceMultiplier),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _getPriceText(type.priceMultiplier),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 4),

            // Description
            Text(
              type.description,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriceColor(double multiplier) {
    if (multiplier > 1.0) {
      return Colors.orange;
    } else if (multiplier < 1.0) {
      return Colors.green;
    } else {
      return Colors.blue;
    }
  }

  String _getPriceText(double multiplier) {
    if (multiplier > 1.0) {
      final percentage = ((multiplier - 1.0) * 100).round();
      return '+$percentage%';
    } else if (multiplier < 1.0) {
      final percentage = ((1.0 - multiplier) * 100).round();
      return '-$percentage%';
    } else {
      return 'Base';
    }
  }
}
