import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop/data/model/order_model.dart';
import 'package:coffee_shop/data/model/universal_data.dart';
import 'package:coffee_shop/utils/ui_utils/constants.dart';

class OrderService {
  Future<UniversalData> addOrder({required OrderModel orderModel}) async {
    try {
      DocumentReference newOrder = await FirebaseFirestore.instance
          .collection(firebaseOrderName)
          .add(orderModel.toJson());

      await FirebaseFirestore.instance
          .collection(firebaseOrderName)
          .doc(newOrder.id)
          .update({"orderId": newOrder.id});

      return UniversalData(data: "Order added!");
    } on FirebaseException catch (e) {
      return UniversalData(error: e.code);
    } catch (error) {
      return UniversalData(error: error.toString());
    }
  }

  Future<UniversalData> updateOrder({required OrderModel orderModel}) async {
    print("INSIDE UPDATE: ${orderModel.orderId}");
    try {
      await FirebaseFirestore.instance
          .collection(firebaseOrderName)
          .doc(orderModel.orderId)
          .update(
        orderModel.toJson(),
      );

      return UniversalData(data: "Order updated!");
    } on FirebaseException catch (e) {
      return UniversalData(error: e.code);
    } catch (error) {
      return UniversalData(error: error.toString());
    }
  }

  Future<UniversalData> deleteOrder({required String orderId}) async {
    try {
      await FirebaseFirestore.instance
          .collection(firebaseOrderName)
          .doc(orderId)
          .delete();

      return UniversalData(data: "Order deleted!");
    } on FirebaseException catch (e) {
      return UniversalData(error: e.code);
    } catch (error) {
      return UniversalData(error: error.toString());
    }
  }
}
