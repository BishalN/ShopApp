import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item.dart';
import '../provider/products.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavs;
  ProductGrid(this.showFavs);
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products = showFavs ? productData.favoriteItems : productData.items;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        key: key,
        value: products[index],
        child: ProductItem(),
      ),
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
    );
  }
}
