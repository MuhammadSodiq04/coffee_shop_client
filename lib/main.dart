import 'package:coffee_shop/data/provider/order_provider.dart';
import 'package:coffee_shop/data/provider/products_provider.dart';
import 'package:coffee_shop/data/servise/orders_service.dart';
import 'package:coffee_shop/data/servise/products_service.dart';
import 'package:coffee_shop/ui/route/routes.dart';
import 'package:coffee_shop/ui/tab_client/tab_box_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAuth.instance.signInAnonymously();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              ProductsProvider(productsService: ProductsService()),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (context) => OrderProvider(orderService: OrderService()),
          lazy: true,
        ),
      ],
      child: const MainApp(),
    ),
  );
}


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return const MaterialApp(
            onGenerateRoute: AppRoute.generateRoute,
            debugShowCheckedModeBanner: false,
            home: TabBoxClient()
          );
        });
  }
}
