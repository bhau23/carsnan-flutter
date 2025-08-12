import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/car.dart';
import '../cubit/car_cubit.dart';
import '../cubit/car_state.dart';
import '../widgets/car_form.dart';

class EditCarPage extends StatefulWidget {
  const EditCarPage({super.key, required this.carId});

  final String carId;

  @override
  State<EditCarPage> createState() => _EditCarPageState();
}

class _EditCarPageState extends State<EditCarPage> {
  Car? _car;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _loadCarData();
  }

  void _loadCarData() {
    final carCubit = context.read<CarCubit>();
    carCubit.loadCars().then((_) {
      if (mounted) {
        final cars = carCubit.cars;
        final car = cars.where((c) => c.id == widget.carId).firstOrNull;
        if (car != null) {
          setState(() {
            _car = car;
          });
        } else {
          // Car not found, go back
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Car not found'),
              backgroundColor: Colors.red,
            ),
          );
          context.pop();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Car'),
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
          } else if (state is CarLoaded && _isUpdating) {
            // Car updated successfully
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Car updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            context.pop(); // Go back to car list
          }
        },
        builder: (context, state) {
          if (_car == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final isLoading = state is CarLoading;

          return CarForm(
            car: _car,
            onSubmit: (car) => _updateCar(context, car),
            isLoading: isLoading,
            submitButtonText: 'Update Car',
          );
        },
      ),
    );
  }

  void _updateCar(BuildContext context, Car car) {
    setState(() {
      _isUpdating = true;
    });
    context.read<CarCubit>().updateCar(car);
  }
}
