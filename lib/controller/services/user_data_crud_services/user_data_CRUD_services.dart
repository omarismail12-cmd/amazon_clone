// ignore_for_file: file_names, unused_local_variable, avoid_function_literals_in_foreach_calls

import 'dart:developer';

import 'package:amazon/constants/common_functions.dart';
import 'package:amazon/constants/constants.dart';
import 'package:amazon/model/address_model.dart';
import 'package:amazon/model/user_model.dart';
import 'package:amazon/view/auth_screen/sign_in_logic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class UserDataCRUD {
  static Future addNewUser({
    required UserModel userModel,
    required BuildContext context,
  }) async {
    final String? phone = currentUserPhone;
    if (phone == null) {
      CommonFunctions.showErrorToast(
          context: context, message: 'No signed-in user found');
      return;
    }
    try {
      await firestore
          .collection('users')
          .doc(phone)
          .set(userModel.toMap())
          .whenComplete(() {
        if (!context.mounted) return;
        log('Data Added');
        CommonFunctions.showSuccessToast(
            context: context, message: 'User Added Successful');
        Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
                child: const SignInLogic(),
                type: PageTransitionType.rightToLeft),
            (route) => false);
      });
    } catch (e) {
      log(e.toString());
      if (!context.mounted) return;
      CommonFunctions.showErrorToast(context: context, message: e.toString());
    }
  }

  static Future<bool> checkUser() async {
    final String? phone = currentUserPhone;
    if (phone == null) {
      log('checkUser: no signed-in user with a phone number');
      return false;
    }
    bool userPresent = false;
    try {
      await firestore
          .collection('users')
          .where('mobileNum', isEqualTo: phone)
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

  static Future<bool> userIsSeller() async {
    final String? phone = currentUserPhone;
    if (phone == null) {
      log('userIsSeller: no signed-in user with a phone number');
      return false;
    }
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection('users').doc(phone).get();
      if (snapshot.exists) {
        UserModel userModel = UserModel.fromMap(snapshot.data()!);
        log('User Type is: ${userModel.userType!}');
        if (userModel.userType != 'user') {
          return true;
        }
      }
    } catch (e) {
      log(e.toString());
    }
    return false;
  }

  static Future addUserAddress(
      {required BuildContext context,
      required AddressModel addressModel,
      required String docID}) async {
    final String? phone = currentUserPhone;
    if (phone == null) {
      CommonFunctions.showErrorToast(
          context: context, message: 'No signed-in user found');
      return;
    }
    try {
      await firestore
          .collection('Address')
          .doc(phone)
          .collection('address')
          .doc(docID)
          .set(addressModel.toMap())
          .whenComplete(() {
        if (!context.mounted) return;
        log('Data Added');
        CommonFunctions.showSuccessToast(
            context: context, message: 'Address Added Successful');
        Navigator.pop(context);
      });
    } catch (e) {
      log(e.toString());
      if (!context.mounted) return;
      CommonFunctions.showErrorToast(context: context, message: e.toString());
    }
  }

  static Future<bool> checkUsersAddress() async {
    final String? phone = currentUserPhone;
    if (phone == null) {
      log('checkUsersAddress: no signed-in user with a phone number');
      return false;
    }
    bool addressPresent = false;
    try {
      await firestore
          .collection('Address')
          .doc(phone)
          .collection('address')
          .get()
          .then((value) =>
              value.size > 0 ? addressPresent = true : addressPresent = false);
    } catch (e) {
      log(e.toString());
    }
    log(addressPresent.toString());
    return addressPresent;
  }

  static Future<List<AddressModel>> getAllAddress() async {
    List<AddressModel> allAddress = [];
    AddressModel defaultAddress = AddressModel();
    final String? phone = currentUserPhone;
    if (phone == null) {
      log('getAllAddress: no signed-in user with a phone number');
      return allAddress;
    }
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('Address')
          .doc(phone)
          .collection('address')
          .get();

      snapshot.docs.forEach((element) {
        allAddress.add(AddressModel.fromMap(element.data()));
        AddressModel currentAddresss = AddressModel.fromMap(element.data());
        if (currentAddresss.isDefault == true) {
          defaultAddress = currentAddresss;
        }
      });
    } catch (e) {
      log('error Found');
      log(e.toString());
    }
    for (var data in allAddress) {
      log(data.toMap().toString());
    }
    return allAddress;
  }

  static Future getCurrentSelectedAddress() async {
    AddressModel defaultAddress = AddressModel();
    final String? phone = currentUserPhone;
    if (phone == null) {
      log('getCurrentSelectedAddress: no signed-in user with a phone number');
      return defaultAddress;
    }
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('Address')
          .doc(phone)
          .collection('address')
          .get();

      snapshot.docs.forEach((element) {
        AddressModel currentAddresss = AddressModel.fromMap(element.data());
        if (currentAddresss.isDefault == true) {
          defaultAddress = currentAddresss;
        }
      });
    } catch (e) {
      log('error Found');
      log(e.toString());
    }
    return defaultAddress;
  }
}
