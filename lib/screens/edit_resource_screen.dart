import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/resources_provider.dart';
import 'package:provider/provider.dart';
import '../providers/resource.dart';

class EditResourceScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditResourceScreenState createState() => _EditResourceScreenState();
}

class _EditResourceScreenState extends State<EditResourceScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  //allows to interact with form widget state
  final _form = GlobalKey<FormState>();
  var _editedResource =
      Resource(id: null, title: '', price: 0, description: '', imageUrl: '');

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    Provider.of<Resources>(context, listen: false).addResource(_editedResource);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Resource'), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.save),
          onPressed: _saveForm,
        )
      ]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) {
                  _editedResource = Resource(
                      id: null,
                      title: value,
                      price: _editedResource.price,
                      description: _editedResource.description,
                      imageUrl: _editedResource.imageUrl);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a value';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) {
                  _editedResource = Resource(
                      id: null,
                      title: _editedResource.title,
                      price: double.parse(value),
                      description: _editedResource.description,
                      imageUrl: _editedResource.imageUrl);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a price.';
                  }

                  if (double.tryParse(value) == null) {
                    return 'Please provide valid price.';
                  }

                  if (double.parse(value) < 0) {
                    return 'Please provide valid price.';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onSaved: (value) {
                  _editedResource = Resource(
                      id: null,
                      title: _editedResource.title,
                      price: _editedResource.price,
                      description: value,
                      imageUrl: _editedResource.imageUrl);
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                            child: Image(
                                image: NetworkImage(_imageUrlController.text)),
                            fit: BoxFit.fill,
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      onEditingComplete: () {
                        setState(() {});
                      },
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value) {
                        _editedResource = Resource(
                            id: null,
                            title: _editedResource.title,
                            price: _editedResource.price,
                            description: _editedResource.description,
                            imageUrl: value);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a url';
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please provide VALID url.';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
