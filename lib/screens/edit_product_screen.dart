import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  final String _productId;
  const EditProductScreen(this._productId, {super.key});
  static const routeName = '/edit';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  var _product =
      Product(id: '', title: '', description: '', price: 0, imgUrl: '');
  final _formKey = GlobalKey<FormState>();
  final _formImageKey = GlobalKey<FormState>();
  var _init = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ignore: unnecessary_null_comparison
    if (widget._productId !=null) {
      if (_init) {
        final productId = widget._productId;
        if (widget._productId.isNotEmpty) {
          final editingProduct =
              Provider.of<Products>(context).findById(productId);
          _product = editingProduct;
        } else {
          _init = false;
        }
      }
    } else {
      _init = false;
    }
  }


  _showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Photo Url!'),
          content: Form(
              key: _formImageKey,
              child: TextFormField(
                initialValue:
                    _product.imgUrl.isNotEmpty ? _product.imgUrl : null,
                decoration: const InputDecoration(
                  labelText: 'Photo URL',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
                onSaved: (img) {
                  _product = Product(
                      id: _product.id,
                      title: _product.title,
                      description: _product.description,
                      price: _product.price,
                      imgUrl: img!);
                },
                validator: (img) {
                  if (img == null || img.isEmpty) {
                    return 'Please enter a photo URL';
                  } else if (!img.startsWith('http')) {
                    return "Please Enter correct Image Url";
                  }
                  return null;
                },
              )),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color.fromARGB(255, 6, 38, 65),
                      ),
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 6, 38, 65),
                    ),
                    onPressed: _saveImageForm,
                    child: const Text('Save')),
              ],
            )
          ],
        );
      },
    );
  }

 Future<void> _saveForm() async {
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState!.validate();
    if (isValid ) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      if (_product.id.isEmpty) {
        try {
          await Provider.of<Products>(context, listen: false)
              .addProduct(_product);
        } catch (error) {
          // ignore: prefer_void_to_null
          await showDialog<Null>(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: const Text('Xatolik!'),
                  content:
                      const Text('Mahsulot qo\'shishda xatolik sodir bo\'ldi.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Okay'),
                    ),
                  ],
                );
              });
        }
      } else {
        try {
          await Provider.of<Products>(context, listen: false)
              .updateProduct(_product);
        } catch (e) {
          await showDialog<void>(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: const Text('Xatolik!'),
                  content:
                      const Text('Mahsulot qo\'shishda xatolik sodir bo\'ldi.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Okay'),
                    ),
                  ],
                );
              });
        }
      }

      setState(() {
        _isLoading = false;
      });
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }
  }

  void _saveImageForm() {
    final isValid = _formImageKey.currentState!.validate();
    if (isValid) {
      _formImageKey.currentState!.save();
    }

  setState(() {
    
  });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 6, 38, 65),
        centerTitle: true,
        title: const Text('Product Add'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body:_isLoading? const Center(child: CircularProgressIndicator(),): GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: _product.title,
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product name';
                    }
                    return null;
                  },
                  onSaved: (title) {
                    _product = Product(
                        id: _product.id,
                        title: title!,
                        description: _product.description,
                        price: _product.price,
                        imgUrl: _product.imgUrl);
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue:
                      _init == false ? null : _product.price.toStringAsFixed(1),
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  onSaved: (price) {
                    _product = Product(
                        id: _product.id,
                        title: _product.title,
                        description: _product.description,
                        price: double.parse(price!),
                        imgUrl: _product.imgUrl);
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _product.description,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onSaved: (des) {
                    _product = Product(
                        id: _product.id,
                        title: _product.title,
                        description: des!,
                        price: _product.price,
                        imgUrl: _product.imgUrl);
                  },
                ),
                const SizedBox(height: 16),
                Card(
                  margin: const EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(color: Colors.grey)),
                  child: InkWell(
                    splashColor:
                        const Color.fromARGB(255, 6, 38, 65).withOpacity(0.6),
                    borderRadius: BorderRadius.circular(5),
                    onTap: () => _showImageDialog(context),
                    child: Container(
                        height: 180,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: _product.imgUrl.isEmpty
                            ? const Text('Enter main picture URL!')
                            : Image.network(
                                _product.imgUrl,
                                width: double.infinity,
                              )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
