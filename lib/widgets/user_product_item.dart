import 'package:flutter/material.dart';
import '../providers/products.dart';
import '../screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(this.id,this.title,this.imageUrl);
  @override
  Widget build(BuildContext context) {
   var scaffold=Scaffold.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title,style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),),
      trailing: Container(
        width: 180,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FlatButton(onPressed: (){
              Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: id );
            },
                child: Icon(Icons.edit)),
            FlatButton(onPressed: () async{
              try{
                await Provider.of<Products>(context,listen: false).deleteProduct(id);
              }
            catch(error){
              scaffold.showSnackBar(const SnackBar(content: Text('Could not delete product!!')));
            }

            },
                child: Icon(Icons.delete,
                color: Theme.of(context).errorColor,))
          ],
        ),
      ),
    );
  }
}
