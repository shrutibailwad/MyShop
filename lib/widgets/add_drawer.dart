import 'package:flutter/material.dart';
import '../screens/order_screen.dart';
import '../screens/user_product_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'dart:convert';

class AddDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello Friend!!!'),
            automaticallyImplyLeading: false,

          ),
          SizedBox(height: 20,),
          ListTile(
            leading: Icon(Icons.shopping_cart,size: 30,
            color: Theme.of(context).accentColor,),
            title: Text('Shop',style: TextStyle(fontSize: 20),),
            onTap:()=> Navigator.of(context).pushReplacementNamed('/'),
          ),
          SizedBox(height: 20,),
          ListTile(
            leading: Icon(Icons.payment,size: 30,
            color: Theme.of(context).accentColor,),
            title: Text('Order',style: TextStyle(
              fontSize: 20,
            ),),
            onTap:()=> Navigator.of(context).pushReplacementNamed(OrderScreen.routeName),
          ),
          SizedBox(height: 20,),
          ListTile(
            leading: Icon(Icons.edit,size: 30,
              color: Theme.of(context).accentColor,),
            title: Text('Manage Products',style: TextStyle(
              fontSize: 20,
            ),),
            onTap:()=> Navigator.of(context).pushReplacementNamed(UserProductScreen.routeName),
          ),
          SizedBox(height: 20,),
          ListTile(
            leading: Icon(Icons.logout,size: 30,
              color: Theme.of(context).accentColor,),
            title: Text('Logout',style: TextStyle(
              fontSize: 20,
            ),),
            onTap:(){
              Provider.of<Auth>(context,listen: false).logout();
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');

            }
          )
        ],

      ),
    );
  }
}
