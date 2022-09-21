import 'package:flutter/cupertino.dart';
import '../constants/color_constant.dart';

class AppText extends StatelessWidget {
  final String? text;
  final double? fontSize;
  final Color? color;
  final TextAlign? textAlign;
  const AppText(
      {super.key, this.text, this.fontSize, this.color, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      textAlign: textAlign,
      style: TextStyle(
          fontSize: fontSize, color: color ?? ColorConstants.commonColor),
    );
  }
}
