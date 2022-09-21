import 'package:flutter/material.dart';
import 'package:flutter_demo/common/widget/app_text.dart';

import '../constants/color_constant.dart';

class AppTextField extends StatelessWidget {
  final String? lable;
  final Widget? suffixIcon;
  final bool? obscureText;
  final TextEditingController? textEditingController;
  final FormFieldValidator<String>? validator;

  const AppTextField(
      {super.key,
      this.lable,
      this.validator,
      this.suffixIcon,
      this.textEditingController,
      this.obscureText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: textEditingController,
        validator: validator,
        obscuringCharacter: "*",
        obscureText: obscureText ?? false,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          disabledBorder: outLineInputBorder(),
          focusedBorder: outLineInputBorder(),
          errorBorder: outLineInputBorder(color: ColorConstants.errorColor),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorConstants.commonColor,
            ),
          ),
          enabledBorder: outLineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          label: AppText(text: lable),
        ),
      ),
    );
  }

  OutlineInputBorder outLineInputBorder({Color? color}) => OutlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          color: color ?? ColorConstants.commonColor,
        ),
      );
}
