// ignore_for_file: use_build_context_synchronously

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
import '../../../utils/colors.dart';

class SearchedProductScreen extends StatefulWidget {
  const SearchedProductScreen({super.key});

  @override
  State<SearchedProductScreen> createState() => _SearchedProductScreenState();
}

class _SearchedProductScreenState extends State<SearchedProductScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UsersProductProvider>().emptySearchedProductsList();
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
        body: Consumer<UsersProductProvider>(
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
            if (usersProductProvider.searchedProducts.isEmpty) {
              return const EmptyState(
                icon: Icons.search_off,
                message: 'Opps! Product not found',
              );
            } else {
              return ListView.builder(
                  itemCount: usersProductProvider.searchedProducts.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    ProductModel currentProduct =
                        usersProductProvider.searchedProducts[index];
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
