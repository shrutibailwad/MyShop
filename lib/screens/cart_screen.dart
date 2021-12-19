import 'package:flutter/material.dart';
import 'package:my_shop/providers/orders.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';

class CartScreen extends StatefulWidget {
  static const routeName='/cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cart=Provider.of<Cart>(context);
   var _isLoading=false;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text('Total',style:TextStyle(
                    fontSize: 20,
                  ),),
                  Spacer(),
                  Chip(label: Text('\$${cart.totalCartPrice.toStringAsFixed(2)}',style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryTextTheme.title.color,
                  ),),
                  backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(onPressed:(cart.totalCartPrice<=0 || _isLoading)?null: () async{
                    setState(() {
                      _isLoading=true;
                    });
                    await Provider.of<Orders>(context,listen: false).addOrder(cart.items.values.toList(), cart.totalCartPrice);
                    setState(() {
                      _isLoading=false;
                    });
                    cart.clear();
                  }, child:_isLoading? Center(child: CircularProgressIndicator()): Text('Order Now',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                  ),),)
                ],
              ),
            )
            ),
          Expanded(
            child: ListView.builder(itemCount:cart.itemsCount,
                itemBuilder: (context,i)=>CartItem(
                cart.items.values.toList()[i].id,
                  cart.items.keys.toList()[i],
                  cart.items.values.toList()[i].title,
                  cart.items.values.toList()[i].price,
                  cart.items.values.toList()[i].quantity,)
    ),
          )
        ],
      ),

    );
  }
}
