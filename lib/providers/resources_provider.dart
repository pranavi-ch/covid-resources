//properties are merged
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/ResourceCategory.dart';
import 'package:flutter_complete_guide/providers/resource.dart';
import 'package:http/http.dart' as http;

class Resources with ChangeNotifier {
  //list of resources
  List<Resource> _items = [];

  final String authToken;
  final String userId;

  Resources(this.authToken, this.userId, this._items);
  //final String authToken;
  //constructor

  List<Resource> get items {
    return [..._items];
  }

  List<Resource> get markedItems {
    return _items.where((resItem) => resItem.isFavorite).toList();
  }

  Resource findById(String id) {
    return _items.firstWhere((resource) => resource.id == id);
  }

  Future<void> fetchAndSetResources([bool filterByUser = true]) async {
    final filterString =
        filterByUser ? 'orderBy="uploaderId"&equalTo="$userId"' : '';

    final url =
        'https://covid-resources-app-def30-default-rtdb.asia-southeast1.firebasedatabase.app/resources.json?auth=$authToken&$filterString"';
    final response = await http.get(Uri.parse(url));
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    //temp list to hold retrieved resources from the server
    final List<Resource> loadedResources = [];
    extractedData.forEach((resId, resData) {
      loadedResources.add(Resource(
        id: resId,
        title: resData['title'],
        description: resData['description'],
        price: resData['price'],
        imageUrl: resData['imageUrl'],
      ));
    });
    _items = loadedResources;
    notifyListeners();
  }

  void addResource(Resource resource) {
    final url =
        'https://covid-resources-app-def30-default-rtdb.asia-southeast1.firebasedatabase.app/resources.json?auth=$authToken';
    http
        .post(Uri.parse(url),
            body: json.encode({
              'title': resource.title,
              'description': resource.description,
              'price': resource.price,
              'imageUrl': resource.imageUrl,
              'uploaderId': userId,
            }))
        .then((response) {
      print(json.decode(response.body));
      final newResource = Resource(
          title: resource.title,
          description: resource.description,
          imageUrl: resource.imageUrl,
          price: resource.price,
          id: json.decode(response.body)['name']);
      _items.insert(0, newResource);
      notifyListeners();
    });
  }

  Future<void> deleteResource(String id) async {
    var url =
        'https://covid-resources-app-def30-default-rtdb.asia-southeast1.firebasedatabase.app/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
