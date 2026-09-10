// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:amazon/controller/provier/auth_provider/auth_provider.dart'
    as app_provider;
import 'package:amazon/view/auth_screen/otp_screen.dart';
import 'package:amazon/view/auth_screen/sign_in_logic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class AuthServices {
  static bool checkAuthentication() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      return true;
    }
    return false;
  }

  static receiveOTP(
      {required BuildContext context, required String mobileNo}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: mobileNo,
        verificationCompleted: (PhoneAuthCredential credential) {
          log(credential.toString());
        },
        verificationFailed: (FirebaseAuthException exception) {
          log(exception.toString());
        },
        codeSent: (String verificationID, int? resendToken) {
          context
              .read<app_provider.AuthProvider>()
              .upDateverificationId(verID: verificationID);
          context.read<app_provider.AuthProvider>().upDatePhoneNum(
                num: mobileNo,
              );
          Navigator.push(
            context,
            PageTransition(
              child:  OTPScreen(mobileNumber: mobileNo),
              type: PageTransitionType.rightToLeft,
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationID) {},
      );
    } catch (e) {
      log(e.toString());
    }
  }

  static verifyOTP({required BuildContext context, required String otp}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: context.read<app_provider.AuthProvider>().verificationId,
        smsCode: otp,
      );
      await auth.signInWithCredential(credential);
      Navigator.push(
          context,
          PageTransition(
            child: const SignInLogic(),
            type: PageTransitionType.rightToLeft,
          ));
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<void> signOut() {
    FirebaseAuth auth = FirebaseAuth.instance;
    return auth.signOut();
  }

  /// Shows a confirmation dialog, and on confirm signs the user out and
  /// navigates back to the sign-in flow, clearing the navigation stack so
  /// the user can't back-button into the authenticated app afterward.
  static Future<void> confirmSignOut(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await signOut();
    if (!context.mounted) return;
    // Sign-out can be triggered from a screen that's a tab inside
    // PersistentTabView (Seller's Inventory/Monitor, buyer's
    // Profile/Settings), which wraps every tab in its own nested Navigator.
    // A plain Navigator.of(context) resolves to that nested Navigator, so
    // this would only clear the tab's inner stack and leave the outer
    // SellerBottomNavBar/UserBottomNavBar mounted — rootNavigator: true
    // forces it to the app's actual root Navigator instead.
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      PageTransition(
        child: const SignInLogic(),
        type: PageTransitionType.rightToLeft,
      ),
      (route) => false,
    );
  }
}
