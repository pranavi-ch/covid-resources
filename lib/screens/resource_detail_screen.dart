//getting details of the resource when clicked on

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/resources_provider.dart';
import 'package:provider/provider.dart';

class ResourceDetailScreen extends StatelessWidget {
  static const routeName = '/resource-details';

  @override
  Widget build(BuildContext context) {
    final resourceId = ModalRoute.of(context).settings.arguments as String;
    // get all details from id
    final loadedResource = Provider.of<Resources>(
      context,
      //doesn't reload, just get data from data storage
      listen: false,
    ).findById(resourceId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedResource.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: 300,
                child: Image.network(
                  loadedResource.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )),
            SizedBox(height: 10),
            Text(
              'INR ${loadedResource.price}',
              style: TextStyle(
                color: Colors.indigo,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(loadedResource.description,
                textAlign: TextAlign.center, softWrap: true)
          ],
        ),
      ),
    );
  }
}
