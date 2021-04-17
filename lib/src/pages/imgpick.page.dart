import 'package:flutter/material.dart';
import 'package:front/src/widgets/loading.widget.dart';
import 'package:front/src/widgets/snackBarMsg.widget.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import '../models/items.dart';
import '../services/http.service.dart' as httpService;

class ImgPickPage extends StatefulWidget {
  @override
  _ImgPicPageState createState() => _ImgPicPageState();
}

class _ImgPicPageState extends State<ImgPickPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Asset> images = [];
  StoreItem storeItem;
  String paId;
  int maxNumberOfImages;
  List<String> deletedImg = [];
  bool cargando = false;
  @override
  Widget build(BuildContext context) {
    double widthS = MediaQuery.of(context).size.width;
    final args =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    storeItem = args['item'];
    paId = args['paId'];
    storeItem.img != null
        ? maxNumberOfImages = 3 - storeItem.img.length
        : maxNumberOfImages = 3;
    return Container(
        child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text('Seleccione imágenes'),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.pop(context)),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  storeItem.img != null
                      ? Container(
                          margin: EdgeInsets.all(20),
                          child: Wrap(
                            spacing: 5,
                            direction: Axis.horizontal,
                            children: [
                              for (var item in storeItem.img)
                                GestureDetector(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey[500])),
                                    child: Image.network(item),
                                    width: (widthS - 80) / 3,
                                    height: (widthS - 80) / 3,
                                  ),
                                  onTap: () {
                                    deletedImg.add(item);
                                    storeItem.img.remove(item);
                                    setState(() {});
                                  },
                                )
                            ],
                          ),
                        )
                      : SizedBox(
                          height: 10,
                        ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            child: Text('Seleccionar'),
                            onPressed:
                                (maxNumberOfImages != 0) ? pickImages : null),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                            child: Text('Quitar todas'),
                            onPressed: (images.length != 0)
                                ? () {
                                    setState(() {
                                      images = [];
                                    });
                                  }
                                : null),
                      ],
                    ),
                  ),
                  images.length == 0 ? noImg() : buildGridView(widthS)
                ],
              ),
            ),
            bottomNavigationBar: GestureDetector(
                child: Container(
                  color: Colors.blue,
                  height: 50,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      "Publicar",
                      style: TextStyle(fontSize: 19, color: Colors.white),
                    ),
                  ),
                ),
                onTap: () {
                  //Loading cuando este enviando con espera en segundos
                  if (images.length == 0 && storeItem.img == null)
                    return showAlert(
                        title: 'Sin imágenes',
                        content: 'Agrege por lo menos una imagen.');
                  publicarProd();
                })));
  }

  void publicarProd() async {
    LoadingWidget.showAlertDialog(context);
    if (storeItem.id == null) storeItem.pa = paId;
    int res = await httpService.addStore(images, storeItem, deletedImg);
    setState(() {});
    SnackBarWidgetMsg.showSnackBar(_scaffoldKey, res: res);
    Navigator.pushNamed(context, 'home');
  }

  Widget buildGridView(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < images.length; i++)
          Container(
            height: (width - 60) / 3,
            width: (width - 60) / 3,
            margin: EdgeInsets.all(5),
            child: AssetThumb(asset: images[i], width: 300, height: 300),
          )
      ],
    );
  }

  Widget noImg() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_search,
            color: Colors.grey,
          ),
          SizedBox(
            width: 10,
          ),
          (maxNumberOfImages != 0)
              ? Text(
                  'Seleccione imágenes.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                )
              : Text('Ya tiene 3 imágenes!!!',
                  style: TextStyle(fontSize: 18, color: Colors.grey)),
        ],
      ),
    );
  }

  Future<void> pickImages() async {
    List<Asset> resultList = [];
    // String error = 'No Error Dectected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: maxNumberOfImages,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          selectionLimitReachedText:
              'Deseleccione una imagen para escoger otra.',
          textOnNothingSelected: 'Nada para seleccionar',
          actionBarColor: "#536dfe",
          actionBarTitle: "Seleccionar",
          allViewTitle: "Todas las fotos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      print(e);
      // error = e.toString();
    }
    if (!mounted) return;

    setState(() {
      images = resultList;
      LoadingWidget.showAlertDialog(context);
      Future.delayed(const Duration(milliseconds: 4000), () {
        Navigator.pop(context);
      });
    });
  }

  void showAlert({String title, String content}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(title), Icon(Icons.info)]),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(content),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        ElevatedButton(
                          child: Text('Aceptar'),
                          onPressed: () => Navigator.pop(context),
                        )
                      ])
                ],
              ),
            ));
  }
}
