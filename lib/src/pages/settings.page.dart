import 'package:flutter/material.dart';
import '../widgets/snackBarMsg.widget.dart';

import '../services/user.service.dart' as user;

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController _idCtrl = new TextEditingController();
  GlobalKey<FormState> _loginForm = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    user.getUserId().then((userId) {
      if (userId != null) _idCtrl.text = userId;
    });
    return Container(
        child: Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context)),
        title: Text('Ajustes'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 30, right: 30, left: 30),
        child: Column(
          children: [
            Form(
              key: _loginForm,
              child: Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: _idCtrl,
                      obscureText: true,
                      decoration: InputDecoration(labelText: 'ID de usuario'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Escriba una id de usuario.';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.save),
                      onPressed: () {
                        if (_loginForm.currentState.validate()) {
                          user.setUserId(_idCtrl.text);
                          SnackBarWidgetMsg.showSnackBar(_scaffoldKey, res: 5);
                        }
                      })
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
