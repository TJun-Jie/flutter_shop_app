import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/screens/edit_product_screen.dart';
import 'package:flutter_complete_guide/widgets/app_drawer.dart';
import 'package:flutter_complete_guide/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key key}) : super(key: key);

  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    print('hi');
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    print('rebuilding');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () {
                      return _refreshProducts(context);
                    },
                    child: Consumer<Products>(
                      builder: (context, productsData, child) => Padding(
                        child: ListView.builder(
                          itemBuilder: (_, i) {
                            return Column(
                              children: [
                                UserProductItem(
                                  title: productsData.items[i].title,
                                  imageUrl: productsData.items[i].imageUrl,
                                  id: productsData.items[i].id,
                                  deleteHandler: productsData.deleteProduct,
                                ),
                                Divider(),
                              ],
                            );
                          },
                          itemCount: productsData.items.length,
                        ),
                        padding: EdgeInsets.all(1),
                      ),
                    ),
                  ),
      ),
      drawer: AppDrawer(),
    );
  }
}
