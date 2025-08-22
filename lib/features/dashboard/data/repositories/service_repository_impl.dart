import 'package:injectable/injectable.dart';
import '../../domain/entities/service.dart';
import '../datasources/service_local_datasource.dart';
import '../../domain/repositories/service_repository.dart';

@Injectable(as: ServiceRepository)
class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceFirestoreDataSource firestoreDataSource;
  final ServiceLocalDataSource localDataSource;

  ServiceRepositoryImpl(this.firestoreDataSource, this.localDataSource);

  @override
  Future<List<Service>> getServices() async {
    try {
      // Try to fetch from Firestore first
      return await firestoreDataSource.getServices();
    } catch (e) {
      // Fall back to local data source if Firestore fails
      return await localDataSource.getServices();
    }
  }

  @override
  Future<Service> getServiceById(String id) async {
    try {
      // Try to fetch from Firestore first
      return await firestoreDataSource.getServiceById(id);
    } catch (e) {
      // Fall back to local data source if Firestore fails
      return await localDataSource.getServiceById(id);
    }
  }
}
