import 'package:injectable/injectable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/car.dart';
import '../models/car_model.dart';
import 'car_local_data_source.dart';

@Injectable(as: CarLocalDataSource)
class CarLocalDataSourceImpl implements CarLocalDataSource {
  CarLocalDataSourceImpl();

  // In-memory storage for demo purposes
  static final List<CarModel> _cars = [
    // Demo data - Sedan
    CarModel(
      id: '1',
      make: 'Toyota',
      model: 'Camry',
      year: 2022,
      color: 'Silver',
      licensePlate: 'ABC-1234',
      nickname: 'My Camry',
      type: CarType.sedan,
      isDefault: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),

    // Demo data - SUV
    CarModel(
      id: '2',
      make: 'Honda',
      model: 'CR-V',
      year: 2021,
      color: 'Black',
      licensePlate: 'XYZ-5678',
      nickname: null,
      type: CarType.suv,
      isDefault: false,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now().subtract(const Duration(days: 10)),
    ),

    // Demo data - Mini
    CarModel(
      id: '3',
      make: 'Mini',
      model: 'Cooper',
      year: 2023,
      color: 'Red',
      licensePlate: 'MNI-9999',
      nickname: 'Little Red',
      type: CarType.mini,
      isDefault: false,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  @override
  Future<List<CarModel>> getCars() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_cars);
  }

  @override
  Future<CarModel> addCar(CarModel car) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Generate a new ID
    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    final newCar = car.copyWith(
      id: newId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _cars.add(newCar);
    return newCar;
  }

  @override
  Future<CarModel> updateCar(CarModel car) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _cars.indexWhere((c) => c.id == car.id);
    if (index == -1) {
      throw Exception('Car not found');
    }

    final updatedCar = car.copyWith(updatedAt: DateTime.now());
    _cars[index] = updatedCar;
    return updatedCar;
  }

  @override
  Future<void> deleteCar(String carId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _cars.indexWhere((c) => c.id == carId);
    if (index == -1) {
      throw Exception('Car not found');
    }

    _cars.removeAt(index);
  }

  @override
  Future<void> setDefaultCar(String carId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // First, unset all default cars
    for (int i = 0; i < _cars.length; i++) {
      _cars[i] = _cars[i].copyWith(isDefault: false);
    }

    // Then set the specified car as default
    final index = _cars.indexWhere((c) => c.id == carId);
    if (index == -1) {
      throw Exception('Car not found');
    }

    _cars[index] = _cars[index].copyWith(
      isDefault: true,
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<CarModel?> getDefaultCar() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      return _cars.firstWhere((car) => car.isDefault);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<CarModel?> getCarById(String carId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      return _cars.firstWhere((car) => car.id == carId);
    } catch (e) {
      return null;
    }
  }
}

@Injectable(as: CarFirestoreDataSource)
class CarFirestoreDataSourceImpl implements CarFirestoreDataSource {
  final FirebaseFirestore _firestore;

  CarFirestoreDataSourceImpl(this._firestore);

  CollectionReference _getCarsCollection(String userId) {
    return _firestore.collection('users').doc(userId).collection('cars');
  }

  @override
  Future<List<CarModel>> getCars(String userId) async {
    try {
      final querySnapshot = await _getCarsCollection(userId).get();
      return querySnapshot.docs
          .map(
            (doc) => CarModel.fromFirestore(
              doc.id,
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get cars: $e');
    }
  }

  @override
  Future<CarModel> addCar(String userId, CarModel car) async {
    try {
      final docRef = await _getCarsCollection(userId).add(car.toFirestore());
      return car.copyWith(id: docRef.id);
    } catch (e) {
      throw Exception('Failed to add car: $e');
    }
  }

  @override
  Future<CarModel> updateCar(String userId, CarModel car) async {
    try {
      await _getCarsCollection(userId)
          .doc(car.id)
          .update(car.copyWith(updatedAt: DateTime.now()).toFirestore());
      return car.copyWith(updatedAt: DateTime.now());
    } catch (e) {
      throw Exception('Failed to update car: $e');
    }
  }

  @override
  Future<void> deleteCar(String userId, String carId) async {
    try {
      await _getCarsCollection(userId).doc(carId).delete();
    } catch (e) {
      throw Exception('Failed to delete car: $e');
    }
  }

  @override
  Future<void> setDefaultCar(String userId, String carId) async {
    try {
      final batch = _firestore.batch();
      final carsCollection = _getCarsCollection(userId);

      // First, get all cars to unset defaults
      final querySnapshot = await carsCollection.get();

      for (final doc in querySnapshot.docs) {
        batch.update(doc.reference, {
          'isDefault': doc.id == carId,
          'updatedAt': Timestamp.fromDate(DateTime.now()),
        });
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to set default car: $e');
    }
  }

  @override
  Future<CarModel?> getDefaultCar(String userId) async {
    try {
      final querySnapshot = await _getCarsCollection(
        userId,
      ).where('isDefault', isEqualTo: true).limit(1).get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      final doc = querySnapshot.docs.first;
      return CarModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to get default car: $e');
    }
  }

  @override
  Future<CarModel?> getCarById(String userId, String carId) async {
    try {
      final doc = await _getCarsCollection(userId).doc(carId).get();

      if (!doc.exists) {
        return null;
      }

      return CarModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to get car by ID: $e');
    }
  }
}
