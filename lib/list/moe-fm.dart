part of list;

class MoeFMList extends PlayList {
  static const API_KEY = "498f353551017ccaf9b8bec5267ecb6c0545b26eb";
  List<MusicInfo> _cached = [];
  void next() {
    if(isLoading) {
      return;
    }
    if(_cached.length > 0) {
      _next();
    } else {
      _load();
    }
  }
  void _next() {
    _onBeforeChangeController.add(current);
    current = _cached[0];
    _cached.removeAt(0);
    _onChangedController.add(current);
  }
  void _load() {
    isLoading = true;
    jsonp.request(Uri.parse("http://moe.fm/listen/playlist").replace(queryParameters: {
      "api": "json",
      "api_key": API_KEY
    }).toString()).then((data) {
      var list = data["response"]["playlist"] as List;
      list.forEach((item) {
        _cached.add(new MusicInfo()
          ..title = item["sub_title"]
          ..artist = item["artist"]
          ..album = item["wiki_title"]
          ..url = item["url"]
          ..cover = item["cover"]["medium"]
          ..external = item["sub_url"]
        );
      });
      isLoading = false;
      _next();
    });
  }
}
