import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../address/presentation/widgets/address_selector_widget.dart';
import '../../../car/presentation/widgets/add_car_button.dart';

class TopActionBar extends StatelessWidget {
  final VoidCallback onAddVehicle;
  final VoidCallback onAddAddress;

  const TopActionBar({
    super.key,
    required this.onAddVehicle,
    required this.onAddAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.mediumPadding),
      child: Row(
        children: [
          // Address selector - takes up slightly more space
          Expanded(
            flex: 3,
            child: Container(
              height: 88, // Increased height to accommodate content better
              child: AddressSelector(),
            ),
          ),
          const SizedBox(width: 12),
          // Vehicle selector - takes up slightly less space
          Expanded(
            flex: 2,
            child: Container(
              height: 88, // Increased height to accommodate content better
              child: AddCarButton(),
            ),
          ),
        ],
      ),
    );
  }
}
