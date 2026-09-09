import 'package:amazon/constants/common_functions.dart';
import 'package:amazon/controller/services/users_product_services/users_product_services.dart';
import 'package:amazon/model/product_model.dart';
import 'package:amazon/utils/colors.dart';
import 'package:amazon/view/user/product_screen/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class BrowsingHistoryScreen extends StatelessWidget {
  const BrowsingHistoryScreen({super.key});

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
                'Browsing History',
                style: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder<List<ProductModel>>(
        stream: UsersProductService.fetchKeepShoppingForProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Opps! There was an Error', style: textTheme.bodyMedium),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final List<ProductModel> products = snapshot.data!;
          if (products.isEmpty) {
            return Center(
              child: Text(
                'Nothing here yet — start browsing to see items here',
                style: textTheme.bodyMedium,
              ),
            );
          }
          return GridView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.03,
              vertical: height * 0.02,
            ),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.8),
            itemBuilder: (context, index) {
              ProductModel currentProduct = products[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: ProductScreen(productModel: currentProduct),
                      type: PageTransitionType.rightToLeft,
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: greyShade3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image(
                          image: NetworkImage(currentProduct.imagesURL![0]),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    CommonFunctions.blankSpace(height * 0.005, 0),
                    Text(
                      currentProduct.name!,
                      maxLines: 2,
                      style: textTheme.labelLarge,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
