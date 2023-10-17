import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:coffee_shop/data/model/coffee_model.dart';
import 'package:coffee_shop/data/provider/coffee_provider.dart';
import 'package:coffee_shop/ui/route/route_names.dart';
import 'package:coffee_shop/ui/tab_client/coffees/widgets/coffee_detail.dart';
import 'package:coffee_shop/ui/tab_client/coffees/widgets/coffee_search_screen.dart';
import 'package:coffee_shop/utils/ui_utils/constants.dart';
import 'package:coffee_shop/utils/ui_utils/shimmer_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class CoffeeScreen extends StatefulWidget {
  const CoffeeScreen({super.key});

  @override
  State<CoffeeScreen> createState() => _CoffeeScreenState();
}

class _CoffeeScreenState extends State<CoffeeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.brown,
        ),
        backgroundColor: Colors.brown,
        title: Text(
          "Coffee",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: 24.sp,
            fontFamily: "Montserrat",
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await showSearch(
                context: context,
                delegate: CoffeeSearch(),
              );
            },
            icon: Icon(Icons.search, size: 30.r),
          ),
        ],
      ),
      body: StreamBuilder<List<CoffeeModel>>(
        stream: context.read<CoffeeProvider>().getCoffees(),
        builder:
            (BuildContext context, AsyncSnapshot<List<CoffeeModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: <Widget>[
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: Text(
                    "New Coffees",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.brown,
                      fontSize: 24.sp,
                      fontFamily: "Montserrat",
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 280.h,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 6),
                    autoPlayCurve: Curves.fastOutSlowIn,
                  ),
                  items: [
                    ...List.generate(snapshot.data!.length, (index) {
                      CoffeeModel coffeeModel = snapshot.data![index];
                      return ZoomTapAnimation(
                        onTap: () {
                          Navigator.pushNamed(context, RouteNames.coffeeDetail,
                              arguments: coffeeModel);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 10.w,
                            right: 10.w,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.brown),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 300.w,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16)),
                                    child: CachedNetworkImage(
                                      height: 225.h,
                                      fit: BoxFit.fill,
                                      imageUrl:
                                          coffeeModel.coffeeImages.first,
                                      placeholder: (context, url) =>
                                          const ShimmerPhoto(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  child: Text(
                                    coffeeModel.coffeeName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontSize: 22.sp,
                                      fontFamily: "Montserrat",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    })
                  ],
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: Text(
                    "Popular Coffees",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.brown,
                      fontSize: 24.sp,
                      fontFamily: "Montserrat",
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                StreamBuilder<List<CoffeeModel>>(
                  stream: context.read<CoffeeProvider>().getCoffees(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<CoffeeModel>> snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!.isNotEmpty
                          ? SizedBox(
                              height: 258.h *
                                  (snapshot.data!.length.isOdd
                                      ? (snapshot.data!.length + 1) ~/ 2
                                      : snapshot.data!.length ~/ 2),
                              child: GridView(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(horizontal: 18.w),
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
                              ),
                            )
                          : Center(
                              child: Text(
                                "Coffee Empty!",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontSize: 32.sp,
                                  fontFamily: "Montserrat",
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
                ),
              ],
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          return const Center(child: CircularProgressIndicator(color: Colors.brown,));
        },
      ),
    );
  }
}
