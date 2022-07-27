import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/Product.dart';
import 'package:shop/providers/ProductsProvider.dart';

class EditProductPage extends StatefulWidget {
  const EditProductPage({
    Key ? key
  }): super(key: key);

  static
  const routeName = '/edit';

  @override
  State <EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State < EditProductPage > {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey < FormState > ();
  var _editingProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );
  var _initValue = {
    'id': '',
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _descriptionFocusNode.dispose();
    _priceFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    final modalRoute = ModalRoute.of(context);
    if (_isInit && modalRoute != null) {
      final modalSettings = modalRoute.settings;
      if (modalSettings.arguments != null) {
        final productId = modalSettings.arguments as String;
        if (productId != null) {
          _editingProduct = Provider.of < ProductsProvider > (context, listen: false).findIdProduct(productId);
          _initValue = {
            'title': _editingProduct.title,
            'price': _editingProduct.price.toString(),
            'description': _editingProduct.description,
            'imageUrl': '',
          };
          _imageUrlController.text = _editingProduct.imageUrl;
        }
      } else {
        _imageUrlController.text = '';
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') && !_imageUrlController.text.startsWith('https'))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() async {
    final isCurrentState = _form.currentState;
    if (isCurrentState != null) {
      final isValid = isCurrentState.validate();
      if (isValid) {
        isCurrentState.save();
        setState(() {
          _isLoading = true;
        });

        if (_editingProduct.id == '') {
          Provider.of<ProductsProvider>(context, listen: false).addProduct(_editingProduct)
            .then((_) {
                setState(() {
                  _isLoading = false;
                });
                Navigator.of(context).pop();
              })
            .catchError((error) {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(title: const Text('Произошла ошибка'),
                  content: Text(error.toString()),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: const Text('Закрыть')
                    )
                  ], ));
            });
        } else {
          Provider.of<ProductsProvider>(context, listen: false).updateProduct(_editingProduct.id, _editingProduct).then((value) {
              setState(() {
              _isLoading = false;
            });
            Navigator.of(context).pop();
          });
        }
      }
      return;
    }
    return;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавление продукта'),
          actions: [
            IconButton(
              onPressed: _saveForm,
              icon: const Icon(Icons.save))
          ],
      ),
      body: _isLoading ?
      const Center(child: CircularProgressIndicator()): Padding(
        padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
                  initialValue: _initValue['title'],
                  decoration: const InputDecoration(labelText: 'Название продукта'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                    validator: (value) {
                      if (value != null) {
                        if (value.isEmpty) {
                          return 'Введите название продукта';
                        }
                      }
                      return null;
                    },
                    onEditingComplete: () {
                      setState(() {});
                    },
                    onSaved: (value) {
                      if (value != null) {
                        _editingProduct = Product(
                          id: _editingProduct.id,
                          title: value,
                          description: _editingProduct.description,
                          price: _editingProduct.price,
                          imageUrl: _editingProduct.imageUrl,
                          isFavorite: _editingProduct.isFavorite
                        );
                      }
                    },
                ),
                TextFormField(
                  initialValue: _initValue['price'],
                  decoration: const InputDecoration(labelText: 'Цена'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _priceFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_descriptionFocusNode);
                    },
                    validator: (value) {
                      if (value != null) {
                        if (value.isEmpty) {
                          return 'Введите цену';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Введите корректную цену продукта';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Цена должна быть больше 0';
                        }
                      }
                      return null;
                    },
                    onEditingComplete: () {
                      setState(() {});
                    },
                    onSaved: (value) {
                      if (value != null) {
                        _editingProduct = Product(
                          id: _editingProduct.id,
                          title: _editingProduct.title,
                          description: _editingProduct.description,
                          price: double.parse(value),
                          imageUrl: _editingProduct.imageUrl,
                          isFavorite: _editingProduct.isFavorite
                        );
                      }
                    },
                ),
                TextFormField(
                  initialValue: _initValue['description'],
                  decoration: const InputDecoration(labelText: 'Описание продукта'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    maxLength: 100,
                    focusNode: _descriptionFocusNode,
                    validator: (value) {
                      if (value != null) {
                        if (value.isEmpty || value.length <= 10) {
                          return 'Введите описание продукта, не менее 10 символов';
                        }
                      }
                      return null;
                    },
                    onEditingComplete: () {
                      setState(() {});
                    },
                    onSaved: (value) {
                      if (value != null) {
                        _editingProduct = Product(
                          id: _editingProduct.id,
                          title: _editingProduct.title,
                          description: value,
                          price: _editingProduct.price,
                          imageUrl: _editingProduct.imageUrl,
                          isFavorite: _editingProduct.isFavorite
                        );
                      }
                    },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(top: 8, right: 10),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey)
                        ),
                        child: _imageUrlController.text.isEmpty ?
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Введите Url картинки'),
                        ): FittedBox(child: Image.network(_imageUrlController.text), fit: BoxFit.cover, alignment: Alignment.center, clipBehavior: Clip.hardEdge, )
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Путь к картинке',
                          ),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          controller: _imageUrlController,
                          focusNode: _imageUrlFocusNode,
                          onFieldSubmitted: (_) {
                            _saveForm();
                          },
                          validator: (value) {
                            if (value != null) {
                              if (value.isEmpty) {
                                return 'Введите URL-адрес';
                              }
                            }
                            return null;
                          },
                          onEditingComplete: () {
                            setState(() {});
                          },
                          onSaved: (value) {
                            if (value != null) {
                              _editingProduct = Product(
                                id: _editingProduct.id,
                                title: _editingProduct.title,
                                description: _editingProduct.description,
                                price: _editingProduct.price,
                                imageUrl: value,
                                isFavorite: _editingProduct.isFavorite
                              );
                            }
                          },
                      ),
                    )
                  ],
                )
              ],
            )
          ),
      ),
    );
  }
}