import 'package:coffee_shop/ui/tab_client/basket/basket.dart';
import 'package:coffee_shop/ui/tab_client/products/products_screen_client.dart';
import 'package:coffee_shop/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';

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
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(24),
            topLeft: Radius.circular(24),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.blue,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home,color: Colors.white,), label: '',),
              BottomNavigationBarItem(icon: Icon(Icons.shopping_cart,color: Colors.white,), label: '',),
            ],
            currentIndex: currentIndex,
            onTap: _onItemTapped,
          ),
        ),
      )
    );
  }
}
