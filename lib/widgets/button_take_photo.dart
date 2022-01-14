import 'package:flutter/material.dart';
import 'package:ungphoto/widgets/show_image.dart';

class ButtonTakePhoto extends StatelessWidget {
  const ButtonTakePhoto({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      child: ShowImage(path: 'images/icon.png'),
    );
  }
}
