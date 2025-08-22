import 'package:injectable/injectable.dart';

import '../entities/service.dart';
import '../repositories/service_repository.dart';

@injectable
class GetServicesUseCase {
  final ServiceRepository repository;

  GetServicesUseCase(this.repository);

  Future<List<Service>> call() async {
    return await repository.getServices();
  }
}
