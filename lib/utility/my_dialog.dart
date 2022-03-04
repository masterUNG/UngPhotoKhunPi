import 'package:flutter/material.dart';
import 'package:ungphoto/utility/my_constant.dart';
import 'package:ungphoto/widgets/show_image.dart';
import 'package:ungphoto/widgets/show_title.dart';

class MyDialog {

  Future<Null> normalDialog(BuildContext context,
      {required String title, required String message}) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: ShowImage(
            path: MyConstant.image1,
          ),
          title: ShowTitle(title: title, textStyle: MyConstant().h2Style(),),
          subtitle: ShowTitle(title: message),
        ),
      ),
    );
  }

  Future<Null> processDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => WillPopScope(
        child: Center(
          child: CircularProgressIndicator(
            // backgroundColor: MyConstant.dark,
            color: MyConstant.light,
          ),
        ),
        onWillPop: () async {
          return false;
        },
      ),
    );
  }
}
