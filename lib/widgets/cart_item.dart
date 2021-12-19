import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String prodId;
  final String title;
  final double price;
  final int quantity;

  CartItem(
     this.id,
     this.prodId,
     this.title,
     this.price,
      this.quantity);

  @override
  Widget build(BuildContext context) {

    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      onDismissed:(direction){
        Provider.of<Cart>(context,listen: false).removeItem(prodId);
      },
      background:Container(
        margin: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete,color: Colors.white,
        size: 30,
        ),
        alignment: Alignment.centerRight,
      ),
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: FittedBox(child: Text('\$${price}')),
          ),
          title: Text('$title'),
          subtitle: Text('Total: ${(price*quantity).toString()}'),
          trailing: Text('$quantity X'),

        ),
      ),
      confirmDismiss: (direction){
        return showDialog(context: context,
            builder: (context)=>AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you want to remove item from the cart?'),
            actions: [
              FlatButton(onPressed:()=> Navigator.of(context).pop(true), child: Text('Yes')),
              FlatButton(onPressed: ()=>Navigator.of(context).pop(false), child: Text('No'))
            ],));
      },
    );
  }
}
