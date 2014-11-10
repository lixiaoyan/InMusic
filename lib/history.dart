library history;

import "dart:collection";
import "dart:convert";
import "dart:html";

import "package:serialization/serialization_mirrors.dart";

import "./info.dart";

class HistoryList extends IterableBase<MusicInfo> {
  static const int size = 20;

  List<MusicInfo> _list;
  Iterator<MusicInfo> get iterator => _list.reversed.iterator;

  HistoryList() : _list = [];
  HistoryList.from(List<MusicInfo> list) :
    _list = new List<MusicInfo>.from(list.reversed);

  void add(MusicInfo value) {
    _list.add(value);
    if(_list.length > size) {
      _list.removeAt(0);
    }
  }
}

class History {
  static const String key = "InMusic_history";

  Storage storage = window.localStorage;
  Serialization _serialization = new Serialization()
    ..addRuleFor(MusicInfo);
  HistoryList list;

  void _init() {
    list = new HistoryList();
    save();
  }
  void load() {
    if(storage.containsKey(key) && storage[key].isNotEmpty) {
      try {
        list = new HistoryList.from(_serialization.read(JSON.decode(storage[key])));
      } catch(e) {
        _init();
      }
    } else {
      _init();
    }
  }
  void save() {
    storage[key] = JSON.encode(_serialization.write(new List<MusicInfo>.from(list)));
  }
}
