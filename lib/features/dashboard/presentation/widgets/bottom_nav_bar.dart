import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: AppConstants.homeLabel,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag),
          label: AppConstants.ordersLabel,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: AppConstants.profileLabel,
        ),
      ],
    );
  }
}
