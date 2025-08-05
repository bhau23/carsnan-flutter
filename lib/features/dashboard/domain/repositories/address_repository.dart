import '../entities/address.dart';

abstract class AddressRepository {
  Future<List<Address>> getAddresses();
  Future<Address> addAddress(Address address);
  Future<void> deleteAddress(String id);
  Future<Address> updateAddress(Address address);
}
