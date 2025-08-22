import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:carsnan/core/errors/failures.dart';
import 'package:carsnan/features/car/domain/entities/car.dart';
import 'package:carsnan/features/car/domain/usecases/add_car_usecase.dart';
import 'package:carsnan/features/car/domain/usecases/delete_car_usecase.dart';
import 'package:carsnan/features/car/domain/usecases/get_cars_usecase.dart';
import 'package:carsnan/features/car/domain/usecases/set_default_car_usecase.dart';
import 'package:carsnan/features/car/domain/usecases/update_car_usecase.dart';
import 'package:carsnan/features/car/presentation/cubit/car_cubit.dart';
import 'package:carsnan/features/car/presentation/cubit/car_state.dart';

class MockGetCarsUseCase extends Mock implements GetCarsUseCase {}

class MockAddCarUseCase extends Mock implements AddCarUseCase {}

class MockUpdateCarUseCase extends Mock implements UpdateCarUseCase {}

class MockDeleteCarUseCase extends Mock implements DeleteCarUseCase {}

class MockSetDefaultCarUseCase extends Mock implements SetDefaultCarUseCase {}

void main() {
  late CarCubit carCubit;
  late MockGetCarsUseCase mockGetCarsUseCase;
  late MockAddCarUseCase mockAddCarUseCase;
  late MockUpdateCarUseCase mockUpdateCarUseCase;
  late MockDeleteCarUseCase mockDeleteCarUseCase;
  late MockSetDefaultCarUseCase mockSetDefaultCarUseCase;

  setUp(() {
    mockGetCarsUseCase = MockGetCarsUseCase();
    mockAddCarUseCase = MockAddCarUseCase();
    mockUpdateCarUseCase = MockUpdateCarUseCase();
    mockDeleteCarUseCase = MockDeleteCarUseCase();
    mockSetDefaultCarUseCase = MockSetDefaultCarUseCase();

    carCubit = CarCubit(
      mockGetCarsUseCase,
      mockAddCarUseCase,
      mockUpdateCarUseCase,
      mockDeleteCarUseCase,
      mockSetDefaultCarUseCase,
    );
  });

  tearDown(() {
    carCubit.close();
  });

  group('CarCubit', () {
    final testCars = [
      Car(
        id: '1',
        make: 'Toyota',
        model: 'Camry',
        year: 2022,
        color: 'Silver',
        licensePlate: 'ABC-1234',
        type: CarType.sedan,
        isDefault: true,
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 1),
      ),
      Car(
        id: '2',
        make: 'Honda',
        model: 'CR-V',
        year: 2021,
        color: 'Black',
        licensePlate: 'XYZ-5678',
        type: CarType.suv,
        isDefault: false,
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 1),
      ),
    ];

    test('initial state should be CarInitial', () {
      expect(carCubit.state, const CarInitial());
    });

    group('loadCars', () {
      blocTest<CarCubit, CarState>(
        'should emit [CarLoading, CarLoaded] when cars are loaded successfully',
        build: () {
          when(
            () => mockGetCarsUseCase(),
          ).thenAnswer((_) async => Right(testCars));
          return carCubit;
        },
        act: (cubit) => cubit.loadCars(),
        expect: () => [const CarLoading(), CarLoaded(cars: testCars)],
        verify: (_) {
          verify(() => mockGetCarsUseCase()).called(1);
        },
      );

      blocTest<CarCubit, CarState>(
        'should emit [CarLoading, CarError] when loading cars fails',
        build: () {
          when(() => mockGetCarsUseCase()).thenAnswer(
            (_) async => const Left(CacheFailure('Failed to load cars')),
          );
          return carCubit;
        },
        act: (cubit) => cubit.loadCars(),
        expect: () => [
          const CarLoading(),
          const CarError(message: 'Failed to load cars'),
        ],
      );
    });

    group('addCar', () {
      final newCar = Car(
        id: '3',
        make: 'BMW',
        model: 'X5',
        year: 2023,
        color: 'White',
        licensePlate: 'BMW-1234',
        type: CarType.suv,
        isDefault: false,
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 1),
      );

      blocTest<CarCubit, CarState>(
        'should emit [CarLoading, CarLoaded] when car is added successfully',
        build: () {
          when(
            () => mockAddCarUseCase(any()),
          ).thenAnswer((_) async => Right(newCar));
          when(
            () => mockGetCarsUseCase(),
          ).thenAnswer((_) async => Right([...testCars, newCar]));
          return carCubit;
        },
        act: (cubit) => cubit.addCar(newCar),
        expect: () => [
          const CarLoading(),
          CarLoaded(cars: [...testCars, newCar]),
        ],
      );

      blocTest<CarCubit, CarState>(
        'should emit [CarLoading, CarError] when adding car fails',
        build: () {
          when(() => mockAddCarUseCase(any())).thenAnswer(
            (_) async => const Left(CacheFailure('Failed to add car')),
          );
          return carCubit;
        },
        act: (cubit) => cubit.addCar(newCar),
        expect: () => [
          const CarLoading(),
          const CarError(message: 'Failed to add car'),
        ],
      );
    });

    group('deleteCar', () {
      blocTest<CarCubit, CarState>(
        'should emit [CarLoading, CarLoaded] when car is deleted successfully',
        build: () {
          when(
            () => mockDeleteCarUseCase(any()),
          ).thenAnswer((_) async => const Right(null));
          when(
            () => mockGetCarsUseCase(),
          ).thenAnswer((_) async => Right([testCars[1]]));
          return carCubit;
        },
        act: (cubit) => cubit.deleteCar('1'),
        expect: () => [
          const CarLoading(),
          CarLoaded(cars: [testCars[1]]),
        ],
      );
    });

    group('setDefaultCar', () {
      blocTest<CarCubit, CarState>(
        'should emit [CarLoaded] when default car is set successfully',
        build: () {
          when(
            () => mockSetDefaultCarUseCase(any()),
          ).thenAnswer((_) async => const Right(null));
          when(
            () => mockGetCarsUseCase(),
          ).thenAnswer((_) async => Right(testCars));
          return carCubit;
        },
        act: (cubit) => cubit.setDefaultCar('2'),
        expect: () => [CarLoaded(cars: testCars)],
      );
    });

    test('should return current cars from state', () {
      // arrange
      carCubit.emit(CarLoaded(cars: testCars));

      // act & assert
      expect(carCubit.cars, testCars);
    });

    // Remove defaultCar test since we removed that functionality
    test('should return cars from loaded state', () {
      // arrange
      carCubit.emit(CarLoaded(cars: testCars));

      // act & assert
      expect(carCubit.cars, testCars);
    });
  });

  // Register fallback values for mocktail
  setUpAll(() {
    registerFallbackValue(
      Car(
        id: 'test',
        make: 'Test',
        model: 'Test',
        year: 2020,
        color: 'Test',
        licensePlate: 'TEST-1234',
        type: CarType.sedan,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  });
}
