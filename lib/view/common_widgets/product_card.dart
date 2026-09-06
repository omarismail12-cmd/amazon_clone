import 'dart:developer';

import 'package:amazon/constants/common_functions.dart';
import 'package:amazon/controller/services/rating_services/rating_services.dart';
import 'package:amazon/controller/services/users_product_services/users_product_services.dart';
import 'package:amazon/model/product_model.dart';
import 'package:amazon/model/user_product_model.dart';
import 'package:amazon/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

dynamic _getDeliveryDay(int dayNum) {
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

dynamic _getDeliveryMonth(int deliveryDate) {
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

/// Shared product tile (image + name + rating + price + Add to Cart) used by
/// the category-listing and search-results screens, which previously each
/// had their own copy of this layout.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.height,
    required this.width,
  });

  final ProductModel product;
  final VoidCallback onTap;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: height * 0.4,
        width: width,
        decoration: BoxDecoration(
          color: white,
          border: Border.all(color: greyShade3),
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: width * 0.03,
          vertical: height * 0.007,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(16),
                ),
                child: Container(
                  color: greyShade1,
                  child: Image.network(
                    product.imagesURL![0],
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.02,
                  vertical: height * 0.03,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name ?? '',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    CommonFunctions.blankSpace(height * 0.005, 0),
                    _ProductRatingRow(
                        productID: product.productID!, width: width),
                    CommonFunctions.blankSpace(height * 0.01, 0),
                    RichText(
                      maxLines: 2,
                      text: TextSpan(
                        children: [
                          TextSpan(text: '₹ ', style: textTheme.bodyMedium),
                          TextSpan(
                            text: product.discountedPrice!.toStringAsFixed(0),
                            style: textTheme.bodyLarge!
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          TextSpan(
                            text: '\tMRP: ',
                            style: textTheme.labelMedium!.copyWith(color: grey),
                          ),
                          TextSpan(
                            text: '₹${product.price!.toStringAsFixed(0)}',
                            style: textTheme.labelMedium!.copyWith(
                              color: grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          TextSpan(
                            text:
                                '\t(${product.discountPercentage!.toStringAsFixed(0)}% Off)',
                            style: textTheme.labelMedium!.copyWith(color: grey),
                          ),
                        ],
                      ),
                    ),
                    CommonFunctions.blankSpace(height * 0.01, 0),
                    Text(
                      'Save extra with No Cost EMI',
                      style: textTheme.labelMedium!.copyWith(color: grey),
                    ),
                    CommonFunctions.blankSpace(height * 0.01, 0),
                    RichText(
                      maxLines: 2,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Get it by ',
                            style: textTheme.labelMedium!.copyWith(color: grey),
                          ),
                          TextSpan(
                            text: _getDeliveryDay(DateTime.now().weekday + 3),
                            style: textTheme.labelMedium!.copyWith(
                                color: black, fontWeight: FontWeight.w600),
                          ),
                          TextSpan(
                            text: ', ${DateTime.now().day + 3} ',
                            style: textTheme.labelMedium!.copyWith(
                                color: black, fontWeight: FontWeight.w600),
                          ),
                          TextSpan(
                            text: _getDeliveryMonth(DateTime.now().month),
                            style: textTheme.labelMedium!.copyWith(
                                color: black, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    CommonFunctions.blankSpace(height * 0.01, 0),
                    Text(
                      product.discountedPrice! > 500
                          ? 'FREE Delivery by Amazon'
                          : 'Extra delivery charges Applied',
                      style: textTheme.labelMedium!.copyWith(color: grey),
                    ),
                    CommonFunctions.blankSpace(height * 0.01, 0),
                    ElevatedButton(
                      onPressed: () async {
                        UserProductModel model = UserProductModel(
                          imagesURL: product.imagesURL,
                          name: product.name,
                          category: product.category,
                          description: product.description,
                          brandName: product.brandName,
                          manufacturerName: product.manufacturerName,
                          countryOfOrigin: product.countryOfOrigin,
                          specifications: product.specifications,
                          price: product.price,
                          discountedPrice: product.discountedPrice,
                          productID: product.productID,
                          productSellerID: product.productSellerID,
                          inStock: product.inStock,
                          discountPercentage: product.discountPercentage,
                          productCount: 1,
                          time: DateTime.now(),
                        );
                        await UsersProductService.addProductToCart(
                          context: context,
                          productModel: model,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(width, height * 0.05),
                      ),
                      child: const Text('Add to Cart'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductRatingRow extends StatelessWidget {
  const _ProductRatingRow({required this.productID, required this.width});

  final String productID;
  final double width;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return StreamBuilder(
      stream: RatingServices.fetchReview(productID: productID),
      builder: (context, snapshot) {
        double average = 0;
        int count = 0;
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          average = snapshot.data!.fold(0.0,
                  (previousValue, product) => previousValue + product.rating) /
              snapshot.data!.length;
          count = snapshot.data!.length;
        }
        return Row(
          children: [
            Text(
              average == 0 ? '0.0' : average.toString(),
              style: textTheme.labelMedium!.copyWith(color: teal),
            ),
            CommonFunctions.blankSpace(0, width * 0.01),
            RatingBar(
              initialRating: average,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: width * 0.04,
              ignoreGestures: true,
              ratingWidget: RatingWidget(
                full: Icon(Icons.star, color: amber),
                half: Icon(Icons.star_half, color: amber),
                empty: Icon(Icons.star_outline_sharp, color: amber),
              ),
              itemPadding: EdgeInsets.zero,
              onRatingUpdate: (rating) {},
            ),
            CommonFunctions.blankSpace(0, width * 0.02),
            Text('($count)', style: textTheme.labelMedium),
          ],
        );
      },
    );
  }
}
