class ServiceImageHelper {
  static const String _basePath = 'assets/images/services/';
  
  // Service image paths
  static const String generalWash = '${_basePath}general_wash.png';
  static const String premiumWash = '${_basePath}premium_wash.png';
  static const String luxuryWash = '${_basePath}luxury_wash.png';
  
  /// Get image path by service type
  static String getImagePath(String serviceType) {
    switch (serviceType.toLowerCase()) {
      case 'general':
        return generalWash;
      case 'premium':
        return premiumWash;
      case 'luxury':
        return luxuryWash;
      default:
        return generalWash;
    }
  }
  
  /// Check if image exists (for future validation)
  static bool isValidImagePath(String path) {
    return path.startsWith(_basePath) && 
           (path.endsWith('.png') || 
            path.endsWith('.jpg') || 
            path.endsWith('.jpeg'));
  }
  
  /// Get all service image paths
  static List<String> getAllImagePaths() {
    return [generalWash, premiumWash, luxuryWash];
  }
}
