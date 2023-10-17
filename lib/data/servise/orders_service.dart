import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop/data/model/basket_model.dart';
import 'package:coffee_shop/data/model/universal_data.dart';
import 'package:coffee_shop/utils/ui_utils/constants.dart';

class BasketService {
  Future<UniversalData> addOrder({required BasketModel basketModel}) async {
    try {
      DocumentReference newOrder = await FirebaseFirestore.instance
          .collection(firebaseOrderName)
          .add(basketModel.toJson());

      await FirebaseFirestore.instance
          .collection(firebaseOrderName)
          .doc(newOrder.id)
          .update({"orderId": newOrder.id});

      return UniversalData(data: "Added to Basket!");
    } on FirebaseException catch (e) {
      return UniversalData(error: e.code);
    } catch (error) {
      return UniversalData(error: error.toString());
    }
  }

  Future<UniversalData> updateOrder({required BasketModel basketModel}) async {
    print("INSIDE UPDATE: ${basketModel.orderId}");
    try {
      await FirebaseFirestore.instance
          .collection(firebaseOrderName)
          .doc(basketModel.orderId)
          .update(
        basketModel.toJson(),
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
