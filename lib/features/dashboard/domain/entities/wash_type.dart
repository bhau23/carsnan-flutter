/// Enum for different wash types available
enum WashType {
  waterless(
    displayName: 'Waterless Car Wash',
    description: 'An eco-friendly car wash method that uses specialized cleaning products without water. Perfect for quick cleaning and environmentally conscious customers.',
    imagePath: 'assets/images/wash_types/waterless_wash.png',
    benefits: [
      'Water conservation',
      'Quick and convenient',
      'Eco-friendly',
      'Can be done anywhere',
      'No soap residue'
    ],
  ),
  
  rinseless(
    displayName: 'Rinseless Car Wash',
    description: 'A water-efficient cleaning method using minimal water and special lubricating solutions. Provides thorough cleaning with reduced water usage.',
    imagePath: 'assets/images/wash_types/rinseless_wash.png',
    benefits: [
      'Minimal water usage',
      'Safe for paint',
      'Thorough cleaning',
      'No water spots',
      'Professional results'
    ],
  ),
  
  bucket(
    displayName: 'Bucket Car Wash',
    description: 'Traditional car wash method using soap, water, and proper washing techniques. The most comprehensive and thorough cleaning option.',
    imagePath: 'assets/images/wash_types/bucket_wash.png',
    benefits: [
      'Most thorough cleaning',
      'Deep dirt removal',
      'Traditional method',
      'Complete rinse',
      'Best for heavily soiled cars'
    ],
  );

  const WashType({
    required this.displayName,
    required this.description,
    required this.imagePath,
    required this.benefits,
  });

  /// Human-readable name
  final String displayName;

  /// Detailed description of the wash type
  final String description;

  /// Path to the wash type illustration image
  final String imagePath;

  /// List of benefits for this wash type
  final List<String> benefits;
}
