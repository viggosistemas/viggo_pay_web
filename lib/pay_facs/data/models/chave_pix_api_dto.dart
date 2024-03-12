class ChavePixApiDto {
  late String name;
  late String type;
  late String status;
  bool selected = false;

  ChavePixApiDto.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {};
    result['name'] = name;
    result['type'] = type;
    result['status'] = status;

    return result;
  }
}
