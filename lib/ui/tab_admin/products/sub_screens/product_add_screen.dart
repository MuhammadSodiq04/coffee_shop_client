import 'package:coffee_shop/data/model/coffee_model.dart';
import 'package:coffee_shop/data/provider/products_provider.dart';
import 'package:coffee_shop/utils/ui_utils/global_button.dart';
import 'package:coffee_shop/utils/ui_utils/global_text_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProductAddScreen extends StatefulWidget {
  const ProductAddScreen({super.key, this.productModel});

  final CoffeeModel? productModel;

  @override
  State<ProductAddScreen> createState() => _ProductAddScreenState();
}

class _ProductAddScreenState extends State<ProductAddScreen> {
  ImagePicker picker = ImagePicker();
  String currency = "";

  List<String> currencies = ["UZS", "USD", "RUB"];

  String selectedCurrency = "UZS";
  String selectedCategoryId = "";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<ProductsProvider>(context, listen: false).clearParameters();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              widget.productModel == null ? "Product Add" : "Product Update"),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  GlobalTextField(
                      hintText: "Product Name",
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.start,
                      controller: context.read<ProductsProvider>().productNameController, maxlines: 1,),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 200,
                    child: GlobalTextField(
                        maxlines: 100,
                        hintText: "Description",
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        textAlign: TextAlign.start,
                        controller: context
                            .read<ProductsProvider>()
                            .productDescController),
                  ),
                  const SizedBox(height: 24),
                  GlobalTextField(
                    hintText: "Product Count",
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    textAlign: TextAlign.start,
                    controller:
                    context.read<ProductsProvider>().productCountController, maxlines: 1,
                  ),
                  const SizedBox(height: 24),
                  GlobalTextField(
                    hintText: "Product Price",
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    textAlign: TextAlign.start,
                    controller:
                    context.read<ProductsProvider>().productPriceController, maxlines: 1,
                  ),
                  const SizedBox(height: 24),
                  DropdownButton(
                    // Initial Value
                    value: selectedCurrency,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: currencies.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCurrency = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  const SizedBox(height: 24),
                  context.watch<ProductsProvider>().uploadedImagesUrls.isEmpty
                      ? TextButton(
                    onPressed: () {
                      showBottomSheetDialog();
                    },
                    style: TextButton.styleFrom(
                        backgroundColor:
                        Theme.of(context).indicatorColor),
                    child: const Text(
                      "Select Image",
                      style: TextStyle(color: Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                      : SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        ...List.generate(
                            context
                                .watch<ProductsProvider>()
                                .uploadedImagesUrls
                                .length, (index) {
                          String singleImage = context
                              .watch<ProductsProvider>()
                              .uploadedImagesUrls[index];
                          return Container(
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Image.network(
                              singleImage,
                              width: 80,
                              height: 80,
                              fit: BoxFit.fill,
                            ),
                          );
                        })
                      ],
                    ),
                  ),

                  Visibility(
                    visible: context.watch<ProductsProvider>().uploadedImagesUrls.isNotEmpty,
                    child: TextButton(
                      onPressed: () {
                        showBottomSheetDialog();
                      },
                      style: TextButton.styleFrom(
                          backgroundColor:
                          Theme.of(context).indicatorColor),
                      child: const Text(
                        "Select Image",
                        style: TextStyle(color: Colors.black),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),),

                  const SizedBox(height: 24),
                ],
              ),
            ),
            GlobalButton(
                title: widget.productModel == null
                    ? "Add product"
                    : "Update product",
                onTap: () {
                  if (context
                      .read<ProductsProvider>()
                      .uploadedImagesUrls
                      .isNotEmpty &&
                      selectedCategoryId.isNotEmpty) {
                    context.read<ProductsProvider>().addProduct(
                      context: context,
                      categoryId: selectedCategoryId,
                      productCurrency: selectedCurrency,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Duration(milliseconds: 500),
                        backgroundColor: Colors.red,
                        margin: EdgeInsets.symmetric(
                          vertical: 100,
                          horizontal: 20,
                        ),
                        behavior: SnackBarBehavior.floating,
                        content: Text(
                          "Ma'lumotlar to'liq emas!!!",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }

  void showBottomSheetDialog() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(24),
          height: 200,
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  _getFromGallery();
                  Navigator.pop(context);
                },
                leading: const Icon(Icons.photo,color: Colors.white,),
                title: Text("Select from Gallery",style: TextStyle(color: Colors.white,fontSize: 20.sp)),
              ),
              ListTile(
                onTap: () {
                  _getFromCamera();
                  Navigator.pop(context);
                },
                leading: const Icon(Icons.photo_camera,color: Colors.white,),
                title: Text("Select from Camera",style: TextStyle(color: Colors.white,fontSize: 20.sp)),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _getFromGallery() async {
    List<XFile?> xFiles = await picker.pickMultiImage(
      maxHeight: 512,
      maxWidth: 512,
    );
    if(context.mounted) {
      await Provider.of<ProductsProvider>(context, listen: false)
        .uploadProductImages(
      context: context,
      images: xFiles,
    );
    }
  }
  Future<void> _getFromCamera() async {
    List<XFile?> xFile = [await picker.pickImage(source: ImageSource.camera,
      maxHeight: 512,
      maxWidth: 512,
    )];
    if(context.mounted) {
      await Provider.of<ProductsProvider>(context, listen: false)
        .uploadProductImages(
      context: context,
      images: xFile,
    );
    }
  }
}
