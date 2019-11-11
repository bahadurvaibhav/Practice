import 'dart:async';

class PracticeItem {
  final String skillType;
  final String createdAt;

  const PracticeItem({this.skillType, this.createdAt});

  PracticeItem.fromMap(Map<String, dynamic> map)
      : skillType = "${map['name']['first']} ${map['name']['last']}",
        createdAt = map['email'];
}

abstract class PracticeRepository {
  Future<List<PracticeItem>> fetch();
}

class FetchDataException implements Exception {
  String _message;

  FetchDataException(this._message);

  String toString() {
    return "Exception: $_message";
  }
}
