library info;

class MusicInfo {
  String title;
  String artist;
  String album;
  String url;
  String cover;
  String external;

  MusicInfo();
  MusicInfo.fromJSON(Map<String, String> json) {
    title = json["title"];
    artist = json["artist"];
    album = json["album"];
    url = json["url"];
    cover = json["cover"];
    external = json["external"];
  }
  Map<String, String> toJSON() {
    return {
      "title": title,
      "artist": artist,
      "album": album,
      "url": url,
      "cover": cover,
      "external": external
    };
  }
}
