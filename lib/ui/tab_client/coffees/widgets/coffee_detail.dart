import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_shop/data/cubit/coffee_count_cubit.dart';
import 'package:coffee_shop/data/model/coffee_model.dart';
import 'package:coffee_shop/data/model/order_model.dart';
import 'package:coffee_shop/data/provider/order_provider.dart';
import 'package:coffee_shop/utils/ui_utils/global_button.dart';
import 'package:coffee_shop/utils/ui_utils/global_dialog.dart';
import 'package:coffee_shop/utils/ui_utils/shimmer_photo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CoffeeDetailScreen extends StatefulWidget {
  const CoffeeDetailScreen(
      {super.key, required this.argumentsList});

  final List<dynamic> argumentsList;


  @override
  State<CoffeeDetailScreen> createState() => _CoffeeDetailScreenState();
}

class _CoffeeDetailScreenState extends State<CoffeeDetailScreen> {
  int count = 1;
  late CoffeeModel coffeeModel;
  late int index;

  @override
  void initState() {
    coffeeModel = widget.argumentsList[0];
    index = widget.argumentsList[1];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text("Coffee Detail",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: 24.sp,
            fontFamily: "Montserrat",
          ),),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              physics: const ScrollPhysics(),
              padding: EdgeInsets.all(20.r),
              children: [
                Hero(
                  tag: index,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: CachedNetworkImage(
                      height: 400.h,
                      fit: BoxFit.fill,
                      imageUrl: coffeeModel.coffeeImages.first,
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
                  coffeeModel.coffeeName,
                  style: TextStyle(
                      fontSize: 32.spMin,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  coffeeModel.description,
                  style: TextStyle(
                      fontSize: 22.spMin,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "Price: ${coffeeModel.price} So'm",
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
                        context.read<CoffeeCountCubit>().decrementCount();
                      },
                      child: const Icon(
                        Icons.remove,
                      ),
                    ),
                    Text(
                      context.watch<CoffeeCountCubit>().state.toString(),
                      style: TextStyle(
                          fontSize: 20.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    TextButton(
                        onPressed: () {
                          context.read<CoffeeCountCubit>().incrementCount();
                        },
                        child: const Icon(Icons.add)),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${coffeeModel.price * context.watch<CoffeeCountCubit>().state} ",
                      style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),

                    GlobalButton(
                      onTap: ()async {
                        showProductAlertDialog(context: context, title: "Client info",coffeeModel: coffeeModel,count: count);
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
