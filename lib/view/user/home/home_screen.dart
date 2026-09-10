// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:amazon/constants/common_functions.dart';
import 'package:amazon/constants/constants.dart';
import 'package:amazon/constants/demo_products.dart';
import 'package:amazon/controller/provier/address_provider.dart';
import 'package:amazon/controller/provier/deal_of_the_day_provider/deal_of_the_provider.dart';
import 'package:amazon/controller/services/user_data_crud_services/user_data_CRUD_services.dart';
import 'package:amazon/controller/services/voice_search_service.dart';
import 'package:amazon/model/address_model.dart';
import 'package:amazon/model/product_model.dart';
import 'package:amazon/utils/colors.dart';
import 'package:amazon/view/common_widgets/product_image.dart';
import 'package:amazon/view/common_widgets/wishlist_heart_button.dart';
import 'package:amazon/view/user/address_screen/address_screen.dart';
import 'package:amazon/view/user/product_category_screen/product_category_screen.dart';
import 'package:amazon/view/user/product_screen/product_screen.dart';
import 'package:amazon/view/user/searched_product_screen/searched_product_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CarouselSliderController todaysDealsCarouselController =
      CarouselSliderController();

  checkUserAddress() async {
    bool userAddressPresent = await UserDataCRUD.checkUsersAddress();
    log('user Address Present : ${userAddressPresent.toString()}');
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    if (userAddressPresent == false) {
      showModalBottomSheet(
          backgroundColor: transparent,
          context: context,
          builder: (context) {
            return Container(
              height: height * 0.3,
              padding: EdgeInsets.symmetric(
                  vertical: height * 0.03, horizontal: width * 0.03),
              width: width,
              decoration: BoxDecoration(
                color: white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Address',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(
                    height: height * 0.15,
                    child: ListView.builder(
                        itemCount: 1,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              if (index == 0) {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: const AddressScreen(),
                                    type: PageTransitionType.rightToLeft,
                                  ),
                                );
                              }
                            },
                            child: Container(
                              width: width * 0.35,
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.03,
                                  vertical: height * 0.01),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: greyShade3,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Builder(builder: (context) {
                                if (index == 0) {
                                  return Text(
                                    'Add Address',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: greyShade3),
                                  );
                                }
                                return Text(
                                  'Add Address',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: greyShade3),
                                );
                              }),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            );
          });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkUserAddress();
      context.read<AddressProvider>().getCurrentSelectedAddress();
      context.read<DealOfTheDayProvider>().fetchTodaysDeal();
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: white,
      appBar: PreferredSize(
          preferredSize: Size(width * 1, height * 0.1),
          child: HomePageAppBar(width: width, height: height)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HomeScreenUserAddressBar(height: height, width: width),
            CommonFunctions.divider(),
            const HomeScreenCategoriesList(),
            CommonFunctions.blankSpace(height * 0.01, 0),
            CommonFunctions.divider(),
            HomeScreenBanner(
                height: height, width: width, textTheme: textTheme),
            CommonFunctions.divider(),
            CategoryGridSection(
                height: height, width: width, textTheme: textTheme),
            CommonFunctions.divider(),
            DealsBannerCard(height: height, width: width),
            TodaysDealHomeScreenWidget(
                todaysDealsCarouselController: todaysDealsCarouselController),
            CommonFunctions.divider(),
            const PromoBannerCard(
              imagePath: 'assets/images/banners/fitness.jpg',
              title: 'Fitness & Sports',
            ),
            CommonFunctions.divider(),
            const PromoBannerCard(
              imagePath: 'assets/images/banners/new_arrivals.jpg',
              title: 'New Arrivals',
            ),
            CommonFunctions.blankSpace(height * 0.02, 0),
          ],
        ),
      ),
    );
  }
}

class TodaysDealHomeScreenWidget extends StatelessWidget {
  const TodaysDealHomeScreenWidget({
    super.key,
    required this.todaysDealsCarouselController,
  });

