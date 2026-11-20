import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import 'home/home_view.dart';
import 'discover/discover_view.dart';
import 'cart/cart_view.dart';
import 'profile/profile_view.dart';

class MainScreen extends GetView<MainController> {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeView(),
      const DiscoverView(),
      const CartView(),
      const ProfileView(),
    ];

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWeb = constraints.maxWidth > 800;
          return Column(
            children: [
              if (isWeb) _buildWebNavBar(),
              Expanded(
                child: Obx(() => pages[controller.currentIndex.value]),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) return const SizedBox.shrink();
          return Obx(
            () => NavigationBar(
              selectedIndex: controller.currentIndex.value,
              onDestinationSelected: controller.changeIndex,
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
                NavigationDestination(icon: Icon(Icons.search_outlined), selectedIcon: Icon(Icons.search), label: 'Discover'),
                NavigationDestination(icon: Icon(Icons.shopping_cart_outlined), selectedIcon: Icon(Icons.shopping_cart), label: 'Cart'),
                NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWebNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Text(
            'FreshGrocery',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Get.theme.primaryColor,
            ),
          ),
          const Spacer(),
          _navItem('Home', 0),
          _navItem('Discover', 1),
          _navItem('Cart', 2),
          _navItem('Profile', 3),
        ],
      ),
    );
  }

  Widget _navItem(String label, int index) {
    return Obx(
      () => TextButton(
        onPressed: () => controller.changeIndex(index),
        child: Text(
          label,
          style: TextStyle(
            color: controller.currentIndex.value == index ? Get.theme.primaryColor : Colors.grey,
            fontWeight: controller.currentIndex.value == index ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
