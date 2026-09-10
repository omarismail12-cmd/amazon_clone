// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:amazon/controller/services/user_data_crud_services/user_data_CRUD_services.dart';
import 'package:amazon/view/auth_screen/auth_screens.dart';
import 'package:amazon/view/seller/seller_persistant_nav_bar/seller_bottom_nav_bar.dart';
import 'package:amazon/view/user/user_data_screen/user_data_input_screen.dart';
import 'package:amazon/view/user/user_persistant_nav_bar/user_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../../controller/services/auth_services/auth_services.dart';

class SignInLogic extends StatefulWidget {
  const SignInLogic({super.key});

  @override
  State<SignInLogic> createState() => _SignInLogicState();
}

class _SignInLogicState extends State<SignInLogic> {
  checkUser() async {
    bool userAlreadyThere = await UserDataCRUD.checkUser();
    // log(userAlreadyThere.toString());
    if (userAlreadyThere == true) {
      bool userIsSeller = await UserDataCRUD.userIsSeller();
      log('start');
      log(userIsSeller.toString());
      if (userIsSeller == true) {
        // Use the root navigator, not the one Navigator.of(context) would
        // find by default. If confirmSignOut() (or a prior run of this same
        // method) left SignInLogic nested inside a PersistentTabView tab's
        // own Navigator, a plain push here would insert the new nav bar
        // *inside* the old one instead of replacing it.
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          PageTransition(
            child: const SellerBottomNavBar(),
            type: PageTransitionType.rightToLeft,
          ),
          (route) => false,
        );
      } else {
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          PageTransition(
            child: const UserBottomNavBar(),
            type: PageTransitionType.rightToLeft,
          ),
          (route) => false,
        );
      }
    } else {
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        PageTransition(
          child: const UserDataInputScrren(),
          type: PageTransitionType.rightToLeft,
        ),
        (route) => false,
      );
    }
  }

  checkAuthentication() {
    bool userIsAuthenticated = AuthServices.checkAuthentication();
    userIsAuthenticated
        ? checkUser()
        : Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            PageTransition(
                child: const AuthScreen(),
                type: PageTransitionType.rightToLeft),
            (route) => false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAuthentication();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Image(
        image: AssetImage('assets/images/amazon_splash_screen.png'),
        fit: BoxFit.fill,
      ),
    );
  }
}
