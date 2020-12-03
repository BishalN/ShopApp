import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  Future<void> addProducts(Product product) {
    const url =
        'https://myshop-228a0-default-rtdb.firebaseio.com/products.json';
    return http
        .post(url,
            body: json.encode({
              'title': product.title,
              'price': product.price,
              'description': product.description,
              'isFavorite': product.isFavorite,
              'imageUrl': product.imageUrl
            }))
        .then((response) {
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price);
      _items.add(newProduct);
      notifyListeners();
    }).catchError((error) {
      print(error);
      throw error;
    });
  }

  void updateProducts(String id, Product newProduct) {
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      _items[productIndex] = newProduct;
      notifyListeners();
    } else {
      print('Something went wrong with the product id passed');
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
