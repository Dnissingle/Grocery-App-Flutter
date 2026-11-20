enum CategoryType { vegetables, fruits, dairy, pantry }

class Product {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final String unit; // e.g., 1kg, 500g, 1 pack
  final CategoryType category;
  final bool isOrganic;
  final String nutritionInfo;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.unit,
    required this.category,
    this.isOrganic = false,
    this.nutritionInfo = "Rich in vitamins and minerals.",
  });
}
