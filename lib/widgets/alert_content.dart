// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:ungphoto/utility/my_constant.dart';

class AlertContent extends StatelessWidget {
  final String currentPackimg;

  const AlertContent({
    Key? key,
    required this.currentPackimg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('#28jan currentPack ==>>> $currentPackimg');
    return currentPackimg.isEmpty
        ? SizedBox()
        : Image.network('${MyConstant.domainImage}$currentPackimg');
  }
}
