import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() => _buildHeader(controller)),
            const SizedBox(height: 20),
            _buildMenuSection(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ProfileController controller) {
    final userData = controller.userData;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=200&auto=format&fit=crop'),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userData['name'] ?? 'John Doe',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  userData['phone'] ?? '+977 9800000000',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                Text(
                  userData['email'] ?? 'john.doe@example.com',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showEditProfileDialog(controller),
            icon: const Icon(Icons.edit_outlined, color: Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(ProfileController controller) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildMenuItem(Icons.shopping_bag_outlined, 'My Orders', () => _showOrdersHistory()),
          _buildMenuItem(Icons.location_on_outlined, 'Saved Addresses', () => _showAddressesScreen(controller)),
          _buildMenuItem(Icons.payment_outlined, 'Payment Methods', () {}),
          const Divider(height: 1),
          _buildMenuItem(Icons.dark_mode_outlined, 'Dark Mode', () {}, trailing: Switch(value: false, onChanged: (v) {})),
          _buildMenuItem(Icons.help_outline, 'Help & Support', () {}),
          _buildMenuItem(Icons.logout, 'Logout', () {}, textColor: Colors.red),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, {Widget? trailing, Color? textColor}) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? Colors.black87),
      title: Text(title, style: TextStyle(color: textColor ?? Colors.black87, fontWeight: FontWeight.w500)),
      trailing: trailing ?? const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }

  void _showEditProfileDialog(ProfileController controller) {
    final nameController = TextEditingController(text: controller.userData['name']);
    final phoneController = TextEditingController(text: controller.userData['phone']);
    final emailController = TextEditingController(text: controller.userData['email']);

    Get.dialog(
      AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone')),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              controller.updateUserData(nameController.text, phoneController.text, emailController.text);
              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddressesScreen(ProfileController controller) {
    Get.to(() => Scaffold(
          appBar: AppBar(title: const Text('Saved Addresses')),
          body: Obx(() => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.addresses.length,
                itemBuilder: (context, index) {
                  final address = controller.addresses[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.location_on, color: Colors.green),
                      title: Text(address),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => controller.removeAddress(address),
                      ),
                    ),
                  );
                },
              )),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddAddressDialog(controller),
            backgroundColor: Colors.green,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ));
  }

  void _showAddAddressDialog(ProfileController controller) {
    final addressController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('Add New Address'),
        content: TextField(
          controller: addressController,
          decoration: const InputDecoration(hintText: 'Enter full address'),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              controller.addAddress(addressController.text);
              Get.back();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showOrdersHistory() {
    Get.to(() => Scaffold(
          appBar: AppBar(title: const Text('My Orders')),
          body: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Order #ORD${1024 + index}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text('Rs. 1250', style: TextStyle(color: Get.theme.primaryColor, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text('24 Oct 2023, 10:30 AM', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      const Divider(),
                      _buildStatusStep('Order Placed', true),
                      _buildStatusStep('Packing', true),
                      _buildStatusStep('Out for Delivery', index == 0),
                      _buildStatusStep('Delivered', false),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }

  Widget _buildStatusStep(String label, bool isCompleted) {
    return Row(
      children: [
        Icon(
          isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 16,
          color: isCompleted ? Colors.green : Colors.grey,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isCompleted ? Colors.black : Colors.grey,
            fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
