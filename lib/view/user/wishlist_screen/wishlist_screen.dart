import 'package:amazon/constants/common_functions.dart';
import 'package:amazon/controller/services/users_product_services/users_product_services.dart';
import 'package:amazon/model/product_model.dart';
import 'package:amazon/model/user_product_model.dart';
import 'package:amazon/utils/colors.dart';
import 'package:amazon/view/user/product_screen/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
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
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: black),
              ),
              Text(
                'Your Wish List',
                style: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder<List<UserProductModel>>(
        stream: UsersProductService.fetchWishlist(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(color: amber));
          }
          final List<UserProductModel> items = snapshot.data!;
          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                child: Text(
                  'Your Wish List is empty. Tap the heart on any product to save it here.',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium,
                ),
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: height * 0.01),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final UserProductModel item = items[index];
              final ProductModel product = ProductModel(
                imagesURL: item.imagesURL,
                name: item.name,
                category: item.category,
                description: item.description,
                brandName: item.brandName,
                manufacturerName: item.manufacturerName,
                countryOfOrigin: item.countryOfOrigin,
                specifications: item.specifications,
                price: item.price,
                discountedPrice: item.discountedPrice,
                productID: item.productID,
                productSellerID: item.productSellerID,
                inStock: item.inStock,
                discountPercentage: item.discountPercentage,
                uploadedAt: item.time,
              );
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: ProductScreen(productModel: product),
                      type: PageTransitionType.rightToLeft,
                    ),
                  );
                },
                child: Container(
                  height: height * 0.18,
                  margin: EdgeInsets.symmetric(
                    horizontal: width * 0.03,
                    vertical: height * 0.007,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: greyShade3),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Stack(
                          children: [
                            Container(
                              color: greyShade1,
                              child: Image.network(
                                item.imagesURL![0],
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () async {
                                  await UsersProductService.removeFromWishlist(
                                    context: context,
                                    productId: item.productID!,
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.favorite,
                                    color: red,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.03,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item.name ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodySmall!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              CommonFunctions.blankSpace(height * 0.01, 0),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '\$ ',
                                      style: textTheme.bodyMedium,
                                    ),
                                    TextSpan(
                                      text: item.discountedPrice!
                                          .toStringAsFixed(0),
                                      style: textTheme.bodyLarge!.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          '\tMRP: \$${item.price!.toStringAsFixed(0)}',
                                      style: textTheme.labelMedium!.copyWith(
                                        color: grey,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
