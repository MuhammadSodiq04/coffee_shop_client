import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop/data/model/coffee_model.dart';
import 'package:coffee_shop/data/model/universal_data.dart';
import 'package:coffee_shop/data/servise/coffee_service.dart';
import 'package:coffee_shop/data/servise/upload_service.dart';
import 'package:coffee_shop/utils/ui_utils/constants.dart';
import 'package:coffee_shop/utils/ui_utils/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CoffeeProvider with ChangeNotifier{
  CoffeeProvider({required this.coffeeService});

  final CoffeeService coffeeService;

  TextEditingController coffeeNameController = TextEditingController();
  TextEditingController coffeePriceController = TextEditingController();
  TextEditingController coffeeDescController = TextEditingController();

  List<String> uploadedImagesUrls = [];

  String searchQuery = '';

  void setSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }

  Future<void> addCoffee({
    required BuildContext context,
    required String categoryId,
    required String productCurrency,
  }) async {

    CoffeeModel coffeeModel = CoffeeModel(
      price: int.parse(coffeePriceController.text),
      coffeeImages: uploadedImagesUrls,
      coffeeId: "",
      coffeeName: coffeeNameController.text,
      description: coffeeDescController.text,
      createdAt: DateTime.now().toString(),
    );

      showLoading(context: context);
      UniversalData universalData =
      await coffeeService.addCoffee(coffeeModel: coffeeModel);
      if (context.mounted) {
        hideLoading(dialogContext: context);
      }
      if (universalData.error.isEmpty) {
        if (context.mounted) {
          showMessage(context, universalData.data as String);
          clearParameters();
          Navigator.pop(context);
        }
      } else {
        if (context.mounted) {
          showMessage(context, universalData.error);
        }
      }
    }

  Future<void> deleteCoffees({
    required BuildContext context,
    required String coffeeId,
  }) async {
    showLoading(context: context);
    UniversalData universalData =
    await coffeeService.deleteCoffee(coffeeId: coffeeId);
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

  Future<void> updateCoffee({
    required BuildContext context,
    required String imagePath,
    required CoffeeModel coffeeModel,
  }) async {
    String name = coffeeNameController.text;
    String categoryDesc = coffeePriceController.text;

    if (name.isNotEmpty && categoryDesc.isNotEmpty) {
      showLoading(context: context);
      UniversalData universalData = await coffeeService.updateCoffee(
        coffeeModel: CoffeeModel(
          price: 23,
          coffeeImages: [],
          createdAt: coffeeModel.createdAt,
          coffeeName: coffeeNameController.text,
          description: coffeePriceController.text,
          coffeeId: coffeeModel.coffeeId,
        ),
      );
      if (context.mounted) {
        hideLoading(dialogContext: context);
      }
      if (universalData.error.isEmpty) {
        if (context.mounted) {
          showMessage(context, universalData.data as String);
          clearParameters();
          Navigator.pop(context);
        }
      } else {
        if (context.mounted) {
          showMessage(context, universalData.error);
        }
      }
    }
  }

  Future<void> uploadCoffeeImages({
    required BuildContext context,
    required List<XFile?> images,
  }) async {
    showLoading(context: context);

    for (var element in images) {
      UniversalData data = await FileUploader.imageUploader(element!);
      if (data.error.isEmpty) {
        uploadedImagesUrls.add(data.data as String);
      }
    }

    notifyListeners();

    if (context.mounted) {
      hideLoading(dialogContext: context);
    }
  }

  clearParameters() {
    uploadedImagesUrls = [];
    coffeePriceController.clear();
    coffeeNameController.clear();
    coffeeDescController.clear();
  }
}
