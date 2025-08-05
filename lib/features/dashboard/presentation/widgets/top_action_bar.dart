import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class TopActionBar extends StatelessWidget {
  final VoidCallback onAddAddress;
  final VoidCallback onAddVehicle;

  const TopActionBar({
    super.key,
    required this.onAddAddress,
    required this.onAddVehicle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(AppSizes.mediumPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildActionButton(
            context: context,
            icon: Icons.location_on,
            label: AppConstants.addAddressLabel,
            onTap: onAddAddress,
            theme: theme,
          ),
          _buildActionButton(
            context: context,
            icon: Icons.directions_car,
            label: AppConstants.addVehicleLabel,
            onTap: onAddVehicle,
            theme: theme,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.mediumRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.mediumPadding,
          vertical: AppSizes.mediumRadius,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppSizes.mediumRadius),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: AppSizes.mediumIcon - 4,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: AppSizes.smallPadding),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
