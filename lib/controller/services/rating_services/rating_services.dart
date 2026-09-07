// ignore_for_file: use_build_context_synchronously, avoid_function_literals_in_foreach_calls

import 'dart:developer';
import 'dart:typed_data';
import 'package:amazon/controller/provier/rating_provider/rating_provider.dart';
import 'package:amazon/controller/services/imgbb_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../constants/common_functions.dart';
import '../../../constants/constants.dart';
import '../../../model/review_model.dart';

class RatingServices {
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

    context.read<RatingProvider>().updateProductImagesURL(imageURLs: imagesURL);
    return true;
  }

  static Future checkUserPurchasedTheProduct(
      {required String productID}) async {
    bool productPurchased = false;
    try {
      await firestore
          .collection('Orders')
          .doc(auth.currentUser!.phoneNumber)
          .collection('myOrders')
          .where('productID', isEqualTo: productID)
          .get()
          .then((value) {
        value.size > 0 ? productPurchased = true : productPurchased = false;
        log('Product Purchased $productPurchased');
      });
    } catch (e) {
      log(e.toString());
    }

    return productPurchased;
  }

  static Future<bool> checkUserRating({required String productID}) async {
    bool userPresent = false;
    try {
      await firestore
          .collection('ReviewNRatings')
          .doc(productID)
          .collection('rating')
          .where('userID', isEqualTo: auth.currentUser!.phoneNumber)
          .get()
          .then((value) {
        value.size > 0 ? userPresent = true : userPresent = false;
        log(value.toString());
      });
    } catch (e) {
      log(e.toString());
    }
    log(userPresent.toString());
    return userPresent;
  }

  static Stream<List<ReviewModel>> fetchReview({required String productID}) =>
      firestore
          .collection('ReviewNRatings')
          .doc(productID)
          .collection('rating')
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) {
                return ReviewModel.fromMap(doc.data());
              }).toList());

  static Future addReview({
    required BuildContext context,
    required String productID,
    required ReviewModel reviewModel,
    required String userID,
  }) async {
    try {
      Uuid uuid = const Uuid();
      await firestore
          .collection('ReviewNRatings')
          .doc(productID)
          .collection('rating')
          .doc(userID + uuid.v1())
          .set(reviewModel.toMap())
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
}
