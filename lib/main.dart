import 'package:flutter/material.dart';
import 'package:ungphoto/states/photo_service.dart';
import 'package:ungphoto/utility/my_constant.dart';

final Map<String, WidgetBuilder> map = {
  '/photoService': (BuildContext context) => PhotoService()
};

String? firstState;

void main() {
  firstState = MyConstant.routePhotoService;
  runApp(MyApp());

  

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: map,
      initialRoute: firstState,
    );
  }
}
