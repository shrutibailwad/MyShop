import 'package:flutter/material.dart';
import '../providers/cart.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class OrderItem{
  final String id;
  final double total;
  final DateTime date;
  List<CartItem> products;

  OrderItem({
    @required this.id,
  @required this.total,
  @required this.date,
  @required this.products});
}



class Orders with ChangeNotifier{
  List<OrderItem> _items=[];
  final String authToken;
  final String userId;

  Orders(this.authToken,this.userId,this._items);

  List<OrderItem> get items{
    return [..._items];
  }
  Future<void> addOrder(List<CartItem> cartItems,double amount) async{
    var timestamp=DateTime.now();
    final url=Uri.parse('https://myshop-665d8-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken');
    try{
      var response=await http.post(url,body: jsonEncode({
        'total': amount,
        'date':timestamp.toIso8601String(),
        'products': cartItems.map((cp)=>{
          'id':cp.id,
          'title':cp.title,
          'price':cp.price,
          'quantity':cp.quantity
        }).toList()
      }));
      _items.insert(0, OrderItem(id: jsonDecode(response.body)['name'],
          total: amount, date: timestamp, products: cartItems));
      notifyListeners();
    }
   catch(error){
      throw error;
   }
   
  }

Future<void> fetchAndSetOrders() async{
  final url=Uri.parse('https://myshop-665d8-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken');
  var response=await http.get(url);
  List<OrderItem> loadData=[];
  print(jsonDecode(response.body));
  var expectedData=jsonDecode(response.body) as Map<String,dynamic>;
  if(expectedData==null){
    return;
  }
  expectedData.forEach((orderId, orderData) {
    loadData.add(OrderItem(
        id: orderId,
        total: orderData['total'],
        date: DateTime.parse(orderData['date']),
        products: (orderData['products'] as List<dynamic>).map((element) => CartItem(id: element['id'],
            title: element['title'], price: element['price'], quantity: element['quantity'])).toList()));
  });
  _items=loadData.reversed.toList();
  notifyListeners();
}
}