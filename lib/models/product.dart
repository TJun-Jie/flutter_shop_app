import 'package:flutter/foundation.dart';

class Product {
  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite});

  final String description;
  final String id;
  final String imageUrl;
  bool isFavorite;
  final double price;
  final String title;
}
