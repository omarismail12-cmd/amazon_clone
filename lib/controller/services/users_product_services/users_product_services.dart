// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:developer';

import 'package:amazon/constants/constants.dart';
import 'package:amazon/model/user_product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../constants/common_functions.dart';
import '../../../model/product_model.dart';

class UsersProductService {
  static Future<List<ProductModel>> getProducts(String productName) async {
    List<ProductModel> sellersProducts = [];
    if (productName.isEmpty) {
      return sellersProducts;
    }
    try {
      final String query = productName.toLowerCase();
      final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('Products')
          .orderBy('name_lower')
          .startAt([query]).endAt(['$query']).get();

      snapshot.docs.forEach((element) {
        sellersProducts.add(ProductModel.fromMap(element.data()));
      });
      log(sellersProducts.toList().toString());
    } catch (e) {
      log('error Found');
      log(e.toString());
    }
    log(sellersProducts.toList().toString());
    return sellersProducts;
  }

  static Future addProductToCart({
    required BuildContext context,
    required UserProductModel productModel,
  }) async {
    final String? phone = currentUserPhone;
    if (phone == null) {
      CommonFunctions.showErrorToast(
          context: context, message: 'No signed-in user found');
      return;
    }
    try {
      // Read-then-write: two concurrent calls for the same product can both
      // see `value.size < 1` and both write, racing on the same doc. Low
      // risk for a single-device shopping cart; would need a transaction
      // to close fully.
      await firestore
          .collection('Cart')
          .doc(phone)
          .collection('myCart')
          .where('productID', isEqualTo: productModel.productID)
          .get()
          .then((value) async {
        if (value.size < 1) {
          await firestore
              .collection('Cart')
              .doc(phone)
              .collection('myCart')
              .doc(productModel.productID)
              .set(productModel.toMap())
              .whenComplete(() {
            if (!context.mounted) return;
            log('Data Added');

            CommonFunctions.showSuccessToast(
                context: context, message: 'Product Added Successful');
          });
        }
      });
    } catch (e) {
      log(e.toString());
      if (!context.mounted) return;
      CommonFunctions.showErrorToast(context: context, message: e.toString());
    }
  }

  static Future addRecentlySeenProduct({
    required BuildContext context,
    required ProductModel productModel,
  }) async {
    final String? phone = currentUserPhone;
    if (phone == null) {
      CommonFunctions.showErrorToast(
          context: context, message: 'No signed-in user found');
      return;
    }
    try {
      await firestore
          .collection('Recently_Seen_Products')
          .doc(phone)
          .collection('products')
          .where('productID', isEqualTo: productModel.productID)
          .get()
          .then((value) async {
        if (value.size < 1) {
          await firestore
              .collection('Recently_Seen_Products')
              .doc(phone)
              .collection('products')
              .doc(productModel.productID)
              .set(productModel.toMap());
        }
      });
    } catch (e) {
      log(e.toString());
      if (!context.mounted) return;
      CommonFunctions.showErrorToast(context: context, message: e.toString());
    }
  }

