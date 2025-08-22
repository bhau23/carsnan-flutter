import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:injectable/injectable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/address_model.dart';

abstract class AddressLocalDataSource {
  Future<List<AddressModel>> getAddresses();
  Future<AddressModel?> getDefaultAddress();
  Future<void> saveAddress(AddressModel address);
  Future<void> updateAddress(AddressModel address);
  Future<void> deleteAddress(String addressId);
  Future<void> setDefaultAddress(String addressId);
}

/// Abstract data source for address data from Firestore
abstract class AddressFirestoreDataSource {
  /// Get all addresses for the current user from Firestore
  Future<List<AddressModel>> getAddresses(String userId);

  /// Add a new address to Firestore
  Future<AddressModel> addAddress(String userId, AddressModel address);

  /// Update an existing address in Firestore
  Future<AddressModel> updateAddress(String userId, AddressModel address);

  /// Delete an address by ID from Firestore
  Future<void> deleteAddress(String userId, String addressId);

  /// Set an address as default (unsets others) in Firestore
  Future<void> setDefaultAddress(String userId, String addressId);

  /// Get the default address from Firestore
  Future<AddressModel?> getDefaultAddress(String userId);

  /// Get a specific address by ID from Firestore
  Future<AddressModel?> getAddressById(String userId, String addressId);
}

@Injectable(as: AddressLocalDataSource)
class AddressLocalDataSourceImpl implements AddressLocalDataSource {
  static const String _addressesKey = 'saved_addresses';

  @override
  Future<List<AddressModel>> getAddresses() async {
    debugPrint('Getting addresses from SharedPreferences'); // Debug print
    final prefs = await SharedPreferences.getInstance();
    final addressesJson = prefs.getStringList(_addressesKey) ?? [];

    final addresses = addressesJson
        .map((jsonStr) => AddressModel.fromJson(json.decode(jsonStr)))
        .where((address) => !address.isDeleted)
        .toList();

    debugPrint('Found ${addresses.length} addresses'); // Debug print
    return addresses;
  }

