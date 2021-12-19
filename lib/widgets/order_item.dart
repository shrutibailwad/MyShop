import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders.dart' as ord;
import 'dart:math';


class OrderItem extends StatefulWidget {
 final ord.OrderItem order;

 OrderItem(
     this.order
     );

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _isExpanded=false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height:_isExpanded?min(widget.order.products.length*40.0+110,200):95,
      child: Card(
        elevation: 4,
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.order.total}'),
              subtitle: Text(DateFormat('EEE, M/d/y').format(widget.order.date)),
              trailing: IconButton(icon:Icon(_isExpanded?Icons.expand_more:Icons.expand_less),
              onPressed: (){
                setState(() {
                  _isExpanded=!_isExpanded;
                });
              },),
            ),

              AnimatedContainer(padding: EdgeInsets.all(10),
                duration: Duration(milliseconds: 300),
                height: _isExpanded?min(widget.order.products.length*40.0+10,100):0,
                child: ListView(
                  children: widget.order.products.map((prod) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(prod.title,style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),),
                      Column(
                        children: [
                          Text('${prod.quantity} * ${prod.price}')
                        ],
                      )
                    ],
                  )).toList()
                ),
              )

          ],
        ),
      ),
    );
  }
}
