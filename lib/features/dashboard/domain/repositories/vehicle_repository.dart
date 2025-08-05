import '../entities/vehicle.dart';

abstract class VehicleRepository {
  Future<List<Vehicle>> getVehicles();
  Future<Vehicle> addVehicle(Vehicle vehicle);
  Future<void> deleteVehicle(String id);
  Future<Vehicle> updateVehicle(Vehicle vehicle);
}
