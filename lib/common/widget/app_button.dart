import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/common/widget/app_text.dart';

import '../constants/color_constant.dart';

// ignore: must_be_immutable
class AppButton extends StatelessWidget {
  GestureTapCallback? ontap;
  String? text;
  double? fontSize;
  AppButton({super.key, this.ontap, this.text, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: 160,
        height: 40,
        decoration: BoxDecoration(
            color: ColorConstants.commonColor,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                  color: ColorConstants.borderColor,
                  offset: const Offset(0, 5),
                  blurRadius: 5),
            ]),
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10)
            .copyWith(top: 30),
        child: AppText(
          text: text,
          fontSize: fontSize,
          color: ColorConstants.textColor,
        ),
      ),
    );
  }
}
