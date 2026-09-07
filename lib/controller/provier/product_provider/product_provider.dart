import 'dart:typed_data';

import 'package:amazon/controller/services/product_services/product_services.dart';
import 'package:amazon/model/product_model.dart';
import 'package:flutter/material.dart';

class SellerProductProvider extends ChangeNotifier {
  List<Uint8List> productImages = [];
  List<String> productImagesURL = [];
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
    notifyListeners();
  }
}
