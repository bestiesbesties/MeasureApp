import 'dart:typed_data';

void main() {
  List<int> myList = [87, 119, 177, 130, 66, 76, 0, 0, 128, 191];
  valuesFromFloatsAsBytes(myList);
}

List<dynamic> valuesFromFloatsAsBytes(List<int> myList) {
  try {
    final byteData = ByteData.sublistView(Uint8List.fromList(myList));

    final weight = byteData.getFloat32(1, Endian.little);
    final length = byteData.getFloat32(6, Endian.little);
    return [weight, length];

  } catch (e) {
    print("er ging iets fout");
    return [-1, -1];
  }


  // if (myList[0] != 0x57 || myList[5] != 0x4c) {
  //   return;
  // }

  final byteData = ByteData.sublistView(Uint8List.fromList(myList));

  final weight = byteData.getFloat32(1, Endian.little);
  final length = byteData.getFloat32(6, Endian.little);



  print('Weight: $weight kg');
  print('Length: $length cm');
  print(weight.toStringAsFixed(2));
}