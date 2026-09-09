import 'package:flutter/material.dart';

import '../../../model/product_model.dart';
import '../../services/users_product_services/users_product_services.dart';

class ProductsBasedOnCategoryProvider extends ChangeNotifier {
  List<ProductModel> products = [];
  bool productsFetched = false;

  fetchProducts({required String category}) async {
    products = [];
    // 'Deals' isn't a category sellers can assign to a product (it's not in
    // productCategories) — it means "today's deals", so route it to the
    // same discount-based query the home screen's Deal of the Day uses
    // instead of a category-equality query that can never match anything.
    products = category == 'Deals'
        ? await UsersProductService.featchDealOfTheDay()
        : await UsersProductService.fetchProductBasedOnCategory(
            category: category);
    productsFetched = true;
    notifyListeners();
  }
}
