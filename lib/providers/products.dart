import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/http_exeption.dart';
import '../models/product.dart';

class Products with ChangeNotifier {
  List<Product> _list = [
    // Product(
    //     id: "p1",
    //     title: "Iphon 5C",
    //     description:
    //         "SalomSalomSalomSalomSalomSalomSalomSalomSalomSalomSalomSalom",
    //     price: 2000,
    //     imageUrl:
    //         "https://static.auction.ru/offer_images/2016/11/15/06/big/T/tjTRWsmPEqk/apple_iphone_5c_8_16_32gb_ios_wifi_gps_original.jpg"),
    // Product(
    //     id: "p2",
    //     title: "Samsung 20 Ultra",
    //     description:
    //         "SalomSalomSalomSalomSalomSalomSalomSalomSalomSalomSalomSalom",
    //     price: 156.98,
    //     imageUrl:
    //         "https://wishmaster.me/upload/iblock/0a4/0a40b70894a056d3ee0551487979def8.jpg"),
    // Product(
    //     id: "p3",
    //     title: "Iphone 13",
    //     description:
    //         "SalomSalomSalomSalomSalomSalomSalomSalomSalomSalomSalomSalom",
    //     price: 134.9,
    //     imageUrl:
    //         "https://avatars.mds.yandex.net/i?id=f93ed7a58f42eb53e8a5c181172aa4ed-6625064-images-thumbs&ref=rim&n=33&w=300&h=300"),
    // Product(
    //     id: "p4",
    //     title: "Samsung A52",
    //     description:
    //         "SalomSalomSalomSalomSalomSalomSalomSalomSalomSalomSalomSalom",
    //     price: 120.7,
    //     imageUrl:
    //         "https://on-smart.ru/upload/iblock/f2c/scnc7d61p7rqpf0i63k5zhnqzhz5cefi.jpg"),
    // Product(
    //     id: "p5",
    //     title: "Apple Ipad",
    //     description:
    //         "SalomSalomSalomSalomSalomSalomSalomSalomSalomSalomSalomSalom",
    //     price: 140.5,
    //     imageUrl:
    //         "https://diamondelectric.ru/images/4132/4131125/apple_planshet_apple_ipad_air_109_2020_wifi__cellular_64gb_space_1.jpg"),
  ];

  String? _authToken;
  String? _userId;

  void setParams(String? authToken, String? userId) {
    _authToken = authToken;
    _userId = userId;
  }

  List<Product> get list {
    return [..._list];
  }

  List<Product> get favorites {
    return _list.where((product) => product.isFavorites).toList();
  }

  Future<void> getProductFromFirebase([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$_userId"' : '';

    final url = Uri.parse(
        'https://home-work-4b668-default-rtdb.firebaseio.com/product.json?auth=$_authToken&$filterString');

    try {
      final response = await http.get(url);
      if (jsonDecode(response.body) != null) {
        final favoriteUrl = Uri.parse(
            'https://home-work-4b668-default-rtdb.firebaseio.com/userFavorites/$_userId.json?auth=$_authToken');

        final favoritesResponse = await http.get(favoriteUrl);
        final favoritesData = jsonDecode(favoritesResponse.body);
        final List<Product> loadedProduct = [];
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        data.forEach((productId, productData) {
          loadedProduct.add(Product(
            id: productId,
            title: productData["title"],
            description: productData["description"],
            price: productData["price"],
            imageUrl: productData["imageUrl"],
            isFavorites: favoritesData == null
                ? false
                : favoritesData[productId] ?? null,
          ));
        });
        _list = loadedProduct;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://home-work-4b668-default-rtdb.firebaseio.com/product.json?auth=$_authToken');

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            "title": product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            "creatorId": _userId,
            // 'isFavorites': product.isFavorites
          },
        ),
      );

      final id = (jsonDecode(response.body) as Map<String, dynamic>)['name'];
      final newProduct = Product(
        id: id,
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _list.add(newProduct);
      notifyListeners();
    } catch (error) {
      // throw error;
      rethrow;
    }
  }

  Future<void> updateProduct(Product upadateProduct) async {
    final productIndex = _list.indexWhere(
      (product) => product.id == upadateProduct.id,
    );

    if (productIndex >= 0) {
      final url = Uri.parse(
          'https://home-work-4b668-default-rtdb.firebaseio.com/product/${upadateProduct.id}.json?auth=$_authToken');

      try {
        await http.patch(
          url,
          body: jsonEncode(
            {
              'title': upadateProduct.title,
              'description': upadateProduct.description,
              'price': upadateProduct.price,
              'imageUrl': upadateProduct.imageUrl,
            },
          ),
        );
        _list[productIndex] = upadateProduct;
        notifyListeners();
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://home-work-4b668-default-rtdb.firebaseio.com/product/$id.json?auth=$_authToken');

    try {
      var deletingProduct = _list.firstWhere((product) => product.id == id);
      final productIndex = _list.indexWhere((product) => product.id == id);
      _list.removeWhere((product) => product.id == id);
      final response = await http.delete(url);

      if (response.statusCode >= 400) {
        _list.insert(productIndex, deletingProduct);
        notifyListeners();
        throw HttpException("Kechirasiz o'chirishda hatolik");
      }
    } catch (e) {
      rethrow;
    }
  }

  Product finById(String productId) {
    return _list.firstWhere((pro) => pro.id == productId);
  }
}
