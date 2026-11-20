import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cart_controller.dart';
import '../services/storage_service.dart';
import '../screens/esewa_payment_screen.dart';

class CheckoutController extends GetxController {
  var selectedAddress = ''.obs;
  var selectedSlot = 'Tomorrow, 10 AM - 12 PM'.obs;
  var selectedPaymentMethod = ''.obs;
  var isProcessing = false.obs;

  final RxList<String> addresses = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    addresses.value = StorageService.getAddresses();
    selectedAddress.value = addresses.first;
    selectedPaymentMethod.value = StorageService.getPaymentPreference();
  }

  final List<String> deliverySlots = [
    'Today, 4 PM - 6 PM',
    'Tomorrow, 10 AM - 12 PM',
    'Tomorrow, 2 PM - 4 PM',
  ];

  final List<Map<String, dynamic>> paymentMethods = [
    {'name': 'eSewa', 'icon': Icons.account_balance_wallet},
    {'name': 'Khalti', 'icon': Icons.account_balance},
    {'name': 'Cash on Delivery', 'icon': Icons.money},
  ];

  void processPayment() async {
    if (selectedPaymentMethod.value == 'eSewa') {
      final cartController = Get.find<CartController>();
      final amount = cartController.total.toStringAsFixed(2);
      final transactionUuid = DateTime.now().millisecondsSinceEpoch.toString();

      final result = await Get.to(() => EsewaPaymentScreen(
            amount: amount,
            transactionUuid: transactionUuid,
          ));

      if (result != null) {
        // Payment successful
        _completeOrder();
      } else {
        Get.snackbar(
          'Payment Cancelled',
          'The eSewa payment process was cancelled or failed.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      // Handle COD or other methods
      isProcessing.value = true;
      await Future.delayed(const Duration(seconds: 2));
      isProcessing.value = false;
      _completeOrder();
    }
  }

  void _completeOrder() {
    // Save preferences
    StorageService.savePaymentPreference(selectedPaymentMethod.value);
    
    // Clear cart and navigate to success
    Get.find<CartController>().clearCart();
    Get.offAllNamed('/payment-success');
  }
}
