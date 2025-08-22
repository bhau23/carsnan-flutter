import 'package:injectable/injectable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/service.dart';

abstract class ServiceLocalDataSource {
  Future<List<Service>> getServices();
  Future<Service> getServiceById(String id);
}

/// Abstract data source for service data from Firestore
abstract class ServiceFirestoreDataSource {
  /// Get all services from Firestore
  Future<List<Service>> getServices();

  /// Get a specific service by ID from Firestore
  Future<Service> getServiceById(String id);
}

@Injectable(as: ServiceLocalDataSource)
class ServiceLocalDataSourceImpl implements ServiceLocalDataSource {
  @override
  Future<List<Service>> getServices() async {
    // Mock data for now - replace with actual local storage implementation
    return [
      Service.legacy(
        id: '1',
        title: 'General Wash',
        description:
            'Complete exterior and interior cleaning with basic maintenance checks',
        iconPath: 'assets/images/services/general_wash.png',
        bannerImagePath: 'assets/images/services/general_wash_banner.jpg',
        type: ServiceType.general,
        price: 29.99,
        estimatedDurationInMinutes: 45,
        highlightFeature: 'Eco-Friendly Products',
        features: [
          'Exterior wash',
          'Interior vacuum',
          'Basic check-up',
          'Tire pressure check',
        ],
        includedItems: [
          const ServiceItem(
            id: '1_1',
            name: 'Exterior Wash',
            imagePath:
                'assets/images/service_items/exterior_rinse.jpg', // Fixed: Use existing asset
            description: 'Complete exterior cleaning',
          ),
          const ServiceItem(
            id: '1_2',
            name: 'Interior Vacuum',
            imagePath: 'assets/images/service_items/interior_vacuum.jpg',
            description: 'Thorough interior cleaning',
          ),
          const ServiceItem(
            id: '1_3',
            name: 'Tire Check',
            imagePath:
                'assets/images/service_items/tire_cleaning.jpg', // Fixed: Use existing asset
            description: 'Tire pressure and condition check',
          ),
          const ServiceItem(
            id: '1_4',
            name: 'Basic Inspection',
            imagePath:
                'assets/images/service_items/engine_cleaning.jpg', // Fixed: Use existing asset
            description: 'General vehicle inspection',
          ),
        ],
      ),
      Service.legacy(
        id: '2',
        title: 'Premium Wash',
        description:
            'Enhanced service with detailed cleaning and comprehensive maintenance',
        iconPath: 'assets/images/services/premium_wash.png',
        bannerImagePath: 'assets/images/services/premium_wash_banner.jpg',
        type: ServiceType.premium,
        price: 59.99,
        estimatedDurationInMinutes: 75,
        highlightFeature: 'High Pressure Foam Wash',
        features: [
          'Complete wash & wax',
          'Interior detailing',
          'Engine bay cleaning',
          'Comprehensive inspection',
          'Oil change',
        ],
        includedItems: [
          const ServiceItem(
            id: '2_1',
            name: 'Foam Wash',
            imagePath: 'assets/images/service_items/foam_wash.jpg',
            description: 'High pressure foam cleaning',
          ),
          const ServiceItem(
            id: '2_2',
            name: 'Interior Detail',
            imagePath: 'assets/images/service_items/interior_detail.jpg',
            description: 'Complete interior detailing',
          ),
          const ServiceItem(
            id: '2_3',
            name: 'Engine Clean',
            imagePath: 'assets/images/service_items/engine_clean.jpg',
            description: 'Engine bay cleaning service',
          ),
          const ServiceItem(
            id: '2_4',
            name: 'Wax Polish',
            imagePath: 'assets/images/service_items/wax_polish.jpg',
            description: 'Premium wax and polish',
          ),
          const ServiceItem(
            id: '2_5',
            name: 'Oil Change',
            imagePath: 'assets/images/service_items/oil_change.jpg',
            description: 'Complete oil change service',
          ),
        ],
      ),
      Service.legacy(
        id: '3',
        title: 'Luxury Wash',
        description:
            'Premium luxury car service experience with complete detailing and maintenance',
        iconPath: 'assets/images/services/luxury_wash.png',
        bannerImagePath: 'assets/images/services/luxury_wash_banner.jpg',
        type: ServiceType.luxury,
        price: 129.99,
        estimatedDurationInMinutes: 120,
        highlightFeature: 'Paint Protection & Conditioning',
        features: [
          'Full detailing service',
          'Paint protection',
          'Interior conditioning',
          'Complete maintenance',
          'Pick-up & delivery',
          'Premium care products',
        ],
        includedItems: [
          const ServiceItem(
            id: '3_1',
            name: 'Full Detailing',
            imagePath: 'assets/images/service_items/full_detailing.jpg',
            description: 'Complete vehicle detailing',
          ),
          const ServiceItem(
            id: '3_2',
            name: 'Paint Protection',
            imagePath: 'assets/images/service_items/paint_protection.jpg',
            description: 'Premium paint protection coating',
          ),
          const ServiceItem(
            id: '3_3',
            name: 'Leather Care',
            imagePath: 'assets/images/service_items/leather_care.jpg',
            description: 'Interior leather conditioning',
          ),
          const ServiceItem(
            id: '3_4',
            name: 'Premium Wax',
            imagePath: 'assets/images/service_items/premium_wax.jpg',
            description: 'Luxury car wax application',
          ),
          const ServiceItem(
            id: '3_5',
            name: 'Engine Detail',
            imagePath: 'assets/images/service_items/engine_detail.jpg',
            description: 'Complete engine detailing',
          ),
          const ServiceItem(
            id: '3_6',
            name: 'Tire Polish',
            imagePath: 'assets/images/service_items/tire_polish.jpg',
            description: 'Premium tire care and polish',
          ),
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

@Injectable(as: ServiceFirestoreDataSource)
class ServiceFirestoreDataSourceImpl implements ServiceFirestoreDataSource {
  final FirebaseFirestore _firestore;

  ServiceFirestoreDataSourceImpl(this._firestore);

  /// Get the services collection reference
  CollectionReference get _servicesCollection =>
      _firestore.collection('services');

  @override
  Future<List<Service>> getServices() async {
    try {
      final querySnapshot = await _servicesCollection.get();
      return querySnapshot.docs.map((doc) {
        return Service.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch services: $e');
    }
  }

  @override
  Future<Service> getServiceById(String id) async {
    try {
      final docSnapshot = await _servicesCollection.doc(id).get();

      if (!docSnapshot.exists) {
        throw Exception('Service with id $id not found');
      }

      return Service.fromFirestore(
        docSnapshot.data() as Map<String, dynamic>,
        docSnapshot.id,
      );
    } catch (e) {
      throw Exception('Failed to fetch service: $e');
    }
  }
}
