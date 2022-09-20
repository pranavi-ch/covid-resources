import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/edit_resource_screen.dart';
import 'package:flutter_complete_guide/widgets/user_resource_item.dart';
import 'package:provider/provider.dart';
import '../providers/resources_provider.dart';
import '../widgets/app_drawer.dart';

class UserResourcesScreen extends StatelessWidget {
  static const routeName = '/user-resources';

  @override
  Widget build(BuildContext context) {
    final resourcesData = Provider.of<Resources>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Resources'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              //......
              Navigator.of(context).pushNamed(EditResourceScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: resourcesData.items.length,
          itemBuilder: (_, i) => UserResourceItem(resourcesData.items[i].title,
              resourcesData.items[i].imageUrl, resourcesData.items[i].id),
        ),
      ),
    );
  }
}
