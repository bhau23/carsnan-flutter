import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../cubit/car_cubit.dart';
import '../cubit/car_state.dart';
import '../widgets/car_card.dart';
import '../widgets/empty_cars_widget.dart';

class CarListPage extends StatelessWidget {
  const CarListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CarCubit>()..loadCars(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Cars'),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
        ),
        body: BlocConsumer<CarCubit, CarState>(
          listener: (context, state) {
            if (state is CarError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is CarLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CarLoaded) {
              if (state.cars.isEmpty) {
                return const EmptyCarsWidget();
              }

              return RefreshIndicator(
                onRefresh: () => context.read<CarCubit>().loadCars(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.cars.length,
                  itemBuilder: (context, index) {
                    final car = state.cars[index];
                    return CarCard(
                      car: car,
                      onTap: () => _navigateToEditCar(context, car.id),
                      onDelete: () => _showDeleteDialog(context, car),
                      onSetDefault: () =>
                          context.read<CarCubit>().setDefaultCar(car.id),
                    );
                  },
                ),
              );
            }

            return const Center(
              child: Text('Something went wrong. Please try again.'),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _navigateToAddCar(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _navigateToAddCar(BuildContext context) {
    context.push('/cars/add').then((_) {
      // Refresh the list when returning from add car page
      if (context.mounted) {
        context.read<CarCubit>().loadCars();
      }
    });
  }

  void _navigateToEditCar(BuildContext context, String carId) {
    context.push('/cars/edit/$carId').then((_) {
      // Refresh the list when returning from edit car page
      if (context.mounted) {
        context.read<CarCubit>().loadCars();
      }
    });
  }

  void _showDeleteDialog(BuildContext context, car) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Car'),
        content: Text('Are you sure you want to delete ${car.displayName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<CarCubit>().deleteCar(car.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
