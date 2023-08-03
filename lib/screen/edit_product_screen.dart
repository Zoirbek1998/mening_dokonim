import 'package:flutter/material.dart';
import 'package:mening_dokonim/models/product.dart';
import 'package:mening_dokonim/providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);

  static const routeName = "/edit-product-screen";

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _form = GlobalKey<FormState>();
  final _formImage = GlobalKey<FormState>();

  var _product = Product(
    id: "",
    title: '',
    description: '',
    price: 0.0,
    imageUrl: '',
  );

  var _hasImage = true;
  var _init = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    if (_init) {
      final productId = ModalRoute.of(context)!.settings.arguments;

      if (productId != null) {
        final _editingProduct =
            Provider.of<Products>(context).finById(productId as String);
        _product = _editingProduct;
      }
    }
    _init = false;
  }

  // final _priceFocus = FocusNode();

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   _priceFocus.dispose();
  // }

  void _showImageDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Upload Image URL"),
            content: Form(
              key: _formImage,
              child: TextFormField(
                initialValue: _product.imageUrl,
                decoration: const InputDecoration(
                  labelText: "Rasim URL",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter image URL.";
                  } else if (!value.startsWith("http")) {
                    return "Please enter the correct image URL.";
                  }
                  return null;
                },
                onSaved: ((newValue) {
                  _product = Product(
                      id: _product.id,
                      title: _product.title,
                      description: _product.description,
                      price: _product.price,
                      imageUrl: newValue!);
                }),
                keyboardType: TextInputType.url,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("CANCELLATION"),
              ),
              ElevatedButton(
                onPressed: _saveImageForm,
                child: const Text("SAVE "),
              ),
            ],
          );
        });
  }

  void _saveImageForm() {
    final isValid = _formImage.currentState!.validate();
    _formImage.currentState!.save();

    if (isValid) {
      setState(() {
        _hasImage = true;
      });
      Navigator.of(context).pop();
    }
  }

  Future<void> _saveForm() async {
    FocusScope.of(context).unfocus();
    final isValidate = _form.currentState!.validate();
    setState(() {
      _hasImage = _product.imageUrl.isNotEmpty;
    });

    if (isValidate && _hasImage) {
      _form.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      if (_product.id.isEmpty) {
        try {
          await Provider.of<Products>(context, listen: false)
              .addProduct(_product);
        } catch (error) {
          await showDialog<Null>(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: const Text("Error!"),
                  content:
                      const Text("There was an error adding a product"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text("Okay"),
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
          await showDialog<Null>(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: const Text("Error!"),
                  content: const Text(
                      "An error occurred while changing the product"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text("Okay"),
                    ),
                  ],
                );
              });
        }
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Add Product"),
        actions: [
          IconButton(onPressed: _saveForm, icon: const Icon(Icons.save))
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Form(
                  key: _form,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: _product.title,
                          decoration: const InputDecoration(
                            labelText: "Name",
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (newValue) {
                            _product = Product(
                                id: _product.id,
                                title: newValue!,
                                description: _product.description,
                                price: _product.price,
                                imageUrl: _product.imageUrl);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a product name.";
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          // onFieldSubmitted: (_) {
                          //   FocusScope.of(context).requestFocus(_priceFocus);
                          // },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          initialValue: _product.price.toStringAsFixed(2),
                          decoration: const InputDecoration(
                            labelText: "Cost",
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a product name.";
                            } else if (double.tryParse(value) == null) {
                              return "Please enter a valid price";
                            } else if (double.parse(value) < 0) {
                              return "Product price must be greater than 0";
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _product = Product(
                                id: _product.id,
                                title: _product.title,
                                description: _product.description,
                                price: double.parse(newValue!),
                                imageUrl: _product.imageUrl);
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          initialValue: _product.description,
                          decoration: const InputDecoration(
                            labelText: "Additional Information",
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                          ),
                          maxLines: 5,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter the product price.";
                            } else if (value.length < 10) {
                              return "Please enter details";
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _product = Product(
                                id: _product.id,
                                title: _product.title,
                                description: newValue!,
                                price: _product.price,
                                imageUrl: _product.imageUrl);
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Card(
                          margin: const EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: _hasImage
                                      ? Colors.grey
                                      : Theme.of(context).errorColor),
                              borderRadius: BorderRadius.circular(5)),
                          child: InkWell(
                            onTap: () {
                              _showImageDialog(context);
                            },
                            splashColor:
                                Theme.of(context).primaryColor.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(5),
                            highlightColor: Colors.transparent,
                            child: Container(
                              height: 180,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: _product.imageUrl.isEmpty
                                  ? Text(
                                      "Copy the main image URL!",
                                      style: TextStyle(
                                          color: _hasImage
                                              ? Colors.black
                                              : Theme.of(context).errorColor),
                                    )
                                  : Image.network(
                                      _product.imageUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
    );
  }
}
