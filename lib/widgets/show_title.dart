import 'package:flutter/material.dart';
import 'package:ungphoto/utility/my_constant.dart';

class ShowTitle extends StatelessWidget {
  final String title;
  final TextStyle? textStyle;
  const ShowTitle({
    Key? key,
    required this.title,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TextStyle? myTextStyle = textStyle;
    // if (myTextStyle == null) {
    //   myTextStyle = MyConstant().h3normalStyle();
    // }
    return Text(
      title,
      style: textStyle ?? MyConstant().h3normalStyle(),
    );
  }
}
