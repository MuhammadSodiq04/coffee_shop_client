import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_shop/data/model/coffee_model.dart';
import 'package:coffee_shop/data/provider/coffee_provider.dart';
import 'package:coffee_shop/ui/route/route_names.dart';
import 'package:coffee_shop/utils/ui_utils/constants.dart';
import 'package:coffee_shop/utils/ui_utils/shimmer_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class CoffeeSearch extends SearchDelegate {
  CoffeeSearch();

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
        hintColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.brown,
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600),
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.9),
            fontSize: 16.sp,
            fontFamily: "Montserrat",
          ),
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none),
        ));
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, query);
        },
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(
        query,
          style: TextStyle(
              fontSize: 64.sp,
              color: Colors.brown.withOpacity(0.5),
              fontWeight: FontWeight.w700,
              fontFamily: "Montserrat"),),
      );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<List<CoffeeModel>>(
      stream: context.read<CoffeeProvider>().searchCoffees(query),
      builder:
          (BuildContext context, AsyncSnapshot<List<CoffeeModel>> snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!.isNotEmpty
              ? GridView(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 18.h,),
            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 18.w,
                crossAxisSpacing: 18.w,
                childAspectRatio: 0.75.r),
            children: [
              ...List.generate(
                snapshot.data!.length,
                    (index) {
                  CoffeeModel coffeeModel =
                  snapshot.data![index];
                  return ZoomTapAnimation(
                    onTap: () {
                      Navigator.pushNamed(context, RouteNames.coffeeDetail,arguments: coffeeModel);
                    },
                    child: Container(
                      width: 155.w,
                      height: 230.h,
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(16),
                          color: Colors.brown),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                            child: CachedNetworkImage(
                              height: 172.h,
                              width: 175.w,
                              fit: BoxFit.fill,
                              imageUrl: coffeeModel
                                  .coffeeImages.first,
                              placeholder: (context, url) =>
                              const ShimmerPhoto(),
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.error, color: Colors.red,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Text(
                              coffeeModel.coffeeName,
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontFamily: "Montserrat",
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Text(
                              "${coffeeModel.price} so'm",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontFamily: "Montserrat",
                              ),
                            ),
                          ),
                        ].divide(SizedBox(height: 5.h,)),
                      ),
                    ),
                  );
                },
              ),
            ],
          )
              : Center(
                  child: SizedBox(
                    width: 300.w,
                    child: Text(
                      "Name write fully or Coffee Empty!",
                      style: TextStyle(
                          fontSize: 32.sp,
                          color: Colors.brown.withOpacity(0.5),
                          fontWeight: FontWeight.w700,
                          fontFamily: "Montserrat"),
                    ),
                  ),
                );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        return const Center(child: CircularProgressIndicator(color: Colors.brown,));
      },
    );
  }
}
