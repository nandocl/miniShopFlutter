import 'dart:developer';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:typed_data';

import '../models/items.dart';
import '../vars/localVars.dart' as localVars;
import '../services/extServices.dart' as extServices;
import '../services/user.service.dart' as userService;

Future<Map<String, String>> getHeaders() async {
  Map headers = localVars.headers;
  String sec = await userService.getUserId();
  if (sec != null) headers['auth'] = sec;
  return headers;
}

Future<List<MenuItem>> mainMenu(String id) async {
  List<MenuItem> menu = [];
  var response = await http.post(
      Uri.http(localVars.backendUrl, '/api/getMainMenu'),
      headers: localVars.headers,
      body: convert.jsonEncode(<String, dynamic>{'pa': id}));
  if (response.statusCode == 200) {
    List<dynamic> jsonResponde = convert.jsonDecode(response.body);
    menu = jsonResponde.map((item) => MenuItem.fromJson(item)).toList();
    return menu;
  } else {
    return null;
  }
}

Future<int> createMenuItem(String name, String id) async {
  Map<String, String> headers = await getHeaders();
  var response = await http.post(
      Uri.http(localVars.backendUrl, '/api/createMenuItem'),
      headers: headers,
      body: convert.jsonEncode(<String, dynamic>{'name': name, 'pa': id}));
  if (response.statusCode == 200) {
    return 0;
  } else if (response.statusCode == 401) {
    return 2;
  } else if (response.statusCode == 407) {
    return 4;
  } else {
    return 1;
  }
}

Future<int> deleteMenuItem(String id) async {
  Map<String, String> headers = await getHeaders();
  var response = await http.post(
      Uri.http(localVars.backendUrl, '/api/deleteMenuItem'),
      headers: headers,
      body: convert.jsonEncode(<String, dynamic>{'id': id}));
  if (response.statusCode == 200) {
    return 0;
  } else if (response.statusCode == 401) {
    return 2;
  } else if (response.statusCode == 406) {
    return 3;
  } else {
    return 1;
  }
}

Future<int> editMenuItem(String id, String newName) async {
  Map<String, String> headers = await getHeaders();
  var response = await http.post(
      Uri.http(localVars.backendUrl, '/api/editMenuItem'),
      headers: headers,
      body:
          convert.jsonEncode(<String, dynamic>{'id': id, 'newName': newName}));
  if (response.statusCode == 200) {
    return 0;
  } else {
    return 1;
  }
}

Future<List<StoreItem>> getStoresMenu(String id) async {
  List<StoreItem> menu = [];
  var response = await http.post(
      Uri.http(localVars.backendUrl, '/api/getStoresMenu'),
      headers: localVars.headers,
      body: convert.jsonEncode(<String, dynamic>{'pa': id}));
  if (response.statusCode == 200) {
    List<dynamic> jsonResponde = convert.jsonDecode(response.body);
    menu = jsonResponde.map((item) => StoreItem.fromJson(item)).toList();
    return menu;
  } else {
    return null;
  }
}

Future<StoreItem> getFullStore(String id) async {
  var storeItem = new StoreItem();
  var response = await http.post(
      Uri.http(localVars.backendUrl, '/api/getFullStore'),
      headers: localVars.headers,
      body: convert.jsonEncode(<String, dynamic>{'id': id}));
  inspect(response);
  if (response.statusCode == 200) {
    var jsonResponde = convert.jsonDecode(response.body);
    storeItem = StoreItem.fromJson(jsonResponde);
    return storeItem;
  } else {
    return null;
  }
}

Future<int> deleteStoreItem(String id) async {
  Map<String, String> headers = await getHeaders();
  var response = await http.post(
      Uri.http(localVars.backendUrl, '/api/deleteStoreItem'),
      headers: headers,
      body: convert.jsonEncode(<String, dynamic>{'id': id}));
  if (response.statusCode == 200) {
    return 0;
  } else if (response.statusCode == 401) {
    return 2;
  } else if (response.statusCode == 406) {
    return 3;
  } else {
    return 1;
  }
}

Future<int> addStore(
    List<Asset> images, StoreItem item, List<String> deletedImg) async {
  // Uri uri = Uri.parse(localVars.backendUrl + '/api/addStore');
  Uri uri = Uri.http(localVars.backendUrl, '/api/addStore');

  // create multipart request
  http.MultipartRequest request = http.MultipartRequest("POST", uri);

  for (int i = 0; i < images.length; i++) {
    ByteData byteData = await extServices.resizeImageFile(images[i]);
    List<int> imageData = byteData.buffer.asUint8List();

    http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
      'images',
      imageData,
      filename: images[i].name,
    );

    // add file to multipart
    request.files.add(multipartFile);
  }
  Map<String, String> headers = await getHeaders();
  request.headers.addAll(headers);

  //adding params
  request.fields['id'] = item.id == null ? '' : item.id;
  request.fields['name'] = item.name;
  request.fields['info'] = item.info;
  request.fields['pa'] = item.pa;
  request.fields['delImg'] = convert.jsonEncode(deletedImg);
  request.fields['img'] =
      item.img == null ? '[]' : convert.jsonEncode(item.img);
  request.fields['tel'] = item.tel;
  request.fields['address'] = item.address;
// send
  var response = await request.send();
  if (response.statusCode == 200) {
    return 0;
  } else if (response.statusCode == 401) {
    return 2;
  } else if (response.statusCode == 407) {
    return 4;
  } else {
    return 1;
  }
}
