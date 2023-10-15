import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_shop/data/model/coffee_model.dart';
import 'package:coffee_shop/data/model/order_model.dart';
import 'package:coffee_shop/data/provider/order_provider.dart';
import 'package:coffee_shop/utils/ui_utils/global_button.dart';
import 'package:coffee_shop/utils/ui_utils/shimmer_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen(
      {super.key, required this.argumentsList});

  final List<dynamic> argumentsList;




  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int count = 1;
  late CoffeeModel productModel;
  late int index;

  @override
  void initState() {
    productModel = widget.argumentsList[0];
    index = widget.argumentsList[1];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Detail"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              physics: const ScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 38),
              children: [
                Hero(
                  tag: index,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: CachedNetworkImage(
                      height: 350.h,
                      // width: 300.h,
                      fit: BoxFit.fill,
                      imageUrl: productModel.productImages.first,
                      placeholder: (context, url) =>
                          const ShimmerPhoto(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  productModel.productName,
                  style: TextStyle(
                      fontSize: 32.spMin,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  productModel.description,
                  style: TextStyle(
                      fontSize: 22.spMin,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "Count: ${productModel.count}",
                  style: TextStyle(
                      fontSize: 22.spMin,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "Price: ${productModel.price} ${productModel.currency}",
                  style: TextStyle(
                      fontSize: 22.spMin,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (count > 1) {
                          setState(() {
                            count--;
                          });
                        }
                      },
                      child: const Icon(
                        Icons.remove,
                      ),
                    ),
                    Text(
                      count.toString(),
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    TextButton(
                        onPressed: () {
                          if ((count + 1) <= productModel.count) {
                            setState(() {
                              count++;
                            });
                          }
                        },
                        child: const Icon(Icons.add)),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${productModel.price * count}.   ${productModel.currency}",
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),

                    GlobalButton(
                      onTap: () {
                        Provider.of<OrderProvider>(context, listen: false).addOrder(
                          context: context,
                          orderModel: OrderModel(
                            count: count,
                            totalPrice: productModel.price * count,
                            orderId: "",
                            productId: productModel.productId,
                            orderStatus: "ordered",
                            createdAt: DateTime.now().toString(),
                            productName: productModel.productName,
                          ),
                        );
                      },
                      title: "Add to Card",
                    )
                  ],
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }
}
