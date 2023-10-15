import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop/data/model/coffee_model.dart';
import 'package:coffee_shop/data/model/universal_data.dart';
import 'package:coffee_shop/data/servise/products_service.dart';
import 'package:coffee_shop/data/servise/upload_service.dart';
import 'package:coffee_shop/utils/ui_utils/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductsProvider with ChangeNotifier{
  ProductsProvider({required this.productsService});

  final ProductsService productsService;

  TextEditingController productNameController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController productDescController = TextEditingController();
  TextEditingController productCountController = TextEditingController();

  List<String> uploadedImagesUrls = [];

  Future<void> addProduct({
    required BuildContext context,
    required String categoryId,
    required String productCurrency,
  }) async {
    String name = productNameController.text;
    String productDesc = productDescController.text;
    String priceText = productPriceController.text;
    String countText = productCountController.text;

    if (name.isNotEmpty &&
        productDesc.isNotEmpty &&
        priceText.isNotEmpty &&
        countText.isNotEmpty) {

      CoffeeModel coffeeModel = CoffeeModel(
        count: int.parse(countText),
        price: int.parse(priceText),
        productImages: uploadedImagesUrls,
        categoryId: categoryId,
        productId: "",
        productName: name,
        description: productDesc,
        createdAt: DateTime.now().toString(),
        currency: productCurrency,
      );

      showLoading(context: context);
      UniversalData universalData =
      await productsService.addProduct(coffeeModel: coffeeModel);
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
    } else {
      showMessage(context, "Maydonlar to'liq emas!!!");
    }
  }

  Future<void> deleteProduct({
    required BuildContext context,
    required String productId,
  }) async {
    showLoading(context: context);
    UniversalData universalData =
    await productsService.deleteProduct(productId: productId);
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

  Stream<List<CoffeeModel>> getProducts(String categoryId) async* {
    if (categoryId.isEmpty) {
      yield* FirebaseFirestore.instance.collection("products").snapshots().map(
            (event1) => event1.docs
            .map((doc) => CoffeeModel.fromJson(doc.data()))
            .toList(),
      );
    } else {
      yield* FirebaseFirestore.instance
          .collection("products")
          .where("categoryId", isEqualTo: categoryId)
          .snapshots()
          .map(
            (event1) => event1.docs
            .map((doc) => CoffeeModel.fromJson(doc.data()))
            .toList(),
      );
    }
  }

  showMessage(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    notifyListeners();
  }

  Future<void> updateProduct({
    required BuildContext context,
    required String imagePath,
    required CoffeeModel productModel,
  }) async {
    String name = productNameController.text;
    String categoryDesc = productPriceController.text;

    if (name.isNotEmpty && categoryDesc.isNotEmpty) {
      showLoading(context: context);
      UniversalData universalData = await productsService.updateProduct(
        coffeeModel: CoffeeModel(
          count: 1,
          price: 23,
          productImages: [],
          categoryId: productModel.categoryId,
          createdAt: productModel.createdAt,
          productName: productNameController.text,
          description: productPriceController.text,
          productId: productModel.productId,
          currency: "SO'M",
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

  Future<void> uploadProductImages({
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

  // setInitialValues(CategoryModel categoryModel) {
  //   productNameController =
  //       TextEditingController(text: categoryModel.categoryName);
  //   productPriceController =
  //       TextEditingController(text: categoryModel.description);
  //   notifyListeners();
  // }

  clearParameters() {
    uploadedImagesUrls = [];
    productPriceController.clear();
    productNameController.clear();
    productDescController.clear();
    productCountController.clear();
  }
}
