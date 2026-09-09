import 'dart:typed_data';

import 'package:amazon/controller/services/rating_services/rating_services.dart';
import 'package:flutter/material.dart';

class RatingProvider extends ChangeNotifier {
  List<Uint8List> productImages = [];
  List<String> productImagesURL = [];
  // Image URLs pasted directly (not device-picked, so nothing to upload to
  // ImgBB for these — used as-is in the final review imagesURL list).
  List<String> manualImageUrls = [];
  bool productPurchased = false;
  bool userRatedTheProduct = false;
  fetchProductImagesFromGallery({required BuildContext context}) async {
    productImages = await RatingServices.getImages(context: context);
    notifyListeners();
  }

  removeProductImage(int index) {
    productImages = List<Uint8List>.from(productImages)..removeAt(index);
    notifyListeners();
  }

  addManualImageUrl(String url) {
    manualImageUrls = [...manualImageUrls, url];
    notifyListeners();
  }

  removeManualImageUrl(int index) {
    manualImageUrls = List<String>.from(manualImageUrls)..removeAt(index);
    notifyListeners();
  }

  updateProductImagesURL({required List<String> imageURLs}) async {
    productImagesURL = imageURLs;
    notifyListeners();
  }

  checkProductPurchase({required String productID}) async {
    productPurchased =
        await RatingServices.checkUserPurchasedTheProduct(productID: productID);

    notifyListeners();
  }

  reset() {
    productImages = [];
    productImagesURL = [];
    manualImageUrls = [];
    userRatedTheProduct = false;
    productPurchased = false;

    notifyListeners();
  }

  checkUserRating({required String productID}) async {
    userRatedTheProduct =
        await RatingServices.checkUserRating(productID: productID);
    notifyListeners();
  }
}