  @override
  Future<AddressModel?> getDefaultAddress() async {
    final addresses = await getAddresses();
    try {
      return addresses.firstWhere((address) => address.isDefault);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveAddress(AddressModel address) async {
    debugPrint('Saving address: ${address.title}'); // Debug print
    final prefs = await SharedPreferences.getInstance();
    final addresses = await getAddresses();

    // If this is the first address, make it default
    if (addresses.isEmpty) {
      final defaultAddress = AddressModel.fromDomain(
        address.copyWith(isDefault: true),
      );
      addresses.add(defaultAddress);
    } else {
      addresses.add(address);
    }

    // Save to SharedPreferences
    final addressesJson = addresses
        .map((addr) => json.encode(addr.toJson()))
        .toList();
    await prefs.setStringList(_addressesKey, addressesJson);

    debugPrint(
      'Total addresses after save: ${addresses.length}',
    ); // Debug print
  }

  @override
  Future<void> updateAddress(AddressModel address) async {
    final prefs = await SharedPreferences.getInstance();
    final addresses = await getAddresses();
    final index = addresses.indexWhere((addr) => addr.id == address.id);
    if (index != -1) {
      addresses[index] = address;
      final addressesJson = addresses
          .map((addr) => json.encode(addr.toJson()))
          .toList();
      await prefs.setStringList(_addressesKey, addressesJson);
    }
  }

  @override
  Future<void> deleteAddress(String addressId) async {
    final prefs = await SharedPreferences.getInstance();
    final addresses = await getAddresses();
    final index = addresses.indexWhere((addr) => addr.id == addressId);
    if (index != -1) {
      addresses[index] = AddressModel.fromDomain(
        addresses[index].copyWith(isDeleted: true, updatedAt: DateTime.now()),
      );
      final addressesJson = addresses
          .map((addr) => json.encode(addr.toJson()))
          .toList();
      await prefs.setStringList(_addressesKey, addressesJson);
    }
  }

  @override
  Future<void> setDefaultAddress(String addressId) async {
    final prefs = await SharedPreferences.getInstance();
    final addresses = await getAddresses();

    // First, set all addresses to non-default
    for (int i = 0; i < addresses.length; i++) {
      if (addresses[i].isDefault) {
        addresses[i] = AddressModel.fromDomain(
          addresses[i].copyWith(isDefault: false, updatedAt: DateTime.now()),
        );
      }
    }

    // Then set the specified address as default
    final index = addresses.indexWhere((addr) => addr.id == addressId);
    if (index != -1) {
      addresses[index] = AddressModel.fromDomain(
        addresses[index].copyWith(isDefault: true, updatedAt: DateTime.now()),
      );

      final addressesJson = addresses
          .map((addr) => json.encode(addr.toJson()))
          .toList();
      await prefs.setStringList(_addressesKey, addressesJson);
    }
  }
}

@Injectable(as: AddressFirestoreDataSource)
class AddressFirestoreDataSourceImpl implements AddressFirestoreDataSource {
  final FirebaseFirestore _firestore;

  AddressFirestoreDataSourceImpl(this._firestore);

  CollectionReference _getAddressesCollection(String userId) {
    return _firestore.collection('users').doc(userId).collection('addresses');
  }

  @override
  Future<List<AddressModel>> getAddresses(String userId) async {
    try {
      final querySnapshot = await _getAddressesCollection(
        userId,
      ).where('isDeleted', isEqualTo: false).get();
      return querySnapshot.docs
          .map(
            (doc) => AddressModel.fromFirestore(
              doc.id,
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get addresses: $e');
    }
  }

  @override
  Future<AddressModel> addAddress(String userId, AddressModel address) async {
    try {
      final docRef = await _getAddressesCollection(
        userId,
      ).add(address.toFirestore());
      return address.copyWith(id: docRef.id);
    } catch (e) {
      throw Exception('Failed to add address: $e');
    }
  }

  @override
  Future<AddressModel> updateAddress(
    String userId,
    AddressModel address,
  ) async {
    try {
      await _getAddressesCollection(userId)
          .doc(address.id)
          .update(address.copyWith(updatedAt: DateTime.now()).toFirestore());
      return address.copyWith(updatedAt: DateTime.now());
    } catch (e) {
      throw Exception('Failed to update address: $e');
    }
  }

  @override
  Future<void> deleteAddress(String userId, String addressId) async {
    try {
      await _getAddressesCollection(userId).doc(addressId).update({
        'isDeleted': true,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to delete address: $e');
    }
  }

  @override
  Future<void> setDefaultAddress(String userId, String addressId) async {
    try {
      final batch = _firestore.batch();

      // First, unset all default addresses
      final existingAddresses = await _getAddressesCollection(
        userId,
      ).where('isDefault', isEqualTo: true).get();

      for (final doc in existingAddresses.docs) {
        batch.update(doc.reference, {
          'isDefault': false,
          'updatedAt': Timestamp.fromDate(DateTime.now()),
        });
      }

      // Then set the specified address as default
      final addressRef = _getAddressesCollection(userId).doc(addressId);
      batch.update(addressRef, {
        'isDefault': true,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to set default address: $e');
    }
  }

  @override
  Future<AddressModel?> getDefaultAddress(String userId) async {
    try {
      final querySnapshot = await _getAddressesCollection(userId)
          .where('isDefault', isEqualTo: true)
          .where('isDeleted', isEqualTo: false)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      final doc = querySnapshot.docs.first;
      return AddressModel.fromFirestore(
        doc.id,
        doc.data() as Map<String, dynamic>,
      );
    } catch (e) {
      throw Exception('Failed to get default address: $e');
    }
  }

  @override
  Future<AddressModel?> getAddressById(String userId, String addressId) async {
    try {
      final doc = await _getAddressesCollection(userId).doc(addressId).get();

      if (!doc.exists) {
        return null;
      }

      return AddressModel.fromFirestore(
        doc.id,
        doc.data() as Map<String, dynamic>,
      );
    } catch (e) {
      throw Exception('Failed to get address by ID: $e');
    }
  }
}
