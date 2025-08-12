import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/car.dart';
import '../cubit/car_cubit.dart';
import '../cubit/car_state.dart';
import '../widgets/car_form.dart';

class AddCarPage extends StatelessWidget {
  const AddCarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CarCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add New Car'),
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
            } else if (state is CarLoaded) {
              // Car added successfully
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Car added successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              context.pop(); // Go back to car list
            }
          },
          builder: (context, state) {
            final isLoading = state is CarLoading;

            return CarForm(
              onSubmit: (car) => _addCar(context, car),
              isLoading: isLoading,
              submitButtonText: 'Add Car',
            );
          },
        ),
      ),
    );
  }

  void _addCar(BuildContext context, Car car) {
    context.read<CarCubit>().addCar(car);
  }
}
