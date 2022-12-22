import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorites;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorites = false});

  Future<void> toggleFavirite(String token, String userId) async {
    var oldFavorite = isFavorites;

    isFavorites = !isFavorites;
    notifyListeners();

    final url = Uri.parse(
        'https://home-work-4b668-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token');

    try {
      final response = await http.put(
        url,
        body: jsonEncode(isFavorites),
      );

      if (response.statusCode >= 400) {
        isFavorites = oldFavorite;
        notifyListeners();
      }
    } catch (e) {
      isFavorites = oldFavorite;
      notifyListeners();
    }
  }
}
