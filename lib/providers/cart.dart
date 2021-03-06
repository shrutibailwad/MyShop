import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class CartItem{
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.quantity});
}


class Cart with ChangeNotifier{
  Map<String,CartItem> _items={};

 Map<String,CartItem> get items{
    return {..._items};
 }

 int get itemsCount{
   return _items.length;
 }

 void removeItem(String prodId){
   _items.remove(prodId);
   notifyListeners();
 }
 double get totalCartPrice{
   var total=0.0;
    _items.forEach((key, cartItem) {
      total+= cartItem.price*cartItem.quantity;});
    return total;
 }
 void addItem(String prodId,String title,double price){
  if(_items.containsKey(prodId)){
    _items.update(prodId, (existingProd) => CartItem(id: existingProd.id,
    title: existingProd.title,
    price: existingProd.price,
    quantity: existingProd.quantity+1));
  }
  else
    {
      _items.putIfAbsent(prodId, () => CartItem(id: DateTime.now().toString(),
      title: title,
      price: price,
        quantity: 1,
      ));

    }
  notifyListeners();
 }

 void removeSingleItem(String prodId){
   if(!_items.containsKey(prodId)){
     return;
   }
   if(_items[prodId].quantity>1)
     {
       _items.update(prodId, (existingProd) => CartItem(id: existingProd.id,
           title: existingProd.title,
           price: existingProd.price,
           quantity: existingProd.quantity-1));
     }
   else{
     _items.remove(prodId);
   }
    notifyListeners();
 }
  void clear(){
    _items={};
    notifyListeners();
  }
  }
