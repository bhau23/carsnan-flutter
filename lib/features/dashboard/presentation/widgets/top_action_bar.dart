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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Address selector
          Expanded(
            child: AddressSelector(),
          ),
          const SizedBox(width: AppSizes.mediumPadding),
          // Vehicle selector  
          Expanded(
            child: AddCarButton(),
          ),
        ],
      ),
    );
  }
}
