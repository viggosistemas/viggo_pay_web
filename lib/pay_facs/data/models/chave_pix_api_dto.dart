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

class ChavePixGeradaApiDto {
  late AliasApiDto alias;
  late bool needsIdentifyConfirmation;

  ChavePixGeradaApiDto.fromJson(Map<String, dynamic> json) {
    alias = AliasApiDto.fromJson(json['alias']);
    needsIdentifyConfirmation = json['needsIdentifyConfirmation'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {};
    result['alias'] = alias;
    result['needsIdentifyConfirmation'] = needsIdentifyConfirmation;

    return result;
  }
}

class AliasApiDto {
  late String status;
  late String type;

  AliasApiDto.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {};
    result['status'] = status;
    result['type'] = type;

    return result;
  }
}
