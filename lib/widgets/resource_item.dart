import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/resource.dart';
import 'package:flutter_complete_guide/screens/resource_detail_screen.dart';
import 'package:provider/provider.dart';

class ResourceItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final resource = Provider.of<Resource>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ResourceDetailScreen.routeName,
              arguments: resource.id,
            );
          },
          child: Image.network(
            resource.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(
            resource.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(resource.id, resource.price, resource.title);
            },
          ),
        ),
      ),
    );
  }
}
