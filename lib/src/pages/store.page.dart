import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:front/src/widgets/loading.widget.dart';
import 'package:front/src/widgets/snackBarMsg.widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/http.service.dart' as httpService;
import 'package:front/src/models/items.dart';

class StorePage extends StatefulWidget {
  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    bool infinite = true;
    String itemId = args['id'];
    String name = args['name'];
    StoreItem storeItem;
    return Container(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(name.toUpperCase()),
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_outlined),
              onPressed: () => Navigator.pop(context)),
          actions: [
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => showAlert(
                    title: 'Se borrará este elemento.',
                    content: 'Seguro desea continuar?',
                    id: storeItem.id)),
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => Navigator.pushNamed(context, 'storedit',
                        arguments: <String, dynamic>{
                          'action': 'Editar',
                          'item': storeItem,
                          'paId': ''
                        }))
          ],
        ),
        body: Container(
          padding: EdgeInsets.only(top: 10, right: 10, left: 10),
          color: Colors.grey[50],
          child: FutureBuilder(
              future: httpService.getFullStore(itemId),
              builder: (context, AsyncSnapshot<StoreItem> snapshot) {
                if (snapshot.hasData) {
                  storeItem = snapshot.data;
                  final List<String> imgList = snapshot.data.img;
                  List<String> tels = snapshot.data.tel.split(',');
                  if (imgList.length == 1) infinite = false;
                  return SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              CarouselSlider(
                                options: CarouselOptions(
                                    enableInfiniteScroll: infinite,
                                    viewportFraction: 0.6,
                                    enlargeCenterPage: true,
                                    aspectRatio: 2,
                                    scrollDirection: Axis.horizontal,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        _current = index;
                                      });
                                    }),
                                items: imgList.map((item) {
                                  return Container(
                                      // padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: GestureDetector(
                                          child: Center(
                                              child: FadeInImage.assetNetwork(
                                                  placeholder:
                                                      'assets/img/loading.gif',
                                                  image: item)),
                                          onTap: () {
                                            List<String> imgs = [];
                                            List<String> imgsList =
                                                snapshot.data.img;
                                            imgs.insert(0, item);
                                            int newPos = imgsList.indexOf(item);
                                            for (int i = 1;
                                                i < imgsList.length;
                                                i++) {
                                              if (newPos + 1 <
                                                  imgsList.length) {
                                                newPos = newPos + 1;
                                              } else {
                                                newPos = 0;
                                              }
                                              imgs.insert(i, imgsList[newPos]);
                                            }
                                            Navigator.pushNamed(context, 'img',
                                                arguments: imgs);
                                          }));
                                }).toList(),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: imgList.map((url) {
                                  int index = imgList.indexOf(url);
                                  return Container(
                                    width: 8.0,
                                    height: 8.0,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 2.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _current == index
                                          ? Color.fromRGBO(0, 0, 0, 0.9)
                                          : Color.fromRGBO(0, 0, 0, 0.4),
                                    ),
                                  );
                                }).toList(),
                              )
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            child: Center(
                                child: Text(
                              snapshot.data.name.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: Text(snapshot.data.info,
                                textAlign: TextAlign.justify),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: Text(
                              'Dirección: ' + snapshot.data.address,
                              style: TextStyle(
                                  fontSize: 16, fontStyle: FontStyle.italic),
                            ),
                          ),
                          Column(
                            children: [
                              for (var tel in tels)
                                ElevatedButton.icon(
                                  onPressed: () => launch('tel:' + tel),
                                  label: Text(tel),
                                  icon: Icon(Icons.phone),
                                )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                } else
                  return Center(child: Text('Cargando...'));
              }),
        ),
      ),
    );
  }

  void showAlert({String title, String content, String id}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: [
                ElevatedButton(
                  child: Text('Borrar'),
                  onPressed: () async {
                    int res = await httpService.deleteStoreItem(id);
                    setState(() {});
                    SnackBarWidgetMsg.showSnackBar(_scaffoldKey, res: res);
                    Navigator.pushNamed(context, 'home');
                  },
                ),
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancelar'))
              ],
            ));
  }
}
