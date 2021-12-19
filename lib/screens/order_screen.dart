import 'package:flutter/material.dart';
import 'package:my_shop/widgets/order_item.dart';
import '../providers/orders.dart' show Orders;
import 'package:provider/provider.dart';
import '../widgets/order_item.dart';
import '../widgets/add_drawer.dart';

class OrderScreen extends StatelessWidget {
  static const routeName='/orders';


  // bool _isLoading=false;
  // @override
  // void initState() {
  //   Future.delayed(Duration.zero).then((_) async{
  //     setState(() {
  //       _isLoading=true;
  //     });
  //     await Provider.of<Orders>(context,listen: false).fetchAndSetOrders();
  //     setState(() {
  //       _isLoading=false;
  //     });
  //   });
  //   // TODO: implement initState
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders!'),
      ),

      body:FutureBuilder(future:Provider.of<Orders>(context,listen: false).fetchAndSetOrders() ,
        builder: (ctx,dataSnapshot){
        if(dataSnapshot.connectionState==ConnectionState.waiting){
         return Center(child: CircularProgressIndicator(),);
        }
        else{
          if(dataSnapshot.error!=null){
            //handling error here
            return Center(child: Text('error occured!!'),);
          }
          else{
           return Consumer<Orders>(builder: (ctx,orderData,child){
             return ListView.builder(itemCount:orderData.items.length ,
                 itemBuilder: (context,i)=>OrderItem(orderData.items[i]));
           });
          }
        }
      },
    ),
      drawer: AddDrawer(),
    );
  }
}
