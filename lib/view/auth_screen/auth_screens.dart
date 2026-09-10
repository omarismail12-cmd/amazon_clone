import 'package:amazon/constants/common_functions.dart';
import 'package:amazon/controller/services/auth_services/auth_services.dart';
import 'package:amazon/utils/colors.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool inLogin = true;
  bool isSendingOtp = false;
  String currentCountryCode = '+1';
  TextEditingController mobileController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  Future<void> _sendOtp(BuildContext context, String mobileNo) async {
    setState(() => isSendingOtp = true);
    await AuthServices.receiveOTP(context: context, mobileNo: mobileNo);
    if (mounted) setState(() => isSendingOtp = false);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        centerTitle: true,
        title: Image(
          image: const AssetImage('assets/images/amazon_logo.png'),
          height: height * 0.04,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                  'Welcome',
                  style: textTheme.displaySmall!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                CommonFunctions.blankSpace(
                  height * 0.02,
                  0,
                ),
                _AuthToggle(
                  inLogin: inLogin,
                  onSelectSignIn: () => setState(() => inLogin = true),
                  onSelectCreateAccount: () => setState(() => inLogin = false),
                ),
                CommonFunctions.blankSpace(
                  height * 0.02,
                  0,
                ),
                Builder(builder: (context) {
                  if (inLogin) {
                    return signIn(width, height, textTheme, context);
                  }
                  return createAccount(width, height, textTheme, context);
                }),
                CommonFunctions.blankSpace(
                  height * 0.05,
                  0,
                ),
                const BottomAuthScreenWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container signIn(
      double width, double height, TextTheme textTheme, BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border.all(
          color: greyShade3,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: width,
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.03,
              vertical: height * 0.01,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        showCountryPicker(
                            context: context,
                            onSelect: (val) {
                              setState(() {
                                currentCountryCode = '+${val.phoneCode}';
                              });
                            });
                      },
                      child: Container(
                        height: height * 0.06,
                        width: width * 0.2,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: grey,
                          ),
                          color: greyShade2,
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                        ),
                        child: Text(
                          currentCountryCode,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: textTheme.displaySmall!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    CommonFunctions.blankSpace(0, width * 0.02),
                    Expanded(
                      child: SizedBox(
                        height: height * 0.06,
                        child: TextFormField(
                          controller: mobileController,
                          cursorColor: black,
                          style: textTheme.displaySmall,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Mobile number',
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                CommonFunctions.blankSpace(height * 0.02, 0),
                CommonAuthButton(
                  title: 'Continue',
                  isLoading: isSendingOtp,
                  onPressed: () => _sendOtp(context,
                      '$currentCountryCode${mobileController.text.trim()}'),
                  btnWidth: 0.88,
                ),
                CommonFunctions.blankSpace(
                  height * 0.02,
                  0,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'By Continuing you agree to Amazon\'s ',
                        style: textTheme.labelMedium,
                      ),
                      TextSpan(
                        text: 'Conditions of use ',
                        style: textTheme.labelMedium!.copyWith(color: blue),
                      ),
                      TextSpan(
                        text: 'and ',
                        style: textTheme.labelMedium,
                      ),
                      TextSpan(
                        text: 'Privacy Notice',
                        style: textTheme.labelMedium!.copyWith(color: blue),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container createAccount(
      double width, double height, TextTheme textTheme, BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border.all(
          color: greyShade3,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: width,
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.03,
              vertical: height * 0.01,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.06,
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'First and Last Name',
                    ),
                  ),
                ),
                CommonFunctions.blankSpace(
                  height * 0.01,
                  0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        showCountryPicker(
                            context: context,
                            onSelect: (val) {
                              setState(() {
                                currentCountryCode = '+${val.phoneCode}';
                              });
                            });
                      },
                      child: Container(
                        height: height * 0.06,
                        width: width * 0.2,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: grey,
                          ),
                          color: greyShade2,
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                        ),
                        child: Text(
                          currentCountryCode,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: textTheme.displaySmall!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    CommonFunctions.blankSpace(0, width * 0.02),
                    Expanded(
                      child: SizedBox(
                        height: height * 0.06,
                        child: TextFormField(
                          controller: mobileController,
                          cursorColor: black,
                          style: textTheme.displaySmall,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Mobile number',
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                CommonFunctions.blankSpace(height * 0.02, 0),
                Text(
                  'By enrolling your mobile phone number, you concent to receive automated security notifications via text message from Amazon.\nMessage and data rates may apply.',
                  style: textTheme.bodyMedium,
                ),
                CommonFunctions.blankSpace(height * 0.02, 0),
                CommonAuthButton(
                  title: 'Continue',
                  btnWidth: 0.88,
                  isLoading: isSendingOtp,
                  onPressed: () => _sendOtp(context,
                      '$currentCountryCode${mobileController.text.trim()}'),
                ),
                CommonFunctions.blankSpace(
                  height * 0.02,
                  0,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'By Continuing you agree to Amazon\'s ',
                        style: textTheme.labelMedium,
                      ),
                      TextSpan(
                        text: 'Conditions of use ',
                        style: textTheme.labelMedium!.copyWith(color: blue),
                      ),
                      TextSpan(
                        text: 'and ',
                        style: textTheme.labelMedium,
                      ),
                      TextSpan(
                        text: 'Privacy Notice',
                        style: textTheme.labelMedium!.copyWith(color: blue),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthToggle extends StatelessWidget {
  const _AuthToggle({
    required this.inLogin,
    required this.onSelectSignIn,
    required this.onSelectCreateAccount,
  });

  final bool inLogin;
  final VoidCallback onSelectSignIn;
  final VoidCallback onSelectCreateAccount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _AuthToggleTab(
              label: 'Sign in',
              selected: inLogin,
              onTap: onSelectSignIn,
            ),
          ),
          Expanded(
            child: _AuthToggleTab(
              label: 'Create account',
              selected: !inLogin,
              onTap: onSelectCreateAccount,
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthToggleTab extends StatelessWidget {
  const _AuthToggleTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? colorScheme.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: textTheme.titleMedium?.copyWith(
            color:
                selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
            fontWeight: selected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class CommonAuthButton extends StatelessWidget {
  const CommonAuthButton(
      {super.key,
      required this.title,
      required this.onPressed,
      required this.btnWidth,
      this.isLoading = false});
  final String title;
  final VoidCallback onPressed;
  final double btnWidth;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width * btnWidth, height * 0.06),
        backgroundColor: amber,
      ),
      child: isLoading
          ? SizedBox(
              height: height * 0.025,
              width: height * 0.025,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.black,
              ),
            )
          : Text(title, style: textTheme.displaySmall),
    );
  }
}

class BottomAuthScreenWidget extends StatelessWidget {
  const BottomAuthScreenWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Container(
          height: 2,
          width: width,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [white, greyShade3, white])),
        ),
        CommonFunctions.blankSpace(
          height * 0.02,
          0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Condition of Use',
              style: textTheme.bodyMedium!.copyWith(
                color: blue,
              ),
            ),
            Text(
              'Privacy Notice',
              style: textTheme.bodyMedium!.copyWith(
                color: blue,
              ),
            ),
            Text(
              'Help',
              style: textTheme.bodyMedium!.copyWith(
                color: blue,
              ),
            ),
          ],
        ),
        CommonFunctions.blankSpace(
          height * 0.01,
          0,
        ),
        Text(
          '© 1996-2023, Amazon.com, Inc. or its affiliates',
          style: textTheme.labelMedium!.copyWith(
            color: grey,
          ),
        ),
      ],
    );
  }
}
