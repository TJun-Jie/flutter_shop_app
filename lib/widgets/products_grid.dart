import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  ProductsGrid(this.showFavs);

  final bool showFavs;

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final loadedProducts =
        showFavs ? productsData.favoriteItems : productsData.items;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, i) {
        return ChangeNotifierProvider.value(
          value: loadedProducts[i],
          child: ProductItem(),
        );
      },
      padding: const EdgeInsets.all(10.0),
      itemCount: loadedProducts.length,
    );
  }
}
