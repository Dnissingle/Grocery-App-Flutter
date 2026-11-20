import 'package:get/get.dart';
import '../models/product_model.dart';
import '../services/mock_data.dart';

class ProductController extends GetxController {
  var allProducts = <Product>[].obs;
  var filteredProducts = <Product>[].obs;
  var selectedCategory = 'All'.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    allProducts.value = MockData.getProducts();
    filteredProducts.value = allProducts;
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    _applyFilters();
  }

  void searchProducts(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void _applyFilters() {
    var result = allProducts.toList();

    if (selectedCategory.value != 'All') {
      result = result.where((p) => p.category.name.toLowerCase() == selectedCategory.value.toLowerCase()).toList();
    }

    if (searchQuery.value.isNotEmpty) {
      result = result.where((p) => p.name.toLowerCase().contains(searchQuery.value.toLowerCase())).toList();
    }

    filteredProducts.value = result;
  }
}
