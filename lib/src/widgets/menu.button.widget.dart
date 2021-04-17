import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../vars/localVars.dart' as localVars;

class MenuItemButton extends StatelessWidget {
  final dynamic item;
  final Function deleteCb;
  final Function editCb;
  final Function onTap;
  final bool admin;

  const MenuItemButton(
      {this.item, this.deleteCb, this.editCb, this.onTap, this.admin});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey[400],
                offset: Offset(1.0, 1.0),
                blurRadius: 2.0,
              ),
            ],
            borderRadius: BorderRadius.circular(3),
            color: Colors.white,
          ),
          margin: EdgeInsets.all(5),
          child: Slidable(
            actionPane: SlidableBehindActionPane(),
            actions: [
              IconSlideAction(
                  color: Colors.red,
                  icon: Icons.delete_forever,
                  onTap: () => deleteCb()),
              IconSlideAction(
                color: Colors.green,
                icon: Icons.mode_outlined,
                onTap: () => editCb(),
              )
            ],
            child: Container(
              color: Colors.white,
              child: ListTile(
                title: Text(
                  item.name?.toUpperCase(),
                  style: TextStyle(),
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),
          ),
        ),
        onTap: () => onTap());
  }
}
