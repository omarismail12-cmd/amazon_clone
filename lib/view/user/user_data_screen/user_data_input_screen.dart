import 'package:amazon/constants/common_functions.dart';
import 'package:amazon/controller/services/user_data_crud_services/user_data_CRUD_services.dart';
import 'package:amazon/model/user_model.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import '../../../utils/colors.dart';

class UserDataInputScrren extends StatefulWidget {
  const UserDataInputScrren({super.key});

  @override
  State<UserDataInputScrren> createState() => _UserDataInputScrrenState();
}

class _UserDataInputScrrenState extends State<UserDataInputScrren> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool isSeller = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      phoneController.text = auth.currentUser!.phoneNumber ?? '';
    });
  }

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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image(
                image: const AssetImage(
                  'assets/images/amazon_black_logo.png',
                ),
                height: height * 0.04,
              ),
            ],
          ),
        ),
      ),
      body: Container(
        // height: height,
        width: width,
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.03,
          vertical: height * 0.02,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Help us about knowing you more',
              style:
                  textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
            CommonFunctions.blankSpace(
              height * 0.03,
              0,
            ),
            Text(
              'Enter your Name',
              style: textTheme.bodyMedium,
            ),
            CommonFunctions.blankSpace(
              height * 0.01,
              0,
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Enter your name',
                hintStyle: textTheme.bodySmall,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    color: secondaryColor,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: grey,
                  ),
                ),
              ),
            ),
            CommonFunctions.blankSpace(
              height * 0.02,
              0,
            ),
            Text(
              'Phone Number',
              style: textTheme.bodyMedium,
            ),
            CommonFunctions.blankSpace(
              height * 0.01,
              0,
            ),
            TextField(
              controller: phoneController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Enter your phone number',
                hintStyle: textTheme.bodySmall,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    color: secondaryColor,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: grey,
                  ),
                ),
              ),
            ),
            CommonFunctions.blankSpace(
              height * 0.02,
              0,
            ),
            Text(
              'Account Type',
              style: textTheme.bodyMedium,
            ),
            CommonFunctions.blankSpace(
              height * 0.01,
              0,
            ),
            _RoleToggle(
              isSeller: isSeller,
              onSelectBuyer: () => setState(() => isSeller = false),
              onSelectSeller: () => setState(() => isSeller = true),
            ),
            const Spacer(),
            ElevatedButton(
                onPressed: () async {
                  UserModel userModel = UserModel(
                    name: nameController.text.trim(),
                    mobileNum: phoneController.text.trim(),
                    userType: isSeller ? 'seller' : 'user',
                  );
                  await UserDataCRUD.addNewUser(
                      userModel: userModel, context: context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: amber,
                  minimumSize: Size(
                    width,
                    height * 0.06,
                  ),
                ),
                child: Text('Proceed', style: textTheme.bodyMedium))
          ],
        ),
      ),
    );
  }
}

class _RoleToggle extends StatelessWidget {
  const _RoleToggle({
    required this.isSeller,
    required this.onSelectBuyer,
    required this.onSelectSeller,
  });

  final bool isSeller;
  final VoidCallback onSelectBuyer;
  final VoidCallback onSelectSeller;

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
            child: _RoleToggleTab(
              label: "I'm a Buyer",
              selected: !isSeller,
              onTap: onSelectBuyer,
            ),
          ),
          Expanded(
            child: _RoleToggleTab(
              label: "I'm a Seller",
              selected: isSeller,
              onTap: onSelectSeller,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleToggleTab extends StatelessWidget {
  const _RoleToggleTab({
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
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
