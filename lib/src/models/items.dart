class MenuItem {
  MenuItem({
    this.id,
    this.name,
    this.state,
    this.pa,
    this.date,
    this.imp,
  });

  String id;
  String name;
  bool state;
  String pa;
  String date;
  int imp;

  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
        id: json["_id"],
        name: json["name"],
        state: json["state"],
        pa: json["pa"],
        date: json["date"],
        imp: json["imp"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "state": state,
        "pa": pa,
        "date": date,
        "imp": imp,
      };
}

class StoreItem {
  StoreItem(
      {this.id,
      this.name,
      this.state,
      this.pa,
      this.info,
      this.date,
      this.imp,
      this.img,
      this.tel,
      this.address});

  String id;
  String name;
  bool state;
  String pa;
  String info;
  String date;
  int imp;
  List<String> img;
  String tel;
  String address;

  factory StoreItem.fromJson(Map<String, dynamic> json) => StoreItem(
        id: json["_id"],
        name: json["name"],
        state: json["state"],
        pa: json["pa"],
        info: json["info"],
        date: json["date"],
        imp: json["imp"],
        img: List<String>.from(json["img"].map((x) => x)),
        tel: json["tel"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "state": state,
        "pa": pa,
        "info": info,
        "date": date,
        "imp": imp,
        "img": List<dynamic>.from(img.map((x) => x)),
        "tel": tel,
        "address": address,
      };
}
