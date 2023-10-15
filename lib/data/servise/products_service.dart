import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop/data/model/coffee_model.dart';
import 'package:coffee_shop/data/model/universal_data.dart';

class ProductsService{
  Future<UniversalData> addProduct({required CoffeeModel coffeeModel}) async {
    try {
      DocumentReference newProduct = await FirebaseFirestore.instance
          .collection("products")
          .add(coffeeModel.toJson());

      await FirebaseFirestore.instance
          .collection("products")
          .doc(newProduct.id)
          .update({
        "productId": newProduct.id,
      });

      return UniversalData(data: "Product added!");
    } on FirebaseException catch (e) {
      return UniversalData(error: e.code);
    } catch (error) {
      return UniversalData(error: error.toString());
    }
  }

  Future<UniversalData> updateProduct(
      {required CoffeeModel coffeeModel}) async {
    try {
      await FirebaseFirestore.instance
          .collection("products")
          .doc(coffeeModel.productId)
          .update(coffeeModel.toJson());

      return UniversalData(data: "Product updated!");
    } on FirebaseException catch (e) {
      return UniversalData(error: e.code);
    } catch (error) {
      return UniversalData(error: error.toString());
    }
  }

  Future<UniversalData> deleteProduct({required String productId}) async {
    try {
      await FirebaseFirestore.instance
          .collection("products")
          .doc(productId)
          .delete();

      return UniversalData(data: "Product deleted!");
    } on FirebaseException catch (e) {
      return UniversalData(error: e.code);
    } catch (error) {
      return UniversalData(error: error.toString());
    }
  }
}
