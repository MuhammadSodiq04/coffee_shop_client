import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop/data/local/storage_repository/storage_repository.dart';
import 'package:coffee_shop/data/model/basket_model.dart';
import 'package:coffee_shop/data/model/universal_data.dart';
import 'package:coffee_shop/data/servise/orders_service.dart';
import 'package:coffee_shop/utils/ui_utils/loading_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BasketProvider with ChangeNotifier {
  BasketProvider({required this.basketService}) {
    listenOrders(FirebaseAuth.instance.currentUser!.uid);
  }

  final BasketService basketService;
  List<BasketModel> userOrders = [];

  Future<void> addOrder({
    required BuildContext context,
    required BasketModel orderModel,
  }) async {

    await StorageRepository.putString("UserName", orderModel.userName);
    await StorageRepository.putString("UserPhone", orderModel.userPhone);
    await StorageRepository.putString("UserAddress", orderModel.userAddress);

    List<BasketModel> exists = userOrders
        .where((element) => element.coffeeId == orderModel.coffeeId && element.orderStatus == orderModel.orderStatus)
        .toList();

    BasketModel? oldOrderModel;
    if (exists.isNotEmpty) {
      oldOrderModel = exists.first;
      oldOrderModel = oldOrderModel.copWith(
          count: orderModel.count + oldOrderModel.count,
          totalPrice:
              (orderModel.count + oldOrderModel.count) * orderModel.totalPrice);
    }
    if(context.mounted) {
      showLoading(context: context);
    }
    UniversalData universalData = exists.isNotEmpty
        ? await basketService.updateOrder(basketModel: oldOrderModel!)
        : await basketService.addOrder(basketModel: orderModel);

    if (context.mounted) {
      hideLoading(dialogContext: context);
      Navigator.pop(context);
    }
    if (universalData.error.isEmpty) {
      if (context.mounted) {
        showMessage(context, universalData.data as String);
        Navigator.pop(context);
      }
    } else {
      if (context.mounted) {
        showMessage(context, universalData.error);
      }
    }
  }

  Future<void> updateOrder({
    required BuildContext context,
    required BasketModel orderModel,
  }) async {
    showLoading(context: context);

    UniversalData universalData =
        await basketService.updateOrder(basketModel: orderModel);

    if (context.mounted) {
      hideLoading(dialogContext: context);
    }
    if (universalData.error.isEmpty) {
      if (context.mounted) {
        showMessage(context, universalData.data as String);
      }
    } else {
      if (context.mounted) {
        showMessage(context, universalData.error);
      }
    }
  }

  Future<void> deleteOrder({
    required BuildContext context,
    required String orderId,
  }) async {
    showLoading(context: context);
    UniversalData universalData =
        await basketService.deleteOrder(orderId: orderId);
    if (context.mounted) {
      hideLoading(dialogContext: context);
    }
    if (universalData.error.isEmpty) {
      if (context.mounted) {
        showMessage(context, universalData.data as String);
      }
    } else {
      if (context.mounted) {
        showMessage(context, universalData.error);
      }
    }
  }

  Stream<List<BasketModel>> listenOrdersList(String? uid) async* {
    if (uid == null) {
      yield* FirebaseFirestore.instance.collection("orders").snapshots().map(
            (event1) => event1.docs
                .map((doc) => BasketModel.fromJson(doc.data()))
                .toList(),
          );
    } else {
      yield* FirebaseFirestore.instance
          .collection("orders")
          .where("userId", isEqualTo: uid)
          .snapshots()
          .map(
            (event1) => event1.docs
                .map((doc) => BasketModel.fromJson(doc.data()))
                .toList(),
          );
    }
  }

  int calculateTotalPrice(List<BasketModel> basketItems) {
    int totalPrice = 0;
    for (var item in basketItems) {
      totalPrice += item.totalPrice;
    }
    return totalPrice;
  }

  listenOrders(String userId) async {
    listenOrdersList(userId).listen((List<BasketModel> orders) {
      userOrders = orders;
      debugPrint("CURRENT USER ORDERS LENGTH:${userOrders.length}");
      notifyListeners();
    });
  }

  showMessage(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error, style: TextStyle(
      fontWeight: FontWeight.w500,
      color: Colors.white,
      fontSize: 16.sp,
      fontFamily: "Montserrat",
    ),),backgroundColor: Colors.brown,));
    notifyListeners();
  }
}
