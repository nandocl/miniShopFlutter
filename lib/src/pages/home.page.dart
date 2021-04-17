import 'package:flutter/material.dart';
import '../widgets/snackBarMsg.widget.dart';

import '../services/http.service.dart' as httpService;
import '../models/items.dart';
import '../widgets/menu.button.widget.dart';
// import '../widgets/alert.nodelete.widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _newItemKey = GlobalKey<FormState>();
  TextEditingController _nombreCtrl = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('Menú principal'),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () => Navigator.pushNamed(context, 'settings'))
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xffFF5722),
            child: Icon(Icons.add),
            onPressed: () {
              addItemWindow();
            },
          ),
          body: Container(
            padding: EdgeInsets.only(top: 10, right: 10, left: 10),
            color: Colors.grey[50],
            child: FutureBuilder(
                future: httpService.mainMenu('main'),
                builder: (context, AsyncSnapshot<List<MenuItem>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length == 0)
                      return Center(
                          child: Text('Sin categorías',
                              style: TextStyle(fontSize: 20)));
                    else
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return MenuItemButton(
                              item: snapshot.data[index],
                              deleteCb: () async {
                                int res = await httpService
                                    .deleteMenuItem(snapshot.data[index].id);
                                setState(() {});
                                SnackBarWidgetMsg.showSnackBar(_scaffoldKey,
                                    res: res);
                              },
                              editCb: () {
                                editItem(snapshot.data[index]);
                              },
                              onTap: () {
                                Navigator.pushNamed(context, 'submenu',
                                    arguments: <String, String>{
                                      'id': snapshot.data[index].id,
                                      'name': snapshot.data[index].name
                                    });
                              },
                            );
                          });
                  } else {
                    return Center(child: Text('Cargando...'));
                  }
                }),
          )),
    );
  }

  void addItemWindow() {
    String _name;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Agregar nueva categoría'),
              content: Form(
                key: _newItemKey,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  TextFormField(
                    autofocus: true,
                    onChanged: (name) => _name = name,
                    decoration:
                        InputDecoration(hintText: 'Nombre de la categoria'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Agrege nombre de la categoria.';
                      }
                      return null;
                    },
                  ),
                ]),
              ),
              actions: [
                ElevatedButton(
                    style: TextButton.styleFrom(primary: Colors.white),
                    onPressed: () async {
                      if (_newItemKey.currentState.validate()) {
                        int res =
                            await httpService.createMenuItem(_name, 'main');
                        Navigator.pop(context);
                        setState(() {});
                        SnackBarWidgetMsg.showSnackBar(_scaffoldKey, res: res);
                      }
                    },
                    child: Text('Aceptar')),
                TextButton(
                    style: TextButton.styleFrom(primary: Colors.blue[600]),
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancelar'))
              ],
            ));
  }

  void editItem(MenuItem item) {
    _nombreCtrl.text = item.name;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Editar categoría'),
              content: Form(
                key: _newItemKey,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  TextFormField(
                    autofocus: true,
                    controller: _nombreCtrl,
                    decoration: InputDecoration(labelText: 'Nombre'),
                  ),
                ]),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () async {
                      int res = await httpService.editMenuItem(
                          item.id, _nombreCtrl.text);
                      setState(() {});
                      SnackBarWidgetMsg.showSnackBar(_scaffoldKey, res: res);
                      Navigator.pop(context);
                    },
                    child: Text('Aceptar')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancelar'))
              ],
            ));
  }
}
