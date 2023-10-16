import 'package:coffee_shop/data/cubit/coffee_count_cubit.dart';
import 'package:coffee_shop/data/cubit/tab_cubit.dart';
import 'package:coffee_shop/data/provider/coffee_provider.dart';
import 'package:coffee_shop/data/provider/order_provider.dart';
import 'package:coffee_shop/data/servise/coffee_service.dart';
import 'package:coffee_shop/data/servise/orders_service.dart';
import 'package:coffee_shop/ui/route/routes.dart';
import 'package:coffee_shop/ui/tab_client/tab_box_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAuth.instance.signInAnonymously();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<TabBoxClientCubit>(
        lazy: true,
        create: (context) => TabBoxClientCubit(),
      ),
      BlocProvider<CoffeeCountCubit>(
        lazy: true,
        create: (context) => CoffeeCountCubit(),
      ),
    ],
    child: MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CoffeeProvider(coffeeService: CoffeeService()),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderProvider(orderService: OrderService()),
        ),
      ],
      child: const MainApp(),
    ),
  ));
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
          return MaterialApp(
              onGenerateRoute: AppRoute.generateRoute,
              debugShowCheckedModeBanner: false,
              home: TabBoxClient());
        });
  }
}
