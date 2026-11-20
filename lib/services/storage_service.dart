import 'package:get_storage/get_storage.dart';

class StorageService {
  static final _box = GetStorage();

  static const String keyAddresses = 'user_addresses';
  static const String keyPaymentPreference = 'payment_preference';
  static const String keyUserData = 'user_data';

  static List<String> getAddresses() {
    return List<String>.from(_box.read(keyAddresses) ?? [
      'Home - Baneshwor, Kathmandu',
      'Office - Durbar Marg, Kathmandu',
    ]);
  }

  static void saveAddress(String address) {
    List<String> addresses = getAddresses();
    if (!addresses.contains(address)) {
      addresses.add(address);
      _box.write(keyAddresses, addresses);
    }
  }

  static void removeAddress(String address) {
    List<String> addresses = getAddresses();
    addresses.remove(address);
    _box.write(keyAddresses, addresses);
  }

  static Map<String, String> getUserData() {
    final data = _box.read(keyUserData);
    if (data != null) {
      return Map<String, String>.from(data);
    }
    return {
      'name': 'John Doe',
      'phone': '+977 9800000000',
      'email': 'john.doe@example.com',
    };
  }

  static void saveUserData(Map<String, String> data) {
    _box.write(keyUserData, data);
  }

  static String getPaymentPreference() {
    return _box.read(keyPaymentPreference) ?? 'Cash on Delivery';
  }

  static void savePaymentPreference(String method) {
    _box.write(keyPaymentPreference, method);
  }
}
