import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/resources_provider.dart';
import 'package:flutter_complete_guide/screens/resource_detail_screen.dart';
import 'package:provider/provider.dart';

class UserResourceItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;

  UserResourceItem(this.title, this.imageUrl, this.id);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_forward_rounded),
            onPressed: () {
              Navigator.of(context).pushNamed(
                ResourceDetailScreen.routeName,
                arguments: id,
              );
            },
            color: Theme.of(context).primaryColor,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              Provider.of<Resources>(context, listen: false).deleteResource(id);
            },
            color: Theme.of(context).errorColor,
          ),
        ]),
      ),
    );
  }
}
