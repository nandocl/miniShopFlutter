import 'package:flutter/material.dart';

class SnackBarWidgetMsg {
  static showSnackBar(GlobalKey<ScaffoldState> scaffoldKey,
      {@required int res}) {
    String contentText;
    int type;
    if (res == 0) {
      contentText = 'Bien!!!';
      type = 2;
    } else if (res == 1) {
      contentText = 'Error con el servidor.';
      type = 3;
    } else if (res == 2) {
      contentText = 'Usuario no autenticado.';
      type = 3;
    } else if (res == 3) {
      contentText = 'Este elemento tiene contenido. Borrelo primero.';
      type = 1;
    } else if (res == 4) {
      contentText = 'Este elemnto ya existe.';
      type = 1;
    } else if (res == 5) {
      contentText = 'Llave guardada.';
      type = 2;
    }
    final snackBar = SnackBar(
      duration: Duration(seconds: 3),
      // behavior: SnackBarBehavior.floating,
      // margin: EdgeInsets.all(10),
      content: Row(
        children: [
          Icon(
            type == 1
                ? Icons.info_outline
                : type == 2
                    ? Icons.done
                    : Icons.warning_amber_outlined,
            color: Colors.white,
          ),
          SizedBox(width: 10),
          Text(contentText),
        ],
      ),
      backgroundColor: type == 1
          ? Colors.grey[850]
          : type == 2
              ? Colors.green
              : Colors.red[600],
    );
    ScaffoldMessenger.of(scaffoldKey.currentContext).showSnackBar(snackBar);
  }
}
