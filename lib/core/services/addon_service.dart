import '../models/addon_product.dart';

class AddonService {
  static final List<AddonProduct> _sampleAddons = [
    AddonProduct(
      id: 'addon_1',
      name: 'Nanofiber Cloth',
      description: 'Premium microfiber cloth for spotless cleaning',
      imagePath: 'assets/images/addons/nanofiber_cloth.png',
      price: 299,
      category: 'Cleaning',
      isPopular: true,
    ),
    AddonProduct(
      id: 'addon_2',
      name: 'Car Polish',
      description: 'Long-lasting shine and protection',
      imagePath: 'assets/images/addons/car_polish.png',
      price: 499,
      category: 'Protection',
      isPopular: true,
    ),
    AddonProduct(
      id: 'addon_3',
      name: 'Car Dustbin',
      description: 'Compact dustbin for your car interior',
      imagePath: 'assets/images/addons/car_dustbin.png',
      price: 199,
      category: 'Accessories',
    ),
    AddonProduct(
      id: 'addon_4',
      name: 'Tissue Box',
      description: 'Soft tissues for car cleaning and personal use',
      imagePath: 'assets/images/addons/tissue_box.png',
      price: 149,
      category: 'Cleaning',
    ),
    AddonProduct(
      id: 'addon_5',
      name: 'Air Freshener',
      description: 'Long-lasting car air freshener',
      imagePath: 'assets/images/addons/air_freshener.png',
      price: 99,
      category: 'Accessories',
      isPopular: true,
    ),
    AddonProduct(
      id: 'addon_6',
      name: 'Dashboard Cleaner',
      description: 'Specialized cleaner for dashboard and interiors',
      imagePath: 'assets/images/addons/dashboard_cleaner.png',
      price: 249,
      category: 'Cleaning',
    ),
    AddonProduct(
      id: 'addon_7',
      name: 'Tire Shine Spray',
      description: 'Professional tire shine for lasting gloss',
      imagePath: 'assets/images/addons/tire_shine.png',
      price: 349,
      category: 'Protection',
    ),
    AddonProduct(
      id: 'addon_8',
      name: 'Wax Spray',
      description: 'Quick wax spray for instant shine',
      imagePath: 'assets/images/addons/wax_spray.png',
      price: 399,
      category: 'Protection',
    ),
  ];

  /// Get all available addon products
  List<AddonProduct> getAllAddons() {
    return List.unmodifiable(_sampleAddons);
  }

  /// Get popular addon products
  List<AddonProduct> getPopularAddons() {
    return _sampleAddons.where((addon) => addon.isPopular).toList();
  }

  /// Get addons by category
  List<AddonProduct> getAddonsByCategory(String category) {
    return _sampleAddons.where((addon) => addon.category == category).toList();
  }

  /// Get all available categories
  List<String> getCategories() {
    return _sampleAddons.map((addon) => addon.category).toSet().toList();
  }

  /// Find addon by ID
  AddonProduct? findAddonById(String id) {
    try {
      return _sampleAddons.firstWhere((addon) => addon.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get recommended addons for a service (sample logic)
  List<AddonProduct> getRecommendedAddons(String serviceId) {
    // For now, return popular addons as recommended
    // In future, this can be service-specific recommendations
    return getPopularAddons();
  }
}

// Storage service implementation moved to separate file: storage_service.dart

// STORAGE SERVICE CONTENT FOR CREATION:
/*
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';

@injectable
class StorageService {
  final FirebaseStorage _storage;

  StorageService(this._storage);

  /// Uploads a profile picture to Firebase Storage
  /// Returns the download URL of the uploaded image
  Future<String> uploadProfilePicture(File image, String userId) async {
    try {
      // Create reference to the storage location
      final ref = _storage.ref().child('profile_pictures').child(userId).child('profile.jpg');
      
      // Upload the file
      final uploadTask = ref.putFile(image);
      
      // Wait for upload to complete
      final snapshot = await uploadTask.whenComplete(() => {});
      
      // Get the download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload profile picture: $e');
    }
  }

  /// Deletes a profile picture from Firebase Storage
  Future<void> deleteProfilePicture(String userId) async {
    try {
      final ref = _storage.ref().child('profile_pictures').child(userId).child('profile.jpg');
      await ref.delete();
    } catch (e) {
      // If file doesn't exist, that's fine
      if (e is FirebaseException && e.code == 'object-not-found') {
        return;
      }
      throw Exception('Failed to delete profile picture: $e');
    }
  }
}
*/
