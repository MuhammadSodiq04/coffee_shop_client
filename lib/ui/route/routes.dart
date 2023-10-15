import 'package:coffee_shop/ui/route/route_names.dart';
import 'package:coffee_shop/ui/tab_client/products/widgets/product_detail.dart';
import 'package:flutter/material.dart';

class AppRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.productDetail:
        return MaterialPageRoute(builder: (_) =>  ProductDetailScreen(argumentsList: settings.arguments as List,));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                  child: Text('No route defined for ${settings.name}')),
            ));
    }
  }
}