library history;

import "dart:convert";
import "dart:html";

import "./info.dart";

class History {
  static const int size = 20;
  static const String key = "InMusic_history";

  Storage storage = window.localStorage;
  List<MusicInfo> list;

  void _init() {
    list = [];
    save();
  }
  void load() {
    if(storage.containsKey(key) && storage[key].isNotEmpty) {
      try {
        list = new List.from((JSON.decode(storage[key]) as List).map((o) => new MusicInfo.fromJSON(o)));
      } catch(e) {
        _init();
      }
    } else {
      _init();
    }
  }
  void save() {
    storage[key] = JSON.encode(new List.from(list.map((o) => o.toJSON())));
  }

  void add(MusicInfo value) {
    list.add(value);
    if(list.length > size) {
      list.removeAt(0);
    }
  }
}
