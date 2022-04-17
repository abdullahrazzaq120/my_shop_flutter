import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String? id;
  final String? title;
  final String? description;
  final double? price;
  final String? imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
  });

  void toggleFavouriteStatus() async {
    final oldFavourite = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url =
        'https://myshopflutter-3d23b-default-rtdb.firebaseio.com/products/$id.json';
    try {
      final response = await http.patch(
        Uri.parse(url),
        body: json.encode({
          'isFavourite': isFavourite,
        }),
      );
      if (response.statusCode >= 400) {
        isFavourite = oldFavourite;
        notifyListeners();
      }
    } catch (error) {
      isFavourite = oldFavourite;
      notifyListeners();
    }
  }
}
