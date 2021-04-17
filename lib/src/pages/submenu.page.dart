import 'package:flutter/material.dart';
import 'package:front/src/models/items.dart';
import '../widgets/menu.button.widget.dart';
import '../widgets/alert.nodelete.widget.dart';
import '../widgets/snackBarMsg.widget.dart';

import '../services/http.service.dart' as httpService;

class SubmenuPage extends StatefulWidget {
  @override
  _SubmenuPageState createState() => _SubmenuPageState();
}

class _SubmenuPageState extends State<SubmenuPage> {
  final _newItemKey = GlobalKey<FormState>();
  TextEditingController _nombreCtrl = new TextEditingController();
  String subCatId = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    String itemId = args['id'];
    subCatId = itemId;
    String name = args['name'];
    return Container(
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(name.toUpperCase()),
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_sharp),
                onPressed: () => Navigator.pop(context)),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xffAFB42B),
            child: Icon(Icons.add),
            onPressed: () {
              addItemWindow();
            },
          ),
          body: Container(
            padding: EdgeInsets.only(top: 10, right: 10, left: 10),
            color: Colors.grey[50],
            child: FutureBuilder(
                future: httpService.mainMenu(itemId),
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
                                Navigator.pushNamed(context, 'storemenu',
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
                        InputDecoration(hintText: 'Nombre de la categoría'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Agrege nombre de la categoría.';
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
                            await httpService.createMenuItem(_name, subCatId);
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
                      Navigator.pop(context);
                      setState(() {});
                      SnackBarWidgetMsg.showSnackBar(_scaffoldKey, res: res);
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