  final CarouselSliderController todaysDealsCarouselController;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.03, vertical: height * 0.01),
        child: Consumer<DealOfTheDayProvider>(
            builder: (context, dealOfTheDayProvider, child) {
          if (dealOfTheDayProvider.dealsFetched == false) {
            return Container(
              height: height * 0.2,
              width: width,
              alignment: Alignment.center,
              child: Text(
                'Loading Latest Deals',
                style: textTheme.bodyMedium,
              ),
            );
          } else {
            // Fall back to static demo products when there's no real
            // inventory yet, so the home screen never shows an empty
            // deal-of-the-day section for a brand-new account.
            final List<ProductModel> deals = dealOfTheDayProvider.deals.isEmpty
                ? demoProducts
                : dealOfTheDayProvider.deals;
            // The full list can now run up to 50 items ("See all Deals"
            // shows all of them); the home screen only previews a small,
            // fixed slice of the highest-discount items (already sorted
            // descending by discount).
            final List<ProductModel> previewDeals = deals.take(4).toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${deals.last.discountPercentage}%-${deals.first.discountPercentage}% off | Latest deals.',
                  style: textTheme.displaySmall!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                CommonFunctions.blankSpace(height * 0.01, 0),
                CarouselSlider(
                  carouselController: todaysDealsCarouselController,
                  options: CarouselOptions(
                    height: height * 0.2,
                    autoPlay: true,
                    viewportFraction: 1,
                  ),
                  items: previewDeals.map((i) {
                    ProductModel currentProduct = i;
                    return Builder(
                      builder: (BuildContext context) {
                        return Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: ProductScreen(
                                        productModel: currentProduct),
                                    type: PageTransitionType.rightToLeft,
                                  ),
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                color: white,
                                child: ProductImage(
                                  imageUrl: currentProduct.imagesURL?.isNotEmpty ==
                                          true
                                      ? currentProduct.imagesURL![0]
                                      : null,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: WishlistHeartButton(
                                  product: currentProduct),
                            ),
                          ],
                        );
                      },
                    );
                  }).toList(),
                ),
                CommonFunctions.blankSpace(
                  height * 0.01,
                  0,
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                          color: red),
                      child: Text(
                        'Upto 62% Off',
                        style: textTheme.labelMedium!.copyWith(color: white),
                      ),
                    ),
                    CommonFunctions.blankSpace(0, width * 0.03),
                    Text(
                      'Deal of the Day',
                      style: textTheme.labelMedium!.copyWith(
                        color: red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                CommonFunctions.blankSpace(height * 0.01, 0),
                GridView.builder(
                    itemCount: previewDeals.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 20),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      ProductModel currentModel = previewDeals[index];
                      return InkWell(
                        onTap: () {
                          log(index.toString());
                          todaysDealsCarouselController.animateToPage(index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: greyShade3,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: ProductImage(
                              imageUrl:
                                  currentModel.imagesURL?.isNotEmpty == true
                                      ? currentModel.imagesURL![0]
                                      : null,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                    }),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child:
                            const ProductCategoryScreen(productCategory: 'Deals'),
                        type: PageTransitionType.rightToLeft,
                      ),
                    );
                  },
                  child: Text(
                    'See all Deals',
                    style: textTheme.bodySmall!.copyWith(
                      color: blue,
                    ),
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}

class HomeScreenBanner extends StatelessWidget {
  const HomeScreenBanner({
    super.key,
    required this.height,
    required this.width,
    required this.textTheme,
  });

  final double height;
  final double width;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height * 0.23,
          width: width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/banners/hero_banner.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: height * 0.23,
          width: width,
          color: Colors.black.withValues(alpha: 0.35),
        ),
        Positioned(
          left: width * 0.06,
          top: height * 0.04,
          right: width * 0.06,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Big Deals. Every Day.',
                style: textTheme.displaySmall!.copyWith(
                  color: white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CommonFunctions.blankSpace(height * 0.008, 0),
              Text(
                'Shop the latest products at great prices',
                style: textTheme.bodyMedium!.copyWith(color: white),
              ),
              CommonFunctions.blankSpace(height * 0.015, 0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child:
                          const ProductCategoryScreen(productCategory: 'Deals'),
                      type: PageTransitionType.rightToLeft,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: amber),
                child: const Text('Shop Now'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CategoryGridSection extends StatelessWidget {
  const CategoryGridSection({
    super.key,
    required this.height,
    required this.width,
    required this.textTheme,
  });

  final double height;
  final double width;
  final TextTheme textTheme;

  static const List<Map<String, String>> _cards = [
    {
      'image': 'women_fashion.jpg',
      'title': "Women's Fashion",
      'category': "Women's Fashion",
    },
    {
      'image': 'men_fashion.jpg',
      'title': "Men's Fashion",
      'category': "Men's Fashion",
    },
    {
      'image': 'electronics.jpg',
      'title': 'Electronics',
      'category': 'Electronics',
    },
    {
      'image': 'home_furniture.jpg',
      'title': 'Home & Furniture',
      'category': 'Furniture',
    },
    {
      'image': 'beauty.jpg',
      'title': 'Beauty',
      'category': 'Beauty',
    },
    {
      'image': 'sports_shoes.jpg',
      'title': 'Sports & Shoes',
      'category': 'Sports & Shoes',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.03,
        vertical: height * 0.01,
      ),
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shop by Category',
            style: textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          CommonFunctions.blankSpace(height * 0.01, 0),
          GridView.builder(
            itemCount: _cards.length,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.3,
            ),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final card = _cards[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: ProductCategoryScreen(
                          productCategory: card['category']!),
                      type: PageTransitionType.rightToLeft,
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image(
                        image: AssetImage(
                            'assets/images/banners/${card['image']}'),
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          color: black38,
                          child: Text(
                            card['title']!,
                            style: textTheme.bodySmall!.copyWith(
                              color: white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class DealsBannerCard extends StatelessWidget {
  const DealsBannerCard({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            child: const ProductCategoryScreen(productCategory: 'Deals'),
            type: PageTransitionType.rightToLeft,
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            height: height * 0.12,
            width: width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/banners/deals.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: height * 0.12,
            width: width,
            color: Colors.black.withValues(alpha: 0.35),
          ),
          Positioned(
            left: width * 0.06,
            top: height * 0.025,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's Deals",
                  style: textTheme.bodyLarge!.copyWith(
                    color: white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Up to 50% Off',
                  style: textTheme.bodySmall!.copyWith(color: white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PromoBannerCard extends StatelessWidget {
  const PromoBannerCard({
    super.key,
    required this.imagePath,
    required this.title,
  });

  final String imagePath;
  final String title;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonFunctions.blankSpace(height * 0.01, 0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.03),
          child: Text(
            title,
            style: textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          width: width,
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.03,
            vertical: height * 0.01,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(
              image: AssetImage(imagePath),
              width: width,
              height: height * 0.2,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}

class HomeScreenCategoriesList extends StatelessWidget {
  const HomeScreenCategoriesList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: height * 0.12,
      width: width,
      child: ListView.builder(
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final String category = categories[index];
          // 'Deals' has its own discount-based query; anything else must be
          // a category a seller can actually assign, or the destination
          // screen would always come back empty.
          final bool isFilterable =
              category == 'Deals' || productCategories.contains(category);
          return InkWell(
            onTap: () {
              if (!isFilterable) {
                CommonFunctions.showWarningToast(
                    context: context, message: '$category coming soon');
                return;
              }
              Navigator.push(
                context,
                PageTransition(
                  child: ProductCategoryScreen(productCategory: category),
                  type: PageTransitionType.rightToLeft,
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: width * 0.02,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image(
                    image: AssetImage(
                      'assets/images/categories/$category.png',
                    ),
                    height: height * 0.07,
                  ),
                  Text(
                    category,
                    style: textTheme.labelMedium,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class HomeScreenUserAddressBar extends StatelessWidget {
  const HomeScreenUserAddressBar({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      height: height * 0.06,
      width: width,
      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: addressBarGradientColor,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child:
          Consumer<AddressProvider>(builder: (context, addressProvider, child) {
        if (addressProvider.fetchedCurrentSelectedAddress &&
            addressProvider.addressPresent) {
          AddressModel selectedAddress = addressProvider.currentSelectedAddress;
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.location_pin,
                color: black,
              ),
              CommonFunctions.blankSpace(
                0,
                width * 0.02,
              ),
              Text(
                'Deliver to ${selectedAddress.name} - ${selectedAddress.town}, ${selectedAddress.state}',
                style: textTheme.bodySmall,
              )
            ],
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.location_pin,
                color: black,
              ),
              CommonFunctions.blankSpace(
                0,
                width * 0.02,
              ),
              Text('Deliver to user - City, State', style: textTheme.bodySmall)
            ],
          );
        }
      }),
    );
  }
}

class HomePageAppBar extends StatelessWidget {
  const HomePageAppBar({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(),

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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  child: const SearchedProductScreen(),
                  type: PageTransitionType.rightToLeft,
                ),
              );
            },
            child: Container(
              width: width * 0.81,
              height: height * 0.06,
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  5,
                ),
                border: Border.all(
                  color: grey,
                ),
                color: white,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: black,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: width * 0.03,
                    ),
                    child: Text(
                      'Search products',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: grey),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () async {
                      // Placeholder for a future visual-search feature: this
                      // only lets the user take a photo, it does not run
                      // any image-based product matching yet.
                      try {
                        final XFile? photo = await picker.pickImage(
                            source: ImageSource.camera);
                        if (photo == null) return;
                        if (!context.mounted) return;
                        CommonFunctions.showWarningToast(
                            context: context,
                            message:
                                'Photo captured — visual product search coming soon');
                      } catch (e) {
                        if (!context.mounted) return;
                        CommonFunctions.showErrorToast(
                            context: context,
                            message: 'Camera isn\'t available on this device.');
                      }
                    },
                    child: Icon(
                      Icons.camera_alt_sharp,
                      color: grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
              onPressed: () async {
                await VoiceSearchService.listen(
                  context: context,
                  onResult: (recognizedText) {
                    if (!context.mounted) return;
                    Navigator.push(
                      context,
                      PageTransition(
                        child: SearchedProductScreen(
                            initialQuery: recognizedText),
                        type: PageTransitionType.rightToLeft,
                      ),
                    );
                  },
                );
              },
              icon: Icon(
                Icons.mic,
                color: black,
              ))
        ],
      ),
    );
  }
}
