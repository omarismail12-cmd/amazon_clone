import 'package:amazon/controller/services/users_product_services/users_product_services.dart';
import 'package:amazon/model/product_model.dart';
import 'package:amazon/model/user_product_model.dart';
import 'package:amazon/utils/colors.dart';
import 'package:flutter/material.dart';

/// Heart toggle shown on product cards and the product detail screen.
/// Reflects and drives wishlist state directly off Firestore snapshots, so
/// toggling updates the icon as soon as the local write lands (no manual
/// optimistic-state bookkeeping needed).
class WishlistHeartButton extends StatelessWidget {
  const WishlistHeartButton({
    super.key,
    required this.product,
    this.size = 22,
  });

  final ProductModel product;
  final double size;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: UsersProductService.isProductWishlisted(product.productID!),
      builder: (context, snapshot) {
        final bool wishlisted = snapshot.data ?? false;
        return InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () async {
            if (wishlisted) {
              await UsersProductService.removeFromWishlist(
                context: context,
                productId: product.productID!,
              );
            } else {
              final UserProductModel model = UserProductModel(
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
                time: DateTime.now(),
              );
              await UsersProductService.addToWishlist(
                context: context,
                productModel: model,
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              wishlisted ? Icons.favorite : Icons.favorite_border,
              color: wishlisted ? red : grey,
              size: size,
            ),
          ),
        );
      },
    );
  }
}
