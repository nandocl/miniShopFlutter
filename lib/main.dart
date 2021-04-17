import 'package:flutter/material.dart';

//Pages
import 'package:front/src/pages/home.page.dart';
import 'package:front/src/pages/img.page.dart';
import 'package:front/src/pages/imgpick.page.dart';
import 'package:front/src/pages/settings.page.dart';
import 'package:front/src/pages/store.page.dart';
import 'package:front/src/pages/storedit.page.dart';
import 'package:front/src/pages/storemenu.page.dart';
import 'package:front/src/pages/submenu.page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DirOca admin',
      theme: ThemeData(primaryColor: Colors.deepOrange),
      initialRoute: 'home',
      routes: {
        'home': (BuildContext context) => HomePage(),
        'submenu': (BuildContext context) => SubmenuPage(),
        'storemenu': (BuildContext context) => StoremenuPage(),
        'store': (BuildContext context) => StorePage(),
        'storedit': (BuildContext context) => StoreditPage(),
        'imgPick': (BuildContext context) => ImgPickPage(),
        'img': (BuildContext context) => ImagePage(),
        'settings': (BuildContext context) => SettingsPage(),
      },
    );
  }
}
