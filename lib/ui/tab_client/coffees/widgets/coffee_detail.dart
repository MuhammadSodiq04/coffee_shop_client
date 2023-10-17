import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_shop/data/cubit/coffee_count_cubit.dart';
import 'package:coffee_shop/data/local/storage_repository/storage_repository.dart';
import 'package:coffee_shop/data/model/coffee_model.dart';
import 'package:coffee_shop/data/model/basket_model.dart';
import 'package:coffee_shop/data/provider/basket_provider.dart';
import 'package:coffee_shop/utils/ui_utils/global_button.dart';
import 'package:coffee_shop/utils/ui_utils/global_dialog.dart';
import 'package:coffee_shop/utils/ui_utils/shimmer_photo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CoffeeDetailScreen extends StatefulWidget {
  const CoffeeDetailScreen(
      {super.key, required this.coffeeModel});

  final CoffeeModel coffeeModel;


  @override
  State<CoffeeDetailScreen> createState() => _CoffeeDetailScreenState();
}

class _CoffeeDetailScreenState extends State<CoffeeDetailScreen> {
  late CoffeeModel coffeeModel;

  @override
  void initState() {
    coffeeModel = widget.coffeeModel;
    context.read<CoffeeCountCubit>().defaultCount();
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
      body: ListView(
        physics: const ScrollPhysics(),
        padding: EdgeInsets.all(20.r),
        children: [
          ClipRRect(
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
          SizedBox(
            height: 20.h,
          ),
          Text(
            coffeeModel.coffeeName,
            style: TextStyle(
                fontSize: 32.sp,
                color: Colors.brown,
                fontWeight: FontWeight.w900,
                fontFamily: "Montserrat"),
          ),
          SizedBox(
            height: 20.h,
          ),
          Text(
            coffeeModel.description,
            style: TextStyle(
                fontSize: 18.sp,
                color: Colors.brown,
                fontWeight: FontWeight.w600,
                fontFamily: "Montserrat"),
          ),
          SizedBox(
            height: 20.h,
          ),
          Text(
            "Price: ${coffeeModel.price} so'm",
            style: TextStyle(
                fontSize: 18.sp,
                color: Colors.brown,
                fontWeight: FontWeight.w600,
                fontFamily: "Montserrat"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  "Total price: \n${coffeeModel.price * context.watch<CoffeeCountCubit>().state} So'm",
                  style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.brown,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Montserrat"),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
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
                            color: Colors.brown,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Montserrat"),
                      ),
                      TextButton(
                          onPressed: () {
                            context.read<CoffeeCountCubit>().incrementCount();
                          },
                          child: const Icon(Icons.add)),
                    ],
                  ),
                  GlobalButton(
                    onTap: ()async {
                      showProductAlertDialog(context: context, title: "Client info",coffeeModel: coffeeModel,count: context.read<CoffeeCountCubit>().state);
                    },
                    title: "Add to Card",
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
