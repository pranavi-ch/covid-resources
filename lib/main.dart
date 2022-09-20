import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/resources_provider.dart';
import 'package:flutter_complete_guide/screens/cart_screen.dart';
import 'package:flutter_complete_guide/screens/resource_detail_screen.dart';
import 'package:flutter_complete_guide/screens/resources_overview_screen.dart';
import 'package:flutter_complete_guide/screens/user_resources_screen.dart';
import 'package:flutter_complete_guide/widgets/user_resource_item.dart';
import 'package:provider/provider.dart';
import './screens/edit_resource_screen.dart';
import './screens/auth_screen.dart';
import 'providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //is a provider
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Resources>(
            create: (ctx) => Resources(null, null, []),
            update: (ctx, auth, previousResources) => Resources(
                auth.token,
                auth.userId,
                previousResources == null ? [] : previousResources.items),
          ),
          ChangeNotifierProvider.value(value: Cart()),
        ],

        //whenever auth changes, material app is rebuilt
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
              title: 'Covid Resources App',
              theme: ThemeData(
                primarySwatch: Colors.indigo,
              ),
              home: auth.isAuth ? ResourcesOverviewScreen() : AuthScreen(),
              //routes to various screens in the application
              routes: {
                ResourceDetailScreen.routeName: (ctx) => ResourceDetailScreen(),
                CartScreen.routeName: (ctx) => CartScreen(),
                UserResourcesScreen.routeName: (ctx) => UserResourcesScreen(),
                EditResourceScreen.routeName: (ctx) => EditResourceScreen(),
              }),
        ));
  }
}
