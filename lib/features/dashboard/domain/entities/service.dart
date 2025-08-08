class Service {
  final String id;
  final String title;
  final String description;
  final String iconPath;
  final String bannerImagePath;
  final ServiceType type;
  final double price;
  final int estimatedDurationInMinutes;
  final List<String> features;
  final List<ServiceItem> includedItems;
  final String highlightFeature;

  const Service({
    required this.id,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.bannerImagePath,
    required this.type,
    required this.price,
    required this.estimatedDurationInMinutes,
    required this.features,
    required this.includedItems,
    required this.highlightFeature,
  });
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
