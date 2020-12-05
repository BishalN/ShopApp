import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  Product findById(id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    const url =
        'https://myshop-228a0-default-rtdb.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            imageUrl: prodData['imageUrl'],
            isFavorite: prodData['isFavorite'],
            price: prodData['price']));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProducts(Product product) async {
    const url =
        'https://myshop-228a0-default-rtdb.firebaseio.com/products.json';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'isFavorite': product.isFavorite,
            'imageUrl': product.imageUrl
          }));

      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProducts(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      final url =
          'https://myshop-228a0-default-rtdb.firebaseio.com/products/$id.json';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
            'description': newProduct.description
          }));
      _items[productIndex] = newProduct;
      notifyListeners();
    } else {
      print('Something went wrong with the product id passed');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://myshop-228a0-default-rtdb.firebaseio.com/products/$id.json';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('could not delete product');
    }
    existingProduct = null;
  }
}
