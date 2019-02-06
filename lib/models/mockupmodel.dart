import 'dart:convert';

class Mock {
  int id;
  String owner;
  String testText;
  int testNum;

  Mock({
    this.id,
    this.owner,
    this.testText,
    this.testNum,
  });

  factory Mock.fromJson(Map<String, dynamic> json) => new Mock(
    id: json["id"],
    owner: json["owner"],
    testText: json["test_text"],
    testNum: json["test_num"],
  );

  Map<String, dynamic> toJson({bool updated=true, bool deleted=false}) => {
    //"id": id,
    "owner": owner,
    "test_text": testText,
    "test_num": testNum,
    "is_update" : updated ? 1 : 0,
    "is_deleted" : deleted? 1 : 0,
  };

  factory Mock.fromJson_API(Map<String, dynamic> json) => new Mock(
    id: json["id"],
    owner: json["owner"],
    testText: json["test_text"],
    testNum: json["test_num"],
  );

  Map<String, dynamic> toJson_API() => {
    //"id": id,
    //"owner": owner,
    "test_text": testText,
    "test_num": testNum.toString(),
  };
}
