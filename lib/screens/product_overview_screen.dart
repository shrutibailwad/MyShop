
import 'package:flutter/material.dart';
import '../widgets/add_drawer.dart';
import '../screens/cart_screen.dart';
import 'package:my_shop/widgets/badge.dart';
import 'package:provider/provider.dart';
import '../widgets/product_grid_view.dart';
import '../providers/cart.dart';
import '../providers/products.dart';

enum filterdOptions{
 favorites,
  all
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
bool _showFavorites=false;
bool _init=true;
bool _isLoading=false;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
  if(_init){
    setState(() {
      _isLoading=true;
    });
    Provider.of<Products>(context).fetchAndSetProducts().then((_) {
      setState(() {
        _isLoading=false;
      });
    });
  }
  _init=false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
      PopupMenuButton(itemBuilder: (_){
       return [
          PopupMenuItem(child: Text('Show only Favorites'),value: filterdOptions.favorites,),
          PopupMenuItem(child: Text('Show all'),value: filterdOptions.all,)
        ];
      },
      icon: Icon(Icons.more_vert),
      onSelected: (filterdOptions selectedValue){
        setState(() {
          if(selectedValue==filterdOptions.favorites){
            _showFavorites=true;
          }
          else{
            _showFavorites=false;
          }
        });

      },),
         Consumer<Cart>(builder: (_,Cart,ch)=>Badge(child: ch,
    value: Cart.itemsCount.toString()),
    child:IconButton(icon: Icon(Icons.shopping_cart), onPressed:() {
      Navigator.of(context).pushNamed(CartScreen.routeName);
    }) )
        ],

      ),
      drawer: AddDrawer(),
      body:_isLoading?Center(child: CircularProgressIndicator()) :ProductGridView(_showFavorites),
    );
  }
}


