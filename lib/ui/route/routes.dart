import 'package:coffee_shop/data/model/coffee_model.dart';
import 'package:coffee_shop/ui/route/route_names.dart';
import 'package:coffee_shop/ui/splash/splash_screen.dart';
import 'package:coffee_shop/ui/tab_client/coffees/widgets/coffee_detail.dart';
import 'package:coffee_shop/ui/tab_client/tab_box_client.dart';
import 'package:flutter/material.dart';

class AppRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) =>  const SplashScreen());
      case RouteNames.coffeeDetail:
        return MaterialPageRoute(builder: (_) =>  CoffeeDetailScreen(coffeeModel: settings.arguments as CoffeeModel,));
      case RouteNames.tabBox:
        return MaterialPageRoute(builder: (_) =>  TabBoxClient());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                  child: Text('No route defined for ${settings.name}')),
            ));
    }
  }
}