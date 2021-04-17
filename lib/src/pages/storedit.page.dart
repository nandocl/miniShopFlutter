import 'package:flutter/material.dart';
import 'package:front/src/models/items.dart';

class StoreditPage extends StatefulWidget {
  @override
  _StoreditPageState createState() => _StoreditPageState();
}

class _StoreditPageState extends State<StoreditPage> {
  GlobalKey<FormState> _loginForm = GlobalKey<FormState>();
  TextEditingController _nombreCtrl = new TextEditingController();
  TextEditingController _infoCtrl = new TextEditingController();
  TextEditingController _telCtrl = new TextEditingController();
  TextEditingController _addressCtrl = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    String action = args['action'];
    StoreItem storeItem = args['item'];
    String paId = args['paId'];
    _nombreCtrl.text = storeItem.name;
    _infoCtrl.text = storeItem.info;
    _telCtrl.text = storeItem.tel;
    _addressCtrl.text = storeItem.address;
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text(action.toUpperCase() + ' TIENDA'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, 'home', (route) => false))
          ],
        ),
        bottomNavigationBar: GestureDetector(
          child: Container(
            color: Colors.blue,
            height: 50,
            width: double.infinity,
            child: Center(
              child: Text(
                "Siguiente",
                style: TextStyle(fontSize: 19, color: Colors.white),
              ),
            ),
          ),
          onTap: () {
            if (_loginForm.currentState.validate()) {
              var item = storeItem;
              item.name = _nombreCtrl.text;
              item.tel = _telCtrl.text;
              item.info = _infoCtrl.text;
              item.address = _addressCtrl.text;
              Navigator.pushNamed(context, 'imgPick',
                  arguments: <String, dynamic>{'item': item, 'paId': paId});
            }
          },
        ),
        body: Container(
            margin: EdgeInsets.only(right: 25, left: 25, top: 30),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                      key: _loginForm,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              autofocus: true,
                              textCapitalization: TextCapitalization.sentences,
                              controller: _nombreCtrl,
                              decoration: InputDecoration(
                                  labelText: 'Nombre de la tienda.'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Agrege un nombre a la tienda.';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _telCtrl,
                              keyboardType: TextInputType.number,
                              decoration:
                                  InputDecoration(labelText: 'Teléfono.'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Agrege Teléfono.';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: _addressCtrl,
                              decoration: InputDecoration(
                                  labelText: 'Dirección de la tienda.'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Agrege la dirección de la tienda.';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              minLines: 6,
                              maxLines: 7,
                              controller: _infoCtrl,
                              decoration: InputDecoration(
                                  labelText: 'Información de la tienda.'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Agrege información a la tienda.';
                                }
                                return null;
                              },
                            )
                          ])),
                ],
              ),
            )),
      ),
    );
  }
}
