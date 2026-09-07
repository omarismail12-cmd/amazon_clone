// ignore_for_file: use_build_context_synchronously, avoid_function_literals_in_foreach_calls

import 'dart:developer';
import 'dart:typed_data';

import 'package:amazon/constants/common_functions.dart';
import 'package:amazon/controller/provier/product_provider/product_provider.dart';
import 'package:amazon/controller/services/imgbb_service.dart';
import 'package:amazon/model/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../constants/constants.dart';
import '../../../model/user_product_model.dart';

class ProductServices {
  static Future getImages({required BuildContext context}) async {
    List<Uint8List> selectedImages = [];
    final pickedFile = await picker.pickMultiImage(
      imageQuality: 100,
    );
    List<XFile> filePick = pickedFile;

    if (filePick.isNotEmpty) {
      for (var i = 0; i < filePick.length; i++) {
        selectedImages.add(await filePick[i].readAsBytes());
      }
    } else {
      CommonFunctions.showWarningToast(
          context: context, message: 'No Image Selected');
    }
    log('The Images are \n${selectedImages.length} image(s) selected');
    return selectedImages;
  }

  static Future<bool> uploadImages({
    required List<Uint8List> images,
    required BuildContext context,
  }) async {
    List<String> imagesURL = [];

    for (var i = 0; i < images.length; i++) {
      if (images[i].lengthInBytes > ImgBBService.maxImageSizeBytes) {
        CommonFunctions.showErrorToast(
          context: context,
          message:
              'Opps! Image ${i + 1} of ${images.length} is too large (max 10MB)',
        );
        return false;
      }
      final imageURL = await ImgBBService.uploadImageBytes(images[i]);
      if (imageURL == null) {
        CommonFunctions.showErrorToast(
          context: context,
          message: 'Opps! Failed to upload image ${i + 1} of ${images.length}',
        );
        return false;
      }
      imagesURL.add(imageURL);
    }

    context
        .read<SellerProductProvider>()
        .updateProductImagesURL(imageURLs: imagesURL);
    return true;
  }

  static Future<bool> addProduct({
    required BuildContext context,
    required ProductModel productModel,
  }) async {
    try {
      await firestore
          .collection('Products')
          .doc(productModel.productID)
          .set(productModel.toMap());
      log('Data Added');
      context.read<SellerProductProvider>().fecthSellerProducts();
      Navigator.pop(context);
      CommonFunctions.showSuccessToast(
          context: context, message: 'Product Added Successful');
      return true;
    } catch (e) {
      log(e.toString());
      CommonFunctions.showErrorToast(context: context, message: e.toString());
      return false;
    }
  }

  static Future<List<ProductModel>> getSellersProducts() async {
    List<ProductModel> sellersProducts = [];

    try {
      // Filtering by productSellerID and ordering by uploadedAt on the same
      // query needs a composite Firestore index, which this project doesn't
      // define. Rather than depend on one existing in the console, filter
      // only (a single-field equality query needs no index) and sort the
      // results client-side instead.
      final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('Products')
          .where('productSellerID', isEqualTo: auth.currentUser!.phoneNumber)
          .get();

      snapshot.docs.forEach((element) {
        sellersProducts.add(ProductModel.fromMap(element.data()));
      });
      sellersProducts.sort((a, b) =>
          (b.uploadedAt ?? DateTime(0)).compareTo(a.uploadedAt ?? DateTime(0)));
      log(sellersProducts.toList().toString());
    } catch (e) {
      log('error Found');
      log(e.toString());
    }
    log(sellersProducts.toList().toString());
    return sellersProducts;
  }

  static Future addSalesData({
    required BuildContext context,
    required UserProductModel productModel,
    required String userID,
  }) async {
    try {
      Uuid uuid = const Uuid();
      await firestore
          .collection('productSaleData')
          .doc(productModel.productID)
          .collection('purchase_history')
          .doc(userID + uuid.v1())
          .set(productModel.toMap())
          .whenComplete(() {
        log('Data Added');

        // CommonFunctions.showSuccessToast(
        //     context: context, message: 'Product Added Successful');
      });
    } catch (e) {
      log(e.toString());
      CommonFunctions.showErrorToast(context: context, message: e.toString());
    }
  }

  static Stream<List<UserProductModel>> fetchSalesPerProduct(
          {required String productID}) =>
      firestore
          .collection('productSaleData')
          .doc(productID)
          .collection('purchase_history')

          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) {
                return UserProductModel.fromMap(doc.data());
              }).toList());

  /// Whether any of the seller's products have at least one sale recorded.
  /// Used to distinguish a genuine "no sales yet" empty state from a
  /// screen that has nothing to show for every product individually.
  static Future<bool> sellerHasAnySales(
      {required List<String> productIDs}) async {
    try {
      for (final productID in productIDs) {
        final snapshot = await firestore
            .collection('productSaleData')
            .doc(productID)
            .collection('purchase_history')
            .limit(1)
            .get();
        if (snapshot.docs.isNotEmpty) {
          return true;
        }
      }
      return false;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
