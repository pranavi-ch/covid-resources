import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/resources_provider.dart';
import 'package:provider/provider.dart';

import 'resource_item.dart';

class ResourcesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //sets up communication channel
    final resourcesData = Provider.of<Resources>(context);
    final loadedResources = resourcesData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: loadedResources.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: loadedResources[i],
        child: ResourceItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
