import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/vehicle_selection_service.dart';
import '../../domain/entities/car.dart';
import '../cubit/car_cubit.dart';
import '../cubit/car_state.dart';

class AddCarButton extends StatelessWidget {
  const AddCarButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CarCubit>()..loadCars(),
      child: BlocBuilder<CarCubit, CarState>(
        builder: (context, state) {
          if (state is CarLoaded && state.cars.isNotEmpty) {
            // Initialize vehicle selection service with available cars
            final vehicleService = getIt<VehicleSelectionService>();
            vehicleService.initializeWithDefault(state.cars);
            
            // Show live selected vehicle or first available car
            return StreamBuilder<Car?>(
              stream: vehicleService.selectedVehicleStream,
              initialData: vehicleService.selectedVehicle,
              builder: (context, snapshot) {
                final selectedCar = snapshot.data ?? state.cars.first;
                return _LiveVehicleDisplay(car: selectedCar);
              },
            );
          }

          // If no cars, show add car button
          return _AddCarButtonWidget();
        },
      ),
    );
  }
}

class _LiveVehicleDisplay extends StatelessWidget {
  const _LiveVehicleDisplay({required this.car});

  final Car car;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/cars'),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: double.infinity, // Fill the parent container height
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(car.type.icon, style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    car.nickname ?? car.make,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    car.model,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 10,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class _AddCarButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/cars'),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: double.infinity, // Fill the parent container height
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.directions_car,
                color: Theme.of(context).primaryColor,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Add Vehicle',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'Add car for service',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.add_circle_outline,
              color: Theme.of(context).primaryColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
