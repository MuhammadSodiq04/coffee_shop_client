import 'package:coffee_shop/data/model/coffee_model.dart';
import 'package:coffee_shop/ui/route/route_names.dart';
import 'package:coffee_shop/ui/tab_client/coffees/widgets/coffee_detail.dart';
import 'package:flutter/material.dart';

class AppRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.coffeeDetail:
        return MaterialPageRoute(builder: (_) =>  CoffeeDetailScreen(coffeeModel: settings.arguments as CoffeeModel,));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                  child: Text('No route defined for ${settings.name}')),
            ));
    }
  }
}