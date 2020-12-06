import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> itemsList = [];
  final String authToken;
  final String userId;
  Products({this.itemsList, this.userId, this.authToken});

  List<Product> get items {
    return [...itemsList];
  }

  List<Product> get favoriteItems {
    return itemsList.where((product) => product.isFavorite).toList();
  }

  Product findById(id) {
    return itemsList.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://myshop-228a0-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if (extractedData == null) {
        return;
      }
      url =
          'https://myshop-228a0-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favResponse = await http.get(url);
      final favData = json.decode(favResponse.body);
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            imageUrl: prodData['imageUrl'],
            isFavorite: favData == null ? false : favData[prodId] ?? false,
            price: prodData['price']));
      });
      itemsList = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProducts(Product product) async {
    final url =
        'https://myshop-228a0-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'isFavorite': product.isFavorite,
            'imageUrl': product.imageUrl,
            'creatorId': userId,
          }));

      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price);
      itemsList.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProducts(String id, Product newProduct) async {
    final productIndex = itemsList.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      final url =
          'https://myshop-228a0-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
            'description': newProduct.description
          }));
      itemsList[productIndex] = newProduct;
      notifyListeners();
    } else {
      print('Something went wrong with the product id passed');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://myshop-228a0-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = itemsList.indexWhere((prod) => prod.id == id);
    var existingProduct = itemsList[existingProductIndex];
    itemsList.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      itemsList.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('could not delete product');
    }
    existingProduct = null;
  }
}
