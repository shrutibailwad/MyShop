import 'dart:convert';

import 'package:flutter/material.dart';
import '../providers/product.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';


class Products with ChangeNotifier{
   List<Product> _items=[
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //   'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //   'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //   'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //   'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

   final String authToken;
   final String userId;
  Products(this.authToken,this.userId,this._items);

 List<Product> get items{
   return [..._items];
 }

 List<Product> get favoriteItems{
   return _items.where((prod) => prod.isFavorite).toList();
 }

 Future<void> fetchAndSetProducts([bool filterByUser=false]) async{
   String filterString=filterByUser?'orderBy="creatorId"&equalTo="$userId"':'';
     var url=Uri.parse('https://myshop-665d8-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken&$filterString');
     try{
       final response=await http.get(url);
     final expectedData=json.decode(response.body) as Map<String,dynamic>;
     print(expectedData);
     if(expectedData==null){
       return;
     }
     url=Uri.parse('https://myshop-665d8-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken');
     final favouriteResponse=await http.get(url);
     final favouriteData=jsonDecode(favouriteResponse.body);


     final List<Product> loadData=[];
     expectedData.forEach((prodId, prodData) {
       loadData.add(Product(
         id:prodId,
         title: prodData['title'],
         description: prodData['description'],
         price: prodData['price'],
         imageUrl: prodData['imageUrl'],
         isFavorite: favouriteData==null? false : favouriteData[prodId]?? false,
       ));

     });
     _items=loadData;
     notifyListeners();
   }
  catch(error){
     print(error);
     throw error;

  }
 }
 Future<void> add(Product product) async{
   try{
     final url=Uri.parse('https://myshop-665d8-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken');
     final response=await http.post(url,body:jsonEncode({
       'title': product.title,
       'description': product.description,
       'price': product.price,
       'imageUrl': product.imageUrl,
       'creatorId': userId,
     }));
     print(jsonDecode(response.body)['name']);
     var _editProduct=Product(

         id: jsonDecode(response.body)['name'],
         title: product.title,
         description: product.description,
         price: product.price,
         imageUrl: product.imageUrl,
       isFavorite: product.isFavorite
     );
     _items.add(_editProduct);
     notifyListeners();

   }
   catch(error){
     print(error);
     throw error;
   }

 }

 void updateProduct(String id,Product newProduct){
  final index=_items.indexWhere((prod) => prod.id==id);
  if(index>=0){
    final url=Uri.parse('https://myshop-665d8-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken');
    http.patch(url,body: jsonEncode({
      'title':newProduct.title,
      'description':newProduct.description,
      'price':newProduct.price,
      'imageUrl':newProduct.imageUrl
    }));
    _items[index]=newProduct;
    notifyListeners();
  }
  else{
    print('index not found');
  }

 }
 Product findById(String Id){
   return _items.firstWhere((prod) => prod.id==Id);
 }

 Future<void> deleteProduct(String id) async{
   final url=Uri.parse('https://myshop-665d8-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken');

   var index=_items.indexWhere((prod) => prod.id==id);
   var product=_items[index];
   _items.removeAt(index);
   notifyListeners();

     var response= await http.delete(url);
     print(response);
     print(response.statusCode);
     if(response.statusCode>=400){
       _items.insert(index, product);
       HttpException('Could not delete product!!');
       notifyListeners();
     }
     product=null;
     notifyListeners();
 }
}
