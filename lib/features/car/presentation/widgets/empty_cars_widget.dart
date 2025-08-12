import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmptyCarsWidget extends StatelessWidget {
  const EmptyCarsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Car icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.directions_car_outlined,
                size: 64,
                color: Theme.of(context).primaryColor,
              ),
            ),

            const SizedBox(height: 24),

            // Title
            Text(
              'No Cars Added Yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),

            const SizedBox(height: 8),

            // Description
            Text(
              'Add your first car to get started with our car washing services.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),

            const SizedBox(height: 32),

            // Add car button
            ElevatedButton.icon(
              onPressed: () => context.push('/cars/add'),
              icon: const Icon(Icons.add),
              label: const Text('Add Your First Car'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Benefits list
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Why add your car?',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildBenefitItem(
                    context,
                    Icons.speed,
                    'Faster service booking',
                  ),
                  _buildBenefitItem(
                    context,
                    Icons.attach_money,
                    'Accurate pricing based on car type',
                  ),
                  _buildBenefitItem(
                    context,
                    Icons.history,
                    'Track service history',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Theme.of(context).primaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}
