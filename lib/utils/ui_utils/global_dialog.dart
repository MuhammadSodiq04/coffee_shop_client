import 'package:coffee_shop/data/model/coffee_model.dart';
import 'package:coffee_shop/data/model/order_model.dart';
import 'package:coffee_shop/data/provider/order_provider.dart';
import 'package:coffee_shop/utils/ui_utils/global_text_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void showProductAlertDialog(
    {required BuildContext context,
    required String title,
    required CoffeeModel coffeeModel,
    required int count}) {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController(text: "+998");
  TextEditingController addressController = TextEditingController();
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: AlertDialog(
          title: Text(title),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
          content: Container(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),
                  color: Theme.of(context).scaffoldBackgroundColor),
              child: SizedBox(
                width: 0,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10.h),
                      GlobalTextField(
                        keyboardType: TextInputType.name,
                        controller: nameController,
                        textInputAction: TextInputAction.next,
                        hintText: "Client Name",
                      ),
                      SizedBox(height: 10.h),
                      GlobalTextField(
                        keyboardType: TextInputType.number,
                        controller: phoneController,
                        textInputAction: TextInputAction.next,
                        hintText: "Client Phone",
                        isPhone: true,
                      ),
                      SizedBox(height: 10.h),
                      GlobalTextField(
                        keyboardType: TextInputType.name,
                        controller: addressController,
                        textInputAction: TextInputAction.done,
                        hintText: "Client Address",
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel')),
                          ElevatedButton(
                              onPressed: () {
                                if (nameController.text.isNotEmpty &&
                                    phoneController.text.isNotEmpty &&
                                    addressController.text.isNotEmpty) {
                                  Provider.of<OrderProvider>(context,
                                          listen: false)
                                      .addOrder(
                                    context: context,
                                    orderModel: OrderModel(
                                      count: count,
                                      totalPrice: coffeeModel.price * count,
                                      orderId: "",
                                      coffeeId: coffeeModel.coffeeId,
                                      orderStatus: "sent",
                                      userId: FirebaseAuth.instance.currentUser!.uid,
                                      createdAt: DateTime.now().toString(),
                                      coffeeName: coffeeModel.coffeeName,
                                      userName: nameController.text,
                                      userPhone: phoneController.text,
                                      userAddress: addressController.text,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Fields are incomplete!",
                                        style: TextStyle(
                                            fontSize: 20.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              child: const Text("Next")),
                        ],
                      )
                    ]),
              )),
          contentPadding: EdgeInsets.zero,
        ),
      );
    },
  );
}
