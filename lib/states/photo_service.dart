import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart';
import 'package:ungphoto/models/shopee_docno_model.dart';
import 'package:ungphoto/utility/my_constant.dart';
import 'package:ungphoto/utility/my_dialog.dart';
import 'package:ungphoto/widgets/show_image.dart';
import 'package:ungphoto/widgets/show_title.dart';

class PhotoService extends StatefulWidget {
  const PhotoService({Key? key}) : super(key: key);

  @override
  _PhotoServiceState createState() => _PhotoServiceState();
}

class _PhotoServiceState extends State<PhotoService> {
  TextEditingController textEditingController = TextEditingController();
  List<ShopeeDocnoModel> shopeeDocnoModels = [];
  List<Widget> widgets = [];
  bool displayDetailCustomer = false;
  List<Color> colors = [Colors.grey.shade200, Colors.grey.shade100];
  int countColor = 0;

  List<File?> files = [];
  File? file;

  // List<String> listUrlImages = [];
  var listImages = [false, false, false, false];

  Future<Null> processScan() async {
    try {
      var result = await scan();
      print('########### result = $result');
      setState(() {
        textEditingController.text = result.toString();
        processSearch(result.toString());
      });
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    // textEditingController.text = '2107079712305Q';
    textEditingController.text = '2105109TRN8CH5';
    // textEditingController.text = '211216A228XAFJ';

    var images = listImages.toString();
    print('images ==> $images');

    setUpFiles();
  }

  void setUpFiles() {
    if (files.isNotEmpty) {
      files.clear();
    }

    for (var i = 0; i < 4; i++) {
      files.add(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppName(),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildSearch(constraints),
                displayDetailCustomer
                    ? showDetailCustomer(constraints)
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildAppName() {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () => checkCamera(),
          icon: Icon(Icons.qr_code),
        ),
      ],
    );
  }

  Container showDetailCustomer(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.9,
      child: Column(
        children: [
          buildHeadTitle('รายละเอียดลูกค้า'),
          buildRow(
              'รหัสลูกค้า :',
              shopeeDocnoModels.length == 0
                  ? '?'
                  : shopeeDocnoModels[0].CUSTSHOPEECODE),
          buildRow(
              'ชื่อ :',
              shopeeDocnoModels.length == 0
                  ? '?'
                  : shopeeDocnoModels[0].CUSNAME),
          buildRow(
              'ที่อยู่ :',
              shopeeDocnoModels.length == 0
                  ? '?'
                  : shopeeDocnoModels[0].CUSADDRESS),
          buildRow('เบอร์โทร :',
              shopeeDocnoModels.length == 0 ? '?' : shopeeDocnoModels[0].PHONE),
          // buildHeadTitle('รายการสั่งซื้อ'),
          buildListOrder(),
          buildHeadTitle('รูปถ่าย Package'),
          controlImage(),
          buildRow(
              'น้ำหนักสินค้า :',
              shopeeDocnoModels.length == 0
                  ? '?'
                  : '   ${shopeeDocnoModels[0].WEIGHTTOT} Kg'),
        ],
      ),
    );
  }

