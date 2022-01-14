import 'package:flutter/material.dart';
import 'package:ungphoto/widgets/show_image.dart';

class ButtonTakePhoto extends StatelessWidget {
  final Function() tapFunc;
  const ButtonTakePhoto({
    Key? key,
    required this.tapFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapFunc,
      child: Container(
        width: 48,
        height: 48,
        child: ShowImage(path: 'images/icon.png'),
      ),
    );
  }
}
