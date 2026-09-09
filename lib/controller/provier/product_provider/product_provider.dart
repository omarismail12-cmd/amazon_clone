import 'dart:typed_data';

import 'package:amazon/controller/services/product_services/product_services.dart';
import 'package:amazon/model/product_model.dart';
import 'package:flutter/material.dart';

class SellerProductProvider extends ChangeNotifier {
  List<Uint8List> productImages = [];
  List<String> productImagesURL = [];
  // Image URLs the seller pasted directly (not device-picked, so nothing to
  // upload to ImgBB for these — used as-is in the final imagesURL list).
  List<String> manualImageUrls = [];
  List<ProductModel> products = [];
  bool sellerProductsFetched = false;

  fetchProductImagesFromGallery({required BuildContext context}) async {
    final List<Uint8List> newImages =
        await ProductServices.getImages(context: context);
    productImages = [...productImages, ...newImages];
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

  fecthSellerProducts() async {
    products = await ProductServices.getSellersProducts();
    sellerProductsFetched = true;
    notifyListeners();
  }

  emptyProductImagesList() {
    productImages = [];
    manualImageUrls = [];
    notifyListeners();
  }
}
