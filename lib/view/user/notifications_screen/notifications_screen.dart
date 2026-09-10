import 'package:amazon/constants/common_functions.dart';
import 'package:amazon/utils/colors.dart';
import 'package:flutter/material.dart';

// A real-time notifications backend (order status updates, price drop
// alerts, etc.) doesn't exist yet — this screen just gives the bell icon a
// real destination instead of a dead tap target.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

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
                'Notifications',
                style:
                    textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.notifications_none, size: 64, color: grey),
              CommonFunctions.blankSpace(height * 0.02, 0),
              Text('No notifications yet', style: textTheme.bodyLarge),
              CommonFunctions.blankSpace(height * 0.008, 0),
              Text(
                "We'll let you know here about order updates and offers",
                textAlign: TextAlign.center,
                style: textTheme.bodySmall!.copyWith(color: grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
