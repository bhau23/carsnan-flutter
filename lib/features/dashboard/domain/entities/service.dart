class Service {
  final String id;
  final String name;
  final String description;
  final List<String> images;
  final double price;
  final int duration;
  final List<SubService> subServices;

  // Legacy fields for backward compatibility (can be removed later)
  @Deprecated('Use name instead')
  String get title => name;

  @Deprecated('Use images instead')
  String get iconPath => images.isNotEmpty ? images.first : '';

  @Deprecated('Use images instead')
  String get bannerImagePath => images.length > 1 ? images[1] : iconPath;

  @Deprecated('Use duration instead')
  int get estimatedDurationInMinutes => duration;

  @Deprecated('Use subServices instead')
  List<ServiceItem> get includedItems => subServices
      .map(
        (sub) => ServiceItem(
          id: sub.id,
          name: sub.name,
          imagePath: sub.imageUrl,
          description: sub.description,
        ),
      )
      .toList();

  // Additional backward compatibility getters
  @Deprecated('Service type is no longer stored. Infer from price range.')
  ServiceType get type {
    if (price < 40) return ServiceType.general;
    if (price < 100) return ServiceType.premium;
    return ServiceType.luxury;
  }

  @Deprecated('Use description instead')
  String get highlightFeature => description;

  @Deprecated('Features are now derived from subServices')
  List<String> get features => subServices.map((sub) => sub.name).toList();

  const Service({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.price,
    required this.duration,
    required this.subServices,
  });

  /// Factory constructor for backward compatibility with old Service structure
  factory Service.legacy({
    required String id,
    required String title,
    required String description,
    required String iconPath,
    required String bannerImagePath,
    required ServiceType type,
    required double price,
    required int estimatedDurationInMinutes,
    required List<String> features,
    required List<ServiceItem> includedItems,
    required String highlightFeature,
  }) {
    return Service(
      id: id,
      name: title,
      description: description,
      images: [iconPath, bannerImagePath],
      price: price,
      duration: estimatedDurationInMinutes,
      subServices: includedItems
          .map(
            (item) => SubService(
              id: item.id,
              name: item.name,
              description: item.description,
              imageUrl: item.imagePath,
            ),
          )
          .toList(),
    );
  }

  /// Create Service from Firestore document
  factory Service.fromFirestore(Map<String, dynamic> data, String documentId) {
    final subServicesData = data['subServices'] as List<dynamic>? ?? [];
    final subServices = subServicesData
        .map(
          (subService) =>
              SubService.fromMap(subService as Map<String, dynamic>),
        )
        .toList();

    return Service(
      id: documentId,
      name: data['name'] as String,
      description: data['description'] as String,
      images: List<String>.from(data['images'] as List<dynamic>? ?? []),
      price: (data['price'] as num).toDouble(),
      duration: data['duration'] as int,
      subServices: subServices,
    );
  }

  /// Convert Service to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'images': images,
      'price': price,
      'duration': duration,
      'subServices': subServices
          .map((subService) => subService.toMap())
          .toList(),
    };
  }
}

/// Represents a sub-service included in a main service
class SubService {
  final String id;
  final String name;
  final String description;
  final String imageUrl;

  const SubService({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  /// Create SubService from Map
  factory SubService.fromMap(Map<String, dynamic> map) {
    return SubService(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      imageUrl: map['imageUrl'] as String,
    );
  }

  /// Convert SubService to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}

class ServiceItem {
  final String id;
  final String name;
  final String imagePath;
  final String description;

  const ServiceItem({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.description,
  });
}

enum ServiceType { general, premium, luxury }
