import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  final String description;
  final String id;
  final String imageUrl;
  bool isFavorite = false;
  final double price;
  final String title;

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
