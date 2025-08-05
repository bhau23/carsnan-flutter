class Service {
  final String id;
  final String title;
  final String description;
  final String iconPath;
  final ServiceType type;
  final double price;
  final List<String> features;

  const Service({
    required this.id,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.type,
    required this.price,
    required this.features,
  });
}

enum ServiceType { general, premium, luxury }
