import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite=false});

  Future<void> toggleFavorite(String token,String userId) async{
    var oldStatus=isFavorite;
    isFavorite=!isFavorite;
    notifyListeners();
    final url=Uri.parse('https://myshop-665d8-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId/$id.json?auth=$token');
    try{
      var response=await http.put(url,body: jsonEncode(
        isFavorite
      ));
      if(response.statusCode>=400){
        isFavorite=oldStatus;
        notifyListeners();
      }
    }
    catch(error){
      isFavorite=oldStatus;
      notifyListeners();
    }


  }

}
