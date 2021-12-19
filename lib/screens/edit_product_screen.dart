import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editProduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');
  var _initValue={
    'title':'',
    'description':'',
    'price':0,
    'imageUrl':''
  };
  var _init=true;
  var _isLoading=false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(() {
      updateUrl();
    });
    // TODO: implement initState
    super.initState();
  }
@override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
  if(_init){
    var _productId=ModalRoute.of(context).settings.arguments as String;
    if(_productId!=null){
      _editProduct=Provider.of<Products>(context,listen: false).findById(_productId);
      _initValue={'title':_editProduct.title,'description':_editProduct.description,
        'price':_editProduct.price,'imageUrl':''
      };
      _imageUrlController.text=_editProduct.imageUrl.toString();
    }

  }
    _init=false;
    super.didChangeDependencies();
  }
  void updateUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if(_imageUrlController.text.startsWith('http') || (_imageUrlController.text.startsWith('https'))){
        if(_imageUrlController.text.endsWith('jpeg') || (_imageUrlController.text.endsWith('jpg') ) || _imageUrlController.text.endsWith('png') ){
          setState(() {

          });
        }
      }

    }
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(() {
      updateUrl();
    });
    _descFocusNode.dispose();
    _priceFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  Future<void> _saveForm() async {
    setState(() {
      _isLoading=true;
    });
    final isValid=_form.currentState.validate();
    if(!isValid){
      return;
    }
    _form.currentState.save();
    if(_editProduct.id!=null){
      print('id'+_editProduct.id);
      await Provider.of<Products>(context,listen: false).updateProduct(_editProduct.id, _editProduct);

    }
    else{
      try{
        await Provider.of<Products>(context,listen: false).add(_editProduct);
      }
     catch(error){
       await showDialog(context: context, builder: (ctx)=>AlertDialog(
         title: Text('Error Ocuured!'),

         content: Text('Something went wrong'),
         actions: [
           FlatButton(onPressed: (){
             Navigator.of(ctx).pop();
           }, child: Text('OK')),
         ],
       ));

     }
    }
    setState(() {
      _isLoading=false;
    });
    Navigator.of(context).pop();
    print(_editProduct.title);
    print(_editProduct.price);
    print(_editProduct.description);
    print(_editProduct.imageUrl);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product Details'),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveForm)],
      ),
      body: _isLoading?Center(child:CircularProgressIndicator()):Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
            key: _form,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  initialValue: _initValue['title'],
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  onSaved: (value) {
                    print('title' + value);
                    _editProduct = Product(
                        title: value,
                        description: _editProduct.description,
                        price: _editProduct.price,
                        imageUrl: _editProduct.imageUrl,
                        id: _editProduct.id,
                        isFavorite: _editProduct.isFavorite);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a title!';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: _initValue['price'].toString(),
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descFocusNode);
                  },
                  onSaved: (value) {
                    print('price' + value);
                    _editProduct = Product(
                        id: _editProduct.id,
                        isFavorite: _editProduct.isFavorite,
                        title: _editProduct.title,
                        description: _editProduct.description,
                        price: double.parse(value),
                        imageUrl: _editProduct.imageUrl);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a Price!';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a number!';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Please enter number greater than zero';
                    }
                    return null;
                  },
                ),
                TextFormField(
                    initialValue: _initValue['description'],
                    decoration: InputDecoration(
                      labelText: 'Description',
                    ),
                    textInputAction: TextInputAction.next,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    focusNode: _descFocusNode,
                    onSaved: (value) {
                      print('description' + value);
                      _editProduct = Product(
                          id: _editProduct.id,
                          isFavorite: _editProduct.isFavorite,
                          title: _editProduct.title,
                          description: value,
                          price: _editProduct.price,
                          imageUrl: _editProduct.imageUrl);
                    },
                validator: (value){
                      if(value.isEmpty){
                        return 'Please enter a description!';
                      }
                      if(value.length<10){
                        return 'Please enter minimum 10 characters!';
                      }
                      return null;
                },),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        )),
                        margin: EdgeInsets.only(top: 10, right: 8),
                        child: _imageUrlController.text.isEmpty
                            ? Text('Ener URL')
                            : FittedBox(
                                child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ))),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Image URL',
                        ),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        onEditingComplete: () {
                          setState(() {});
                        },
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                        onSaved: (value) {
                          print('imageURL' + value);
                          _editProduct = Product(
                              id: _editProduct.id,
                              isFavorite: _editProduct.isFavorite,
                              title: _editProduct.title,
                              description: _editProduct.description,
                              price: _editProduct.price,
                              imageUrl: value);
                        },
                        validator: (value){
                          if(value.isEmpty){
                            return 'Please enter image url!';
                            
                          }
                          if(!value.startsWith('http' ) && (!value.startsWith('https'))){
                            return 'Please enter a valid URL!';
                          }
                          if(!value.endsWith('jpeg') && (!value.endsWith('jpg') && (!value.endsWith('png')))){
                            return 'Please enter a valid URL!';
                          }
                          return null;
                        },
                      ),
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }
}
