import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/address_model.dart';

abstract class AddressLocalDataSource {
  Future<List<AddressModel>> getAddresses();
  Future<AddressModel?> getDefaultAddress();
  Future<void> saveAddress(AddressModel address);
  Future<void> updateAddress(AddressModel address);
  Future<void> deleteAddress(String addressId);
  Future<void> setDefaultAddress(String addressId);
}

class AddressLocalDataSourceImpl implements AddressLocalDataSource {
  static const String _addressesKey = 'saved_addresses';

  @override
  Future<List<AddressModel>> getAddresses() async {
    print('Getting addresses from SharedPreferences'); // Debug print
    final prefs = await SharedPreferences.getInstance();
    final addressesJson = prefs.getStringList(_addressesKey) ?? [];
    
    final addresses = addressesJson
        .map((jsonStr) => AddressModel.fromJson(json.decode(jsonStr)))
        .where((address) => !address.isDeleted)
        .toList();
    
    print('Found ${addresses.length} addresses'); // Debug print
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
    print('Saving address: ${address.title}'); // Debug print
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
    
    print('Total addresses after save: ${addresses.length}'); // Debug print
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
        addresses[index].copyWith(
          isDeleted: true,
          updatedAt: DateTime.now(),
        ),
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
          addresses[i].copyWith(
            isDefault: false,
            updatedAt: DateTime.now(),
          ),
        );
      }
    }

    // Then set the specified address as default
    final index = addresses.indexWhere((addr) => addr.id == addressId);
    if (index != -1) {
      addresses[index] = AddressModel.fromDomain(
        addresses[index].copyWith(
          isDefault: true,
          updatedAt: DateTime.now(),
        ),
      );
      
      final addressesJson = addresses
          .map((addr) => json.encode(addr.toJson()))
          .toList();
      await prefs.setStringList(_addressesKey, addressesJson);
    }
  }
}
