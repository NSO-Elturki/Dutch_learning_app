import 'package:dutch_learning_app/classes/words.dart';


class Types {
  String _type;
  List<Words> words = new List<Words>();
  Types(String type, String word, String img) {
    this._type = type;
    this.words.add(new Words(img, word));
  }
}
