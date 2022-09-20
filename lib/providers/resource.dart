import 'package:flutter/material.dart';

import '../models/ResourceCategory.dart';

class Resource with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final ResourceCategory rc;
  bool isFavorite;

  //contructor
  Resource(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false,
      this.rc});

  void toggleFavoriteStatus() {
    // if (isFavorite)
    //   print("Favorite");
    // else
    //   print("Not fav");
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
