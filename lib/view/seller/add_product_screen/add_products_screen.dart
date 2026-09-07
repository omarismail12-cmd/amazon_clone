// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'package:amazon/constants/common_functions.dart';
import 'package:amazon/constants/constants.dart';
import 'package:amazon/controller/provier/product_provider/product_provider.dart';
import 'package:amazon/model/product_model.dart';
import 'package:amazon/view/seller/add_product_screen/widget/product_details_common_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../controller/services/product_services/product_services.dart';
import '../../../utils/colors.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController brandNameController = TextEditingController();
  TextEditingController manufacturerNameController = TextEditingController();
  TextEditingController countryOfOriginController = TextEditingController();
  TextEditingController productSpecificationsController =
      TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController discountedProductPriceController =
      TextEditingController();
  String dropDownValue = 'Select Category';
  bool addProductBtnPressed = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SellerProductProvider>().emptyProductImagesList();
      setState(() {
        addProductBtnPressed = false;
      });
    });
  }

  onPressed() async {
    if (context.read<SellerProductProvider>().productImages.isEmpty) {
      return;
    }
    if (dropDownValue == 'Select Category') {
      CommonFunctions.showWarningToast(
          context: context, message: 'Please select a category');
      return;
    }
    final price = double.tryParse(productPriceController.text.trim());
    final discountedPrice =
        double.tryParse(discountedProductPriceController.text.trim());
    if (price == null || discountedPrice == null || price <= 0) {
      CommonFunctions.showWarningToast(
          context: context, message: 'Please enter valid prices');
      return;
    }

    setState(() {
      addProductBtnPressed = true;
    });
    final uploadSuccess = await ProductServices.uploadImages(
        images: context.read<SellerProductProvider>().productImages,
        context: context);
    if (!uploadSuccess) {
      setState(() {
        addProductBtnPressed = false;
      });
      return;
    }
    List<String> imagesURLs =
        context.read<SellerProductProvider>().productImagesURL;
    Uuid uuid = const Uuid();
    String sellerID = auth.currentUser!.phoneNumber!;
    String productID = '$sellerID${uuid.v1()}';
    double discountAmount = price - discountedPrice;
    double discountPercentage = (discountAmount / price) * 100;
    ProductModel model = ProductModel(
      imagesURL: imagesURLs,
      name: productNameController.text.trim(),
      category: dropDownValue,
      description: productDescriptionController.text.trim(),
      brandName: brandNameController.text.trim(),
      manufacturerName: manufacturerNameController.text.trim(),
      countryOfOrigin: countryOfOriginController.text.trim(),
      specifications: productSpecificationsController.text.trim(),
      price: price,
      discountedPrice: discountedPrice,
      productID: productID,
      productSellerID: sellerID,
      inStock: true,
      uploadedAt: DateTime.now(),
      discountPercentage: int.parse(
        discountPercentage.toStringAsFixed(
          0,
        ),
      ),
    );

    final addSuccess = await ProductServices.addProduct(
        context: context, productModel: model);
    if (!addSuccess) {
      setState(() {
        addProductBtnPressed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(width, height * 0.1),
        child: AddProductAppBar(
            width: width, height: height, textTheme: textTheme),
      ),
      body: Container(
        width: width,
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.03,
          vertical: height * 0.02,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ProductImageBanner(
                  height: height, width: width, textTheme: textTheme),
              CommonFunctions.blankSpace(height * 0.02, 0),
              productDetails(height, textTheme, width),
              CommonFunctions.blankSpace(height * 0.03, 0),
              ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: amber,
                    minimumSize: Size(
                      width,
                      height * 0.06,
                    ),
                  ),
                  child: addProductBtnPressed
                      ? CircularProgressIndicator(
                          color: white,
                        )
                      : Text(
                          'Add Product',
                          style: textTheme.bodyMedium,
                        )),
              CommonFunctions.blankSpace(height * 0.03, 0),
            ],
          ),
        ),
      ),
    );
  }

  Column productDetails(double height, TextTheme textTheme, double width) {
    return Column(
      children: [
        AddProductCommonTextField(
          title: 'Product Name',
          hintText: 'name',
          textController: productNameController,
        ),
        CommonFunctions.blankSpace(height * 0.015, 0),
        productCategoryDropdown(textTheme, height, width),
        CommonFunctions.blankSpace(height * 0.015, 0),
        AddProductCommonTextField(
          title: 'Description',
          hintText: 'description',
          textController: productDescriptionController,
        ),
        CommonFunctions.blankSpace(height * 0.015, 0),
        AddProductCommonTextField(
          title: 'Manufacturer Name',
          hintText: 'name',
          textController: manufacturerNameController,
        ),
        CommonFunctions.blankSpace(height * 0.015, 0),
        AddProductCommonTextField(
          title: 'Brand Name',
          hintText: 'name',
          textController: brandNameController,
        ),
        CommonFunctions.blankSpace(height * 0.015, 0),
        AddProductCommonTextField(
          title: 'Country of Origin',
          hintText: '',
          textController: countryOfOriginController,
        ),
        CommonFunctions.blankSpace(height * 0.015, 0),
        AddProductCommonTextField(
          title: 'Product Specification',
          hintText: 'specification',
          textController: productSpecificationsController,
        ),
        CommonFunctions.blankSpace(height * 0.015, 0),
        AddProductCommonTextField(
          title: 'Product Price',
          hintText: 'price',
          textController: productPriceController,
          textInputType: TextInputType.number,
        ),
        CommonFunctions.blankSpace(height * 0.015, 0),
        AddProductCommonTextField(
          title: 'Discounted Product Price',
          hintText: 'Discounted price',
          textController: discountedProductPriceController,
          textInputType: TextInputType.number,
        ),
      ],
    );
  }

  Column productCategoryDropdown(
      TextTheme textTheme, double height, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Category',
          style: textTheme.bodyMedium,
        ),
        CommonFunctions.blankSpace(
          height * 0.01,
          0,
        ),
        Container(
          height: height * 0.06,
          padding: EdgeInsets.symmetric(horizontal: width * 0.03),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              10,
            ),
            border: Border.all(
              color: grey,
            ),
          ),
          child: DropdownButton(
            value: dropDownValue,
            underline: const SizedBox(),
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down),
            items: productCategories.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  dropDownValue = newValue;
                });
              }
            },
          ),
        ),
      ],
    );
  }
}

