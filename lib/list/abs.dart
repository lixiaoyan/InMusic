part of list;

abstract class PlayList {
  StreamController<MusicInfo> _onLoadedController = new StreamController<MusicInfo>.broadcast();
  Stream<MusicInfo> get onLoaded => _onLoadedController.stream;
  MusicInfo current = null;
  bool isLoading = false;
  void next();
}
