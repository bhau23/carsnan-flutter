class Address {
  final String id;
  final String title;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final double latitude;
  final double longitude;
  final bool isDefault;

  const Address({
    required this.id,
    required this.title,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.latitude,
    required this.longitude,
    this.isDefault = false,
  });
}
