import 'package:coffee_shop/ui/tab_client/basket/basket.dart';
import 'package:coffee_shop/ui/tab_client/products/products_screen_client.dart';
import 'package:coffee_shop/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabBoxClient extends StatefulWidget {
  const TabBoxClient({super.key});

  @override
  State<TabBoxClient> createState() => _TabBoxClientState();
}

class _TabBoxClientState extends State<TabBoxClient> {
  List<Widget> screens = [];

  int currentIndex = 0;

  @override
  void initState() {
    screens = [
      const ProductsScreen(),
      const BasketScreen(),
    ];

    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar:Container(
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24.r),
            topLeft: Radius.circular(24.r),
          ),
          child: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            backgroundColor: Colors.blue,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home,color: Colors.white,size: 30.w,), label: '',),
              BottomNavigationBarItem(icon: Icon(Icons.shopping_cart,color: Colors.white,size: 30.w,), label: '',),
            ],
            currentIndex: currentIndex,
            onTap: _onItemTapped,
          ),
        ),
      )
    );
  }
}
