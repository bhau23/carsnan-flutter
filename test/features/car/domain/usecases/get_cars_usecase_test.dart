import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:carsnan/features/car/domain/entities/car.dart';
import 'package:carsnan/features/car/domain/repositories/car_repository.dart';
import 'package:carsnan/features/car/domain/usecases/get_cars_usecase.dart';

class MockCarRepository extends Mock implements CarRepository {}

void main() {
  late GetCarsUseCase useCase;
  late MockCarRepository mockRepository;

  setUp(() {
    mockRepository = MockCarRepository();
    useCase = GetCarsUseCase(mockRepository);
  });

  group('GetCarsUseCase', () {
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

    test('should get cars from repository', () async {
      // arrange
      when(
        () => mockRepository.getCars(),
      ).thenAnswer((_) async => Right(testCars));

      // act
      final result = await useCase();

      // assert
      expect(result, Right(testCars));
      verify(() => mockRepository.getCars()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