  static Stream<List<UserProductModel>> fetchCartProducts() {
    final String? phone = currentUserPhone;
    if (phone == null) {
      return const Stream.empty();
    }
    return firestore
        .collection('Cart')
        .doc(phone)
        .collection('myCart')
        .orderBy('time', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return UserProductModel.fromMap(doc.data());
            }).toList());
  }

  static Future<void> updateCountCartProduct({
    required String productId,
    required int newCount,
    required BuildContext context,
  }) async {
    final String? phone = currentUserPhone;
    if (phone == null) {
      CommonFunctions.showErrorToast(
          context: context, message: 'No signed-in user found');
      return;
    }
    final collectionRef =
        firestore.collection('Cart').doc(phone).collection('myCart');

    try {
      final snapshot =
          await collectionRef.where('productID', isEqualTo: productId).get();

      if (snapshot.docs.isNotEmpty) {
        final docId = snapshot.docs[0].id;
        await collectionRef.doc(docId).update({'productCount': newCount});
      }
    } catch (e) {
      if (!context.mounted) return;
      CommonFunctions.showErrorToast(context: context, message: e.toString());
    }
  }

  static Future<void> removeProductfromCart({
    required String productId,
    required BuildContext context,
  }) async {
    final String? phone = currentUserPhone;
    if (phone == null) {
      CommonFunctions.showErrorToast(
          context: context, message: 'No signed-in user found');
      return;
    }
    final collectionRef =
        firestore.collection('Cart').doc(phone).collection('myCart');

    try {
      final snapshot =
          await collectionRef.where('productID', isEqualTo: productId).get();

      if (snapshot.docs.isNotEmpty) {
        final docId = snapshot.docs[0].id;
        await collectionRef.doc(docId).delete();
      }
    } catch (e) {
      if (!context.mounted) return;
      CommonFunctions.showErrorToast(context: context, message: e.toString());
    }
  }

  static Stream<List<ProductModel>> fetchKeepShoppingForProducts() {
    final String? phone = currentUserPhone;
    if (phone == null) {
      return const Stream.empty();
    }
    return firestore
        .collection('Recently_Seen_Products')
        .doc(phone)
        .collection('products')
        .orderBy('uploadedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return ProductModel.fromMap(doc.data());
            }).toList());
  }

  static Future featchDealOfTheDay() async {
    List<ProductModel> sellersProducts = [];
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('Products')
          .orderBy('discountPercentage', descending: true)
          .limit(4)
          .get();
      snapshot.docs.forEach((element) {
        sellersProducts.add(ProductModel.fromMap(element.data()));
      });
      log(sellersProducts.toList().toString());
    } catch (e) {
      log('error Found');
      log(e.toString());
    }
    log(sellersProducts.toList().toString());
    return sellersProducts;
  }

  static Future fetchProductBasedOnCategory({required String category}) async {
    List<ProductModel> sellersProducts = [];
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('Products')
          .where('category', isEqualTo: category)
          .get();
      snapshot.docs.forEach((element) {
        sellersProducts.add(ProductModel.fromMap(element.data()));
      });
      log(sellersProducts.toList().toString());
    } catch (e) {
      log('error Found');
      log(e.toString());
    }
    log(sellersProducts.toList().toString());
    return sellersProducts;
  }

  static Future addOrder({
    required BuildContext context,
    required UserProductModel productModel,
  }) async {
    final String? phone = currentUserPhone;
    if (phone == null) {
      CommonFunctions.showErrorToast(
          context: context, message: 'No signed-in user found');
      return;
    }
    try {
      Uuid uuid = Uuid();
      await firestore
          .collection('Orders')
          .doc(phone)
          .collection('myOrders')
          .doc(productModel.productID! + uuid.v1())
          .set(productModel.toMap())
          .whenComplete(() {
        if (!context.mounted) return;
        log('Data Added');

        CommonFunctions.showSuccessToast(
            context: context, message: 'Product Ordered Successful');
      });
    } catch (e) {
      log(e.toString());
      if (!context.mounted) return;
      CommonFunctions.showErrorToast(context: context, message: e.toString());
    }
  }

  static Stream<List<UserProductModel>> fetchOrders() {
    final String? phone = currentUserPhone;
    if (phone == null) {
      return const Stream.empty();
    }
    return firestore
        .collection('Orders')
        .doc(phone)
        .collection('myOrders')
        .orderBy('time', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return UserProductModel.fromMap(doc.data());
            }).toList());
  }

  static Future fetchCart() async {
    List<UserProductModel> sellersProducts = [];
    final String? phone = currentUserPhone;
    if (phone == null) {
      log('fetchCart: no signed-in user with a phone number');
      return sellersProducts;
    }
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('Cart')
          .doc(phone)
          .collection('myCart')
          .get();
      snapshot.docs.forEach((element) {
        sellersProducts.add(UserProductModel.fromMap(element.data()));
      });
      log(sellersProducts.toList().toString());
    } catch (e) {
      log('error Found');
      log(e.toString());
    }
    log(sellersProducts.toList().toString());
    return sellersProducts;
  }
}
