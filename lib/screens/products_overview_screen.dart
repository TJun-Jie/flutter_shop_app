import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/products_grid.dart';

class ProductsOverViewScreen extends StatelessWidget {
  ProductsOverViewScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
      ),
      body: ProductsGrid(),
    );
  }
}
