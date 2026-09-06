import 'package:flutter/material.dart';

import '../../../../constants/common_functions.dart';

class AddressScreenTextField extends StatelessWidget {
  const AddressScreenTextField({
    super.key,
    required this.title,
    required this.hintText,
    required this.textController,
  });

  final TextEditingController textController;
  final String title;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.bodyMedium,
        ),
        CommonFunctions.blankSpace(
          height * 0.01,
          0,
        ),
        TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: hintText,
          ),
        ),
      ],
    );
  }
}
