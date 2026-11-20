import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/checkout_controller.dart';
import '../../controllers/cart_controller.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final checkoutController = Get.put(CheckoutController());
    final cartController = Get.find<CartController>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Obx(() {
        if (checkoutController.isProcessing.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(color: Colors.green),
                const SizedBox(height: 20),
                const Text('Processing your payment...', style: TextStyle(fontSize: 16)),
              ],
            ),
          );
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Delivery Address'),
              const SizedBox(height: 10),
              _buildAddressSelector(checkoutController),
              const SizedBox(height: 20),
              _buildSectionTitle('Delivery Slot'),
              const SizedBox(height: 10),
              _buildSlotSelector(checkoutController),
              const SizedBox(height: 20),
              _buildSectionTitle('Payment Method'),
              const SizedBox(height: 10),
              _buildPaymentSelector(checkoutController),
              const SizedBox(height: 30),
              _buildOrderSummary(cartController),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => checkoutController.processPayment(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text('Pay & Place Order', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildAddressSelector(CheckoutController controller) {
    return Obx(() => RadioGroup<String>(
          groupValue: controller.selectedAddress.value,
          onChanged: (val) => controller.selectedAddress.value = val!,
          child: Column(
            children: controller.addresses.map((address) {
              return RadioListTile<String>(
                value: address,
                title: Text(address),
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                activeColor: Colors.green,
              );
            }).toList(),
          ),
        ));
  }

  Widget _buildSlotSelector(CheckoutController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Obx(() => DropdownButton<String>(
            value: controller.selectedSlot.value,
            isExpanded: true,
            underline: const SizedBox(),
            items: controller.deliverySlots.map((slot) {
              return DropdownMenuItem(value: slot, child: Text(slot));
            }).toList(),
            onChanged: (val) => controller.selectedSlot.value = val!,
          )),
    );
  }

  Widget _buildPaymentSelector(CheckoutController controller) {
    return Obx(() => RadioGroup<String>(
          groupValue: controller.selectedPaymentMethod.value,
          onChanged: (val) => controller.selectedPaymentMethod.value = val!,
          child: Column(
            children: controller.paymentMethods.map((method) {
              return RadioListTile<String>(
                value: method['name'] as String,
                title: Row(
                  children: [
                    Icon(method['icon'] as IconData, color: Colors.green),
                    const SizedBox(width: 10),
                    Text(method['name'] as String),
                  ],
                ),
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                activeColor: Colors.green,
              );
            }).toList(),
          ),
        ));
  }

  Widget _buildOrderSummary(CartController cartController) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Amount', style: TextStyle(fontSize: 16)),
              Text('Rs. ${cartController.total}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
            ],
          ),
        ],
      ),
    );
  }
}
