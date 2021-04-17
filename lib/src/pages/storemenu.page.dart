import 'package:flutter/material.dart';
import 'package:front/src/widgets/snackBarMsg.widget.dart';

import '../services/http.service.dart' as httpService;
import 'package:front/src/models/items.dart';
import '../widgets/menu.button.widget.dart';

class StoremenuPage extends StatefulWidget {
  @override
  _StoremenuPageState createState() => _StoremenuPageState();
}

class _StoremenuPageState extends State<StoremenuPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    String itemId = args['id'];
    String name = args['name'];
    return Container(
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(name.toUpperCase()),
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_outlined),
                onPressed: () => Navigator.pop(context)),
          ),
          floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.black,
              child: Icon(Icons.add),
              onPressed: () => Navigator.pushNamed(context, 'storedit',
                      arguments: <String, dynamic>{
                        'action': 'Crear',
                        'item': StoreItem(),
                        'paId': itemId
                      })),
          body: Container(
            padding: EdgeInsets.only(top: 10, right: 10, left: 10),
            color: Colors.grey[50],
            child: FutureBuilder(
                future: httpService.getStoresMenu(itemId),
                builder: (context, AsyncSnapshot<List<StoreItem>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length == 0)
                      return Center(
                          child: Text(
                        'Sin tiendas',
                        style: TextStyle(fontSize: 20),
                      ));
                    else
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return MenuItemButton(
                              item: snapshot.data[index],
                              deleteCb: () async {
                                int res = await httpService
                                    .deleteStoreItem(snapshot.data[index].id);
                                setState(() {});
                                SnackBarWidgetMsg.showSnackBar(_scaffoldKey,
                                    res: res);
                              },
                              editCb: () {
                                Navigator.pushNamed(context, 'storedit',
                                    arguments: <String, dynamic>{
                                      'action': 'Editar',
                                      'item': snapshot.data[index],
                                      'paId': ''
                                    });
                              },
                              onTap: () {
                                Navigator.pushNamed(context, 'store',
                                    arguments: <String, String>{
                                      'id': snapshot.data[index].id,
                                      'name': snapshot.data[index].name
                                    });
                              },
                            );
                          });
                  } else
                    return Center(child: Text('Cargando...'));
                }),
          )),
    );
  }
}
