import 'dart:convert';

class Mock {
  String owner;
  int id;
  String testText;
  int testNum;

  Mock({
    this.owner,
    this.id,
    this.testText,
    this.testNum,
  });

  factory Mock.fromJson(Map<String, dynamic> json) => new Mock(
    owner: json["owner"],
    id: json["id"],
    testText: json["test_text"],
    testNum: json["test_num"],
  );

  Map<String, dynamic> toJson() => {
    "owner": owner,
    "id": id,
    "test_text": testText,
    "test_num": testNum,
  };
}