  Padding controlImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildImage(0, shopeeDocnoModels[0].PACKIMG1),
          buildImage(1, shopeeDocnoModels[0].PACKIMG2),
          buildImage(2, shopeeDocnoModels[0].PACKIMG3),
          buildImage(3, shopeeDocnoModels[0].PACKIMG4),
        ],
      ),
    );
  }

  Future<Null> processTakePhoto(ImageSource source, int index) async {
    try {
      var result = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        files[index] = File(result!.path);
      });
    } catch (e) {}
  }

  Future<Null> imageDialog(int index) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: ShowImage(path: MyConstant.icon),
          title: ShowTitle(
            title: 'รูปภาพที่ ${index + 1}',
            textStyle: MyConstant().h2Style(),
          ),
          subtitle: ShowTitle(title: 'กรุณา เลือกแหล่งกำเหนิดภาพ ด้วยคะ'),
        ),
        content: files[index] == null
            ? SizedBox()
            : Stack(
                children: [
                  Image.file(files[index]!),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Card(
                      color: Colors.white.withOpacity(0.5),
                      child: IconButton(
                        onPressed: () async {
                          // Navigator.pop(context);

                          MyDialog().processDialog(context);

                          String nameFile =
                              '${textEditingController.text}_${index + 1}.jpg';

                          try {
                            Map<String, dynamic> map = {};
                            map['file'] = await MultipartFile.fromFile(
                                files[index]!.path,
                                filename: nameFile);
                            FormData data = FormData.fromMap(map);

                            String urlAPi =
                                'http://210.86.171.110:89/webapi3/api/docfile';
                            await Dio()
                                .post(urlAPi, data: data)
                                .then((value) async {
                              print('@@ value ==> $value');
                              Navigator.pop(context);
                              Navigator.pop(context);

                              // process UPdate Database
                              var keys = <String>[
                                'PACKIMG1',
                                'PACKIMG2',
                                'PACKIMG3',
                                'PACKIMG4',
                              ];

                              var picnums = <int>[
                                1,
                                2,
                                3,
                                4,
                              ];

                              Map<String, dynamic> map = {};
                              map[keys[index]] = value.toString();
                              print(
                                  '@@ picnum ==> ${picnums[index]} map ==> $map');

                              String docno = textEditingController.text;
                              int picnum = picnums[index];
                              String picname = nameFile;

                              String apiUpdateImagePackage =
                                  'http://210.86.171.110:89/webapi3/api/shopeepic?docno=$docno&picnum=$picnum&picname=$picname';
                              await Dio()
                                  .get(apiUpdateImagePackage)
                                  .then((value) {
                                print('@@ Success Update image $picnum');
                                processSearch(docno);
                              });
                            });
                          } catch (e) {
                            print('@@ error =>$e');
                            Navigator.pop(context);
                            MyDialog().normalDialog(context,
                                title: 'Have Problem ?',
                                message: 'Wait few minus Please try again');
                          }
                        },
                        icon: Icon(
                          Icons.cloud_upload_outlined,
                          size: 36,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  processTakePhoto(ImageSource.camera, index);
                },
                child: Text('ถ่ายรูป'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  processTakePhoto(ImageSource.gallery, index);
                },
                child: Text('รูปในเครื่อง'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('ยกเลิก'),
              ),
            ],
          ),
        ],
      ),
    );
  }


    
    //ffff

  Container buildImage(int index, String packimg) {
    print('@@ image$index ==>>> $packimg');
    return Container(
      width: 48,
      height: 48,
      child: GestureDetector(
        onTap: () {
          print('#### index => $index');
          imageDialog(index);
        },
        child: packimg.isNotEmpty
            ? Image.network('${MyConstant.domainImage}$packimg', fit: BoxFit.cover,)
            : files[index] == null
                ? ShowImage(path: MyConstant.icon)
                : Image.file(
                    files[index]!,
                    fit: BoxFit.cover,
                  ),
      ),
    );
  }

  Widget buildListOrder() {
    return ExpansionTile(
      title: ShowTitle(
        title: 'รายการสั่งซื้อ',
        textStyle: MyConstant().h2BlueStyle(),
      ),
      children: widgets,
    );
  }

  Row buildHeadTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ShowTitle(
            title: title,
            textStyle: MyConstant().h2BlueStyle(),
          ),
        ),
      ],
    );
  }

  Row buildRow(String head, String value) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: ShowTitle(
            title: head,
            textStyle: MyConstant().h3Style(),
          ),
        ),
        Expanded(
          flex: 3,
          child: ShowTitle(title: value),
        ),
      ],
    );
  }

  Future<Null> checkCamera() async {
    await Permission.camera.status.then((value) async {
      print('cameraStatus ==> $value');
      if (value.isDenied) {
        await Permission.camera
            .request()
            .then((value) => print('value after permission Camera ==> $value'));
      } else {
        processScan();
      }
    });
  }

  Future<Null> processSearch(String search) async {
    setUpFiles();

    if (shopeeDocnoModels.length != 0) {
      shopeeDocnoModels.clear();
      widgets.clear();
      displayDetailCustomer = false;
    }

    // print('######## processSearch ==> $search');

    MyDialog().processDialog(context);

    String apiSearch =
        'http://210.86.171.110:89/webapi3/api/shopeedoc?docno=$search';
    await Dio().get(apiSearch).then((value) {
      // print('#### value ==>> $value');
      Navigator.pop(context);
      if (value.toString() == '[]') {
        print('No Data');
        MyDialog().normalDialog(context,
            title: 'Code False ?',
            message: 'ไม่มี Bar Code ใน ฐานข้อมูลของเรา');
      } else {
        for (var map in value.data) {
          ShopeeDocnoModel model = ShopeeDocnoModel.fromMap(map);
          print('### idCus ==>> ${model.CUSTSHOPEECODE}');
          setState(() {
            displayDetailCustomer = true;
            shopeeDocnoModels.add(model);
            widgets.add(createWidget(model, countColor % 2));
          });
          countColor++;
        }
      }
    });
  }

  Widget createWidget(ShopeeDocnoModel model, int index) {
    print('### createWidget Work ==> ${model.PRODUCTNAME}');
    return Card(
      color: colors[index],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 250,
                  child: ShowTitle(
                    title: model.PRODUCTNAME,
                    textStyle: MyConstant().h3Style(),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShowTitle(
                  title: model.BARCODE,
                  textStyle: MyConstant().h3PrimaryStyle(),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShowTitle(title: formatQTY(model.QTY)),
                    SizedBox(
                      width: 4,
                    ),
                    ShowTitle(title: model.UNITNAME),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String formatQTY(String qty) {
    String result;
    List<String> strings = qty.split('.');
    if (strings[0] == null) {
      result = qty;
    } else {
      result = strings[0];
    }
    return result;
  }

  Widget buildSearch(BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.grey.shade200),
            height: 40,
            width: constraints.maxWidth * 0.6,
            child: TextFormField(
              controller: textEditingController,
              decoration: InputDecoration(
                hintText: 'หมายเลขสั่งซื้อ',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              String search = textEditingController.text.trim();
              print('### search in TextFromField ==> $search');
              if (search.isNotEmpty) {
                processSearch(search);
              } else {
                print('### search Empty');
                MyDialog().normalDialog(context,
                    title: 'หมายเลขสั่งซื้อ ยังไม่มี',
                    message: 'กรุณากรอก หรือ สแกน BarCode');
              }
            },
            child: Text('Search'),
          ),
        ],
      ),
    );
  }
}
