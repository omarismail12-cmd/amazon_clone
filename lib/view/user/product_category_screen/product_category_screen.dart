// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:amazon/controller/provier/users_product_provider/users_product_provider.dart';
import 'package:amazon/controller/services/users_product_services/users_product_services.dart';
import 'package:amazon/model/product_model.dart';
import 'package:amazon/view/common_widgets/empty_state.dart';
import 'package:amazon/view/common_widgets/product_card.dart';
import 'package:amazon/view/common_widgets/shimmer_box.dart';
import 'package:amazon/view/user/product_screen/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../../../controller/provier/product_by_category_provider/product_by_category_provider.dart';
import '../../../utils/colors.dart';

class ProductCategoryScreen extends StatefulWidget {
  const ProductCategoryScreen({super.key, required this.productCategory});
  final String productCategory;
  @override
  State<ProductCategoryScreen> createState() => _ProductCategoryScreenState();
}

class _ProductCategoryScreenState extends State<ProductCategoryScreen> {
  TextEditingController searchController = TextEditingController();

  getDay(int dayNum) {
    switch (dayNum % 7) {
      case 0:
        return 'Monday';
      case 1:
        return 'Tuesday';
      case 2:
        return 'Wednesday';
      case 3:
        return 'Thursday';
      case 4:
        return 'Friday';
      case 5:
        return 'Saturday';
      case 6:
        return 'Sunday';
      default:
        'Sunday';
    }
  }

  getMonth(int deliveryDate) {
    if (DateTime.now().month == 2) {
      if (deliveryDate > 28) {
        return 'March';
      } else {
        return 'Febuary';
      }
    }
    if (DateTime.now().month == 4 ||
        DateTime.now().month == 6 ||
        DateTime.now().month == 8 ||
        DateTime.now().month == 10 ||
        DateTime.now().month == 12) {
      if ((deliveryDate > 30) && (DateTime.now().month == 12)) {
        return 'January';
      }
      if (deliveryDate > 30) {
        int month = DateTime.now().month + 1;
        switch (month) {
          case 1:
            return 'January';

          case 2:
            return 'February';

          case 3:
            return 'March';

          case 4:
            return 'April';

          case 5:
            return 'May';

          case 6:
            return 'June';

          case 7:
            return 'July';

          case 8:
            return 'August';

          case 9:
            return 'September';

          case 10:
            return 'October';

          case 11:
            return 'November';
          case 12:
            return 'December';
        }
      } else {
        int month = DateTime.now().month;
        switch (month) {
          case 1:
            return 'January';

          case 2:
            return 'February';

          case 3:
            return 'March';

          case 4:
            return 'April';

          case 5:
            return 'May';

          case 6:
            return 'June';

          case 7:
            return 'July';

          case 8:
            return 'August';

          case 9:
            return 'September';

          case 10:
            return 'October';

          case 11:
            return 'November';
          case 12:
            return 'December';
        }
      }
    }
    log(DateTime.now().month.toString());
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductsBasedOnCategoryProvider>().fetchProducts(
            category: widget.productCategory,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size(width, height * 0.1),
            child: Container(
              padding: EdgeInsets.only(
                  left: width * 0.03,
                  right: width * 0.03,
                  bottom: height * 0.012,
                  top: height * 0.045),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: appBarGradientColor,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: black,
                    ),
                  ),
                  SizedBox(
                    width: width * 0.68,
                    child: TextField(
                      controller: searchController,
                      onSubmitted: (productName) {
                        // log(productName);
                        context
                            .read<UsersProductProvider>()
                            .getSearchedProducts(productName: productName);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search',
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.mic,
                        color: black,
                      ))
                ],
              ),
            )),
        body: Consumer<ProductsBasedOnCategoryProvider>(
            builder: (context, usersProductProvider, child) {
          if (usersProductProvider.productsFetched == false) {
            return ListView.builder(
              itemCount: 4,
              shrinkWrap: true,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.03,
                  vertical: height * 0.007,
                ),
                child: ShimmerBox(
                  width: width,
                  height: height * 0.4,
                  borderRadius: 16,
                ),
              ),
            );
          } else {
            if (usersProductProvider.products.isEmpty) {
              return const EmptyState(
                icon: Icons.search_off,
                message: 'Opps! Product not found',
              );
            } else {
              return ListView.builder(
                  itemCount: usersProductProvider.products.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    ProductModel currentProduct =
                        usersProductProvider.products[index];
                    return ProductCard(
                      product: currentProduct,
                      height: height,
                      width: width,
                      onTap: () async {
                        await UsersProductService.addRecentlySeenProduct(
                          context: context,
                          productModel: currentProduct,
                        );
                        Navigator.push(
                          context,
                          PageTransition(
                            child: ProductScreen(productModel: currentProduct),
                            type: PageTransitionType.rightToLeft,
                          ),
                        );
                      },
                    );
                  });
            }
          }
        }));
  }
}
