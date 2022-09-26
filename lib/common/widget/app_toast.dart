import 'package:fluttertoast/fluttertoast.dart';

import '../constants/color_constant.dart';

appToast(String? msg) {
  return Fluttertoast.showToast(
      msg: "$msg",
      gravity: ToastGravity.CENTER,
      backgroundColor: ColorConstants.commonColor,
      textColor: ColorConstants.textColor);
}
