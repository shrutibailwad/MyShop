import 'package:flutter/material.dart';
import 'package:my_shop/providers/product.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';


class ProductDetailScreen extends StatelessWidget {
  static const routeName='/product-detail';
  @override
  Widget build(BuildContext context) {
    final productId=ModalRoute.of(context).settings.arguments as String;
    final loadedProduct=Provider.of<Products>(context).findById(productId);

    return Scaffold(
      // appBar: AppBar(
      //   title:
      // ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title) ,
              background: Hero(tag:productId,child: Image.network(loadedProduct.imageUrl,fit: BoxFit.cover,)),
            ),
          ),
          SliverList(delegate: SliverChildListDelegate([
            SizedBox(
              height: 20,
            ),
            Text('Price : \$${loadedProduct.price}',
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            textAlign: TextAlign.center),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              child: Text('${loadedProduct.description}',
                softWrap: true,
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,),
            ),
            SizedBox(height: 800,)
          ]))
        ],

      )
    );
  }
}