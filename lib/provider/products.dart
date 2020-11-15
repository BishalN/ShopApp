import 'package:flutter/material.dart';

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Headphone',
      description: 'A nice Headphone.',
      price: 59.99,
      imageUrl:
          'https://images.pexels.com/photos/3756767/pexels-photo-3756767.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
    ),
    Product(
      id: 'p3',
      title: 'Guitar',
      description: 'A nice Guitar.',
      price: 599.99,
      imageUrl:
          'https://images.pexels.com/photos/1407322/pexels-photo-1407322.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
    )
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  Product findById(id) {
    return _items.firstWhere((product) => product.id == id);
  }

  void addProducts() {
    notifyListeners();
  }
}
