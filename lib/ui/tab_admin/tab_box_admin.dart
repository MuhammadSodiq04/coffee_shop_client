import 'package:coffee_shop/ui/tab_admin/products/products_screen_admin.dart';
import 'package:flutter/material.dart';

class TabBoxAdmin extends StatefulWidget {
  const TabBoxAdmin({super.key});

  @override
  State<TabBoxAdmin> createState() => _TabBoxAdminState();
}

class _TabBoxAdminState extends State<TabBoxAdmin> {
  List<Widget> screens = [];

  int currentIndex = 0;

  @override
  void initState() {
    screens = [
      const ProductsScreenAdmin(),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 30, color: Colors.white),label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.category_rounded, size: 30, color: Colors.white),label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person, size: 30, color: Colors.white),label: ''),

        ],
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
