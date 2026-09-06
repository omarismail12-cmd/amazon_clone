import 'package:amazon/constants/common_functions.dart';
import 'package:amazon/controller/services/auth_services/auth_services.dart';
import 'package:amazon/view/auth_screen/auth_screens.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key, required this.mobileNumber});
  final String mobileNumber;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController otpController = TextEditingController();
  bool isVerifying = false;
  bool isResending = false;

  Future<void> _verify(BuildContext context) async {
    setState(() => isVerifying = true);
    await AuthServices.verifyOTP(
        context: context, otp: otpController.text.trim());
    if (mounted) setState(() => isVerifying = false);
  }

  Future<void> _resend(BuildContext context) async {
    setState(() => isResending = true);
    await AuthServices.receiveOTP(
        context: context, mobileNo: widget.mobileNumber);
    if (mounted) setState(() => isResending = false);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        centerTitle: true,
        title: Image(
          image: const AssetImage('assets/images/amazon_logo.png'),
          height: height * 0.04,
        ),
      ),
      body: SafeArea(
        child: Container(
          height: height,
          width: width,
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.03,
            vertical: height * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Authentication Required',
                style: textTheme.displayMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              CommonFunctions.blankSpace(
                height * 0.01,
                0,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: widget.mobileNumber,
                      style: textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' Change',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              CommonFunctions.blankSpace(
                height * 0.02,
                0,
              ),
              Text(
                'We have send a One Time Password (OTP) to the mobile no. above. Please enter it to complete verification.',
                style: textTheme.bodyMedium,
              ),
              CommonFunctions.blankSpace(
                height * 0.02,
                0,
              ),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter OTP',
                ),
              ),
              CommonFunctions.blankSpace(
                height * 0.01,
                0,
              ),
              CommonAuthButton(
                title: 'Continue',
                isLoading: isVerifying,
                onPressed: () => _verify(context),
                btnWidth: 0.94,
              ),
              CommonFunctions.blankSpace(
                height * 0.01,
                0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: isResending ? null : () => _resend(context),
                    child: isResending
                        ? SizedBox(
                            height: height * 0.02,
                            width: height * 0.02,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Resend OTP',
                            style: textTheme.bodyMedium!.copyWith(
                              color: blue,
                            ),
                          ),
                  ),
                ],
              ),
              CommonFunctions.blankSpace(
                height * 0.02,
                0,
              ),
              const BottomAuthScreenWidget()
            ],
          ),
        ),
      ),
    );
  }
}
