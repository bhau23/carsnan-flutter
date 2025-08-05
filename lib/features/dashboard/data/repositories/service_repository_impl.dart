import '../../domain/entities/service.dart';
import '../datasources/service_local_datasource.dart';
import '../../domain/repositories/service_repository.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceLocalDataSource localDataSource;

  ServiceRepositoryImpl(this.localDataSource);

  @override
  Future<List<Service>> getServices() async {
    return await localDataSource.getServices();
  }

  @override
  Future<Service> getServiceById(String id) async {
    return await localDataSource.getServiceById(id);
  }
}
