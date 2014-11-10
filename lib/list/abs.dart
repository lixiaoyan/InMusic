part of list;

abstract class PlayList {
  StreamController<MusicInfo> _onChangedController = new StreamController<MusicInfo>.broadcast();
  Stream<MusicInfo> get onChanged => _onChangedController.stream;
  StreamController<MusicInfo> _onBeforeChangeController = new StreamController<MusicInfo>.broadcast(sync: true);
  Stream<MusicInfo> get onBeforeChange => _onBeforeChangeController.stream;
  MusicInfo current = null;
  bool isLoading = false;
  void next();
}