class AddProductAppBar extends StatelessWidget {
  const AddProductAppBar({
    super.key,
    required this.width,
    required this.height,
    required this.textTheme,
  });

  final double width;
  final double height;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Add Product',
            style:
                textTheme.displayMedium!.copyWith(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}

class ProductImageBanner extends StatelessWidget {
  const ProductImageBanner({
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
    return Consumer<SellerProductProvider>(
        builder: (context, productProvider, child) {
      return Builder(builder: (context) {
        if (productProvider.productImages.isEmpty) {
          return InkWell(
            onTap: () {
              context
                  .read<SellerProductProvider>()
                  .fetchProductImagesFromGallery(context: context);
            },
            child: Container(
              height: height * 0.23,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: greyShade3,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    size: height * 0.09,
                    color: greyShade3,
                  ),
                  Text(
                    'Add Product',
                    style: textTheme.displayMedium!.copyWith(
                      color: greyShade3,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          List<Uint8List> images = productProvider.productImages;
          final double thumbnailSize = height * 0.23;
          return SizedBox(
            height: thumbnailSize,
            width: width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images.length + 1,
              itemBuilder: (context, index) {
                if (index == images.length) {
                  return InkWell(
                    onTap: () {
                      context
                          .read<SellerProductProvider>()
                          .fetchProductImagesFromGallery(context: context);
                    },
                    child: Container(
                      height: thumbnailSize,
                      width: thumbnailSize,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: greyShade3,
                        ),
                      ),
                      child: Icon(
                        Icons.add,
                        size: height * 0.06,
                        color: greyShade3,
                      ),
                    ),
                  );
                }
                return Padding(
                  padding: EdgeInsets.only(right: width * 0.02),
                  child: Stack(
                    children: [
                      Container(
                        height: thumbnailSize,
                        width: thumbnailSize,
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: greyShade3,
                          ),
                          image: DecorationImage(
                            image: MemoryImage(images[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: InkWell(
                          onTap: () {
                            context
                                .read<SellerProductProvider>()
                                .removeProductImage(index);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: black38,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              size: height * 0.025,
                              color: white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }
      });
    });
  }
}
