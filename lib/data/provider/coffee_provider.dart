import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop/data/model/coffee_model.dart';
import 'package:coffee_shop/utils/ui_utils/constants.dart';
import 'package:flutter/material.dart';

class CoffeeProvider with ChangeNotifier{

  List<String> uploadedImagesUrls = [];
  String searchQuery = '';

  void setSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }

  Stream<List<CoffeeModel>> searchCoffees(String query)async* {
    yield* FirebaseFirestore.instance
        .collection(firebaseCollectionName).where("coffeeName", isEqualTo: query)
        .snapshots()
        .map((event) => event.docs
        .map((doc) => CoffeeModel.fromJson(doc.data()))
        .toList());
  }

  Stream<List<CoffeeModel>> getCoffees() async* {
      yield* FirebaseFirestore.instance.collection(firebaseCollectionName).snapshots().map(
            (event1) => event1.docs
            .map((doc) => CoffeeModel.fromJson(doc.data()))
            .toList(),
      );
  }

  showMessage(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    notifyListeners();
  }
}
