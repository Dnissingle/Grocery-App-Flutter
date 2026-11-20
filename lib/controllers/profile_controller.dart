import 'package:get/get.dart';
import '../services/storage_service.dart';

class ProfileController extends GetxController {
  var userData = <String, String>{}.obs;
  var addresses = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadProfileData();
  }

  void loadProfileData() {
    userData.value = StorageService.getUserData();
    addresses.value = StorageService.getAddresses();
  }

  void updateUserData(String name, String phone, String email) {
    final newData = {
      'name': name,
      'phone': phone,
      'email': email,
    };
    userData.value = newData;
    StorageService.saveUserData(newData);
  }

  void addAddress(String address) {
    if (address.isNotEmpty && !addresses.contains(address)) {
      StorageService.saveAddress(address);
      addresses.value = StorageService.getAddresses();
    }
  }

  void removeAddress(String address) {
    StorageService.removeAddress(address);
    addresses.value = StorageService.getAddresses();
  }
}
