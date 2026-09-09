import 'package:amazon/model/product_model.dart';
import 'package:flutter/material.dart';

import '../../services/users_product_services/users_product_services.dart';

class UsersProductProvider extends ChangeNotifier {
  List<ProductModel> searchedProducts = [];
  List<ProductModel> _allProducts = [];

  bool productsFetched = false;

  emptySearchedProductsList() {
    searchedProducts = [];
    productsFetched = false;
    notifyListeners();
  }

  fetchAllProducts() async {
    _allProducts = await UsersProductService.getAllProducts();
    searchedProducts = _allProducts;
    productsFetched = true;
    notifyListeners();
  }

  filterProducts(String query) {
    final String trimmedQuery = query.trim().toLowerCase();
    searchedProducts = trimmedQuery.isEmpty
        ? _allProducts
        : _allProducts
            .where((product) =>
                (product.name ?? '').toLowerCase().contains(trimmedQuery))
            .toList();
    notifyListeners();
  }

  getSearchedProducts({required String productName}) async {
    searchedProducts = await UsersProductService.getProducts(productName);
    productsFetched = true;
    notifyListeners();
  }
}
