class FormatMask {
  FormatMask();

  String formated(String value){
    value = value.replaceAll('/D/g', "");

  if (value.length <= 11) {
    var path = '${value.substring(0, 3)}.';
    var path2 = '${value.substring(3, 6)}.';
    var path3 = '${value.substring(6, 9)}-';
    var path4 = value.substring(9, 11);
    value = '$path$path2$path3$path4';
  } else {
    // 380 457 150 00 133
    var path = '${value.substring(0, 2)}.';
    var path2 = '${value.substring(2, 5)}.';
    var path3 = '${value.substring(5, 8)}/';
    var path4 = '${value.substring(8, 12)}-';
    var path5 = value.substring(12, 14);
    value = '$path$path2$path3$path4$path5';
  }

  return value;
  }
}