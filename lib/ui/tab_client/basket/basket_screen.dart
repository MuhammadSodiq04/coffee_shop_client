import 'package:coffee_shop/data/model/basket_model.dart';
import 'package:coffee_shop/data/provider/basket_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class BasketScreen extends StatefulWidget {
  const BasketScreen({super.key});

  @override
  State<BasketScreen> createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          "Basket",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: 24.sp,
            fontFamily: "Montserrat",
          ),
        ),
      ),
      body: StreamBuilder<List<BasketModel>>(
        stream: context.read<BasketProvider>().listenOrdersList(FirebaseAuth.instance.currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<List<BasketModel>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(child: Text("Basket Empty!"));
            }
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    children: List.generate(
                      snapshot.data!.length,
                          (index) {
                        BasketModel basketModel = snapshot.data![index];
                        return Dismissible(
                          key: UniqueKey(),
                          onDismissed: (v) {
                            context.read<BasketProvider>().deleteOrder(
                              context: context,
                              orderId: basketModel.orderId,
                            );
                          },
                          child: ListTile(
                            title: Text(basketModel.coffeeName,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.brown,
                                fontSize: 18.sp,
                                fontFamily: "Montserrat",
                              ),),
                            subtitle: Text("${basketModel.count} = ${basketModel.totalPrice} so'm",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.brown,
                                fontSize: 15.sp,
                                fontFamily: "Montserrat",
                              ),),
                            trailing: Text(basketModel.orderStatus,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.brown,
                                fontSize: 15.sp,
                                fontFamily: "Montserrat",
                              ),),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.sp),
                  child: Text(
                    "Total Price: ${context.read<BasketProvider>().calculateTotalPrice(snapshot.data!)} so'm",
                    style: TextStyle(
                      color: Colors.brown,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    ),
                  ),
                ),
              ],
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          return const Center(child: CircularProgressIndicator(color: Colors.brown,));
        },
      ),
    );
  }
}
