import 'package:get/get.dart';
import '../models/product_model.dart';
import '../models/cart_item_model.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;

  void addToCart(Product product) {
    var index = cartItems.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      cartItems[index].quantity++;
      cartItems.refresh();
    } else {
      cartItems.add(CartItem(product: product));
    }
  }

  void removeFromCart(Product product) {
    var index = cartItems.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
        cartItems.refresh();
      } else {
        cartItems.removeAt(index);
      }
    }
  }

  void clearCart() {
    cartItems.clear();
  }

  int getProductQuantity(String id) {
    var item = cartItems.firstWhereOrNull((item) => item.product.id == id);
    return item?.quantity ?? 0;
  }

  double get subtotal => cartItems.fold(0, (sum, item) => sum + item.total);
  double get deliveryFee => cartItems.isEmpty ? 0 : 50.0;
  double get total => subtotal + deliveryFee;
}
