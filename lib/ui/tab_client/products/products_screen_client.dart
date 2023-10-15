import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_shop/data/model/coffee_model.dart';
import 'package:coffee_shop/data/provider/products_provider.dart';
import 'package:coffee_shop/ui/tab_client/products/widgets/product_detail.dart';
import 'package:coffee_shop/utils/ui_utils/shimmer_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String selectedCategoryId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text("Coffee"),
      ),
      body: Column(
        children: [
          StreamBuilder<List<CoffeeModel>>(
            stream: context
                .read<ProductsProvider>()
                .getProducts(selectedCategoryId),
            builder: (BuildContext context,
                AsyncSnapshot<List<CoffeeModel>> snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!.isNotEmpty
                    ? Expanded(
                        child: StreamBuilder<List<CoffeeModel>>(
                          stream: context
                              .read<ProductsProvider>()
                              .getProducts(selectedCategoryId),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<CoffeeModel>> snapshot) {
                            if (snapshot.hasData) {
                              return snapshot.data!.isNotEmpty
                                  ? GridView(padding: const EdgeInsets.all(18),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              mainAxisSpacing: 10,
                                              crossAxisSpacing: 10,
                                              childAspectRatio: 0.65),
                                      children: [
                                        ...List.generate(
                                            snapshot.data!.length, (index) {
                                          CoffeeModel productModel =
                                              snapshot.data![index];
                                          return ZoomTapAnimation(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductDetailScreen(
                                                          argumentsList: [
                                                        productModel,
                                                        index,
                                                      ]),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: 155.w,
                                              height: 230.h,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(16),
                                                  color: Colors.grey),
                                              child: Column(
                                                // mainAxisAlignment:
                                                //     MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Hero(
                                                    tag: index,
                                                    child: ClipRRect(
                                                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(16),topRight: Radius.circular(16)),
                                                      child: CachedNetworkImage(
                                                        height: 172.h,
                                                        width: 175.w,
                                                        fit: BoxFit.fill,
                                                        imageUrl: productModel.productImages.first,
                                                        placeholder: (context, url) =>
                                                        const ShimmerPhoto(),
                                                        errorWidget: (context, url, error) => const Icon(
                                                          Icons.error,color: Colors.red,),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    productModel
                                                        .productName,
                                                    style: const TextStyle(
                                                        fontSize: 22,
                                                        color:
                                                        Colors.white,
                                                        fontWeight:
                                                        FontWeight
                                                            .w700),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  const SizedBox(
                                                      height: 5),
                                                  Text(
                                                    "Price: ${productModel.price} ${productModel.currency}",
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        color:
                                                        Colors.white,
                                                        fontWeight:
                                                        FontWeight
                                                            .w500),
                                                  ),
                                                  SizedBox(height: 13.h,),
                                                ],
                                              ),
                                            ),
                                          );
                                        })
                                      ],
                                    )
                                  : const Center(
                                      child: Text(
                                        "Product Empty!",
                                        style: TextStyle(
                                            fontSize: 32,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    );
                            }
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(snapshot.error.toString()),
                              );
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                        ),
                      )
                    : const Center(child: Text("Product Empty!"));
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }
}
