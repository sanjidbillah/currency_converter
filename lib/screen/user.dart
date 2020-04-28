class User {
  int id;
  String short;
  String name;
  String flag;

  User({this.id, this.short, this.name, this.flag});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    short = json['short'];
    name = json['name'];
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['short'] = this.short;
    data['name'] = this.name;
    data['flag'] = this.flag;
    return data;
  }
}