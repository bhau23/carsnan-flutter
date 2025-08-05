import '../../domain/entities/service.dart';

abstract class ServiceLocalDataSource {
  Future<List<Service>> getServices();
  Future<Service> getServiceById(String id);
}

class ServiceLocalDataSourceImpl implements ServiceLocalDataSource {
  @override
  Future<List<Service>> getServices() async {
    // Mock data for now - replace with actual local storage implementation
    return [
      const Service(
        id: '1',
        title: 'General Wash',
        description: 'Complete exterior and interior cleaning',
        iconPath: 'assets/images/services/general_wash.png',
        type: ServiceType.general,
        price: 29.99,
        features: [
          'Exterior wash',
          'Interior vacuum',
          'Basic check-up',
          'Tire pressure check',
        ],
      ),
      const Service(
        id: '2',
        title: 'Premium Wash',
        description: 'Enhanced service with detailed cleaning',
        iconPath: 'assets/images/services/premium_wash.png',
        type: ServiceType.premium,
        price: 59.99,
        features: [
          'Complete wash & wax',
          'Interior detailing',
          'Engine bay cleaning',
          'Comprehensive inspection',
          'Oil change',
        ],
      ),
      const Service(
        id: '3',
        title: 'Luxury Wash',
        description: 'Premium luxury car service experience',
        iconPath: 'assets/images/services/luxury_wash.png',
        type: ServiceType.luxury,
        price: 129.99,
        features: [
          'Full detailing service',
          'Paint protection',
          'Interior conditioning',
          'Complete maintenance',
          'Pick-up & delivery',
          'Premium care products',
        ],
      ),
    ];
  }

  @override
  Future<Service> getServiceById(String id) async {
    final services = await getServices();
    return services.firstWhere((service) => service.id == id);
  }
}
