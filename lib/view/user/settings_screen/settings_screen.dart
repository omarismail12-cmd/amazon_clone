import 'package:amazon/constants/common_functions.dart';
import 'package:amazon/constants/constants.dart';
import 'package:amazon/controller/services/auth_services/auth_services.dart';
import 'package:amazon/model/user_model.dart';
import 'package:amazon/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(width, height * 0.1),
        child: Container(
          padding: EdgeInsets.only(
              left: width * 0.03,
              right: width * 0.03,
              bottom: height * 0.012,
              top: height * 0.045),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: appBarGradientColor,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: black),
              ),
              Text(
                'Settings',
                style:
                    textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.04, vertical: height * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account',
              style:
                  textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            CommonFunctions.blankSpace(height * 0.015, 0),
            FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: currentUserPhone == null
                  ? null
                  : firestore.collection('users').doc(currentUserPhone).get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Text(
                    'Phone: ${currentUserPhone ?? 'Unknown'}',
                    style: textTheme.bodyMedium,
                  );
                }
                final UserModel user =
                    UserModel.fromMap(snapshot.data!.data()!);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: ${user.name ?? 'Not set'}',
                        style: textTheme.bodyMedium),
                    CommonFunctions.blankSpace(height * 0.01, 0),
                    Text('Phone: ${user.mobileNum ?? 'Unknown'}',
                        style: textTheme.bodyMedium),
                    CommonFunctions.blankSpace(height * 0.01, 0),
                    Text(
                        'Account Type: ${user.userType == 'seller' ? 'Seller' : 'Buyer'}',
                        style: textTheme.bodyMedium),
                  ],
                );
              },
            ),
            CommonFunctions.blankSpace(height * 0.03, 0),
            CommonFunctions.divider(),
            CommonFunctions.blankSpace(height * 0.03, 0),
            ElevatedButton(
              onPressed: () => AuthServices.confirmSignOut(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: amber,
                minimumSize: Size(width, height * 0.06),
              ),
              child: Text('Sign Out', style: textTheme.bodyMedium),
            ),
          ],
        ),
      ),
    );
  }
}
