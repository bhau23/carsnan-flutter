import 'package:equatable/equatable.dart';

import '../../domain/entities/car.dart';

abstract class CarState extends Equatable {
  const CarState();

  @override
  List<Object?> get props => [];
}

class CarInitial extends CarState {
  const CarInitial();
}

class CarLoading extends CarState {
  const CarLoading();
}

class CarLoaded extends CarState {
  const CarLoaded({required this.cars});

  final List<Car> cars;

  @override
  List<Object?> get props => [cars];
}

class CarError extends CarState {
  const CarError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
