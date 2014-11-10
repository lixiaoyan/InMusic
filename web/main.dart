import "package:angular/angular.dart";
import "package:angular/application_factory.dart";

import "package:InMusic/player.dart";
import "package:InMusic/list.dart";
import "package:InMusic/history.dart";

@Formatter(name: "time")
class TimeFilter {
  String call(double time) {
    var intTime = time.toInt();
    var sign = "";
    if(intTime < 0) {
      sign = "-";
      intTime = -intTime;
    }
    var seconds = intTime % 60;
    var minutes = intTime ~/ 60;
    return sign + minutes.toString() + ":" + seconds.toString().padLeft(2, "0");
  }
}

@Formatter(name: "reverse")
class ReverseFilter {
  Iterable call(List list) {
    return list.reversed;
  }
}

@Injectable()
class App {
  AudioPlayer player = new AudioPlayer();
  PlayList list = null;
  History history = new History()..load();

  App() {
    list = new MoeFMList();
    player.onEnded.listen((_) => list.next());
    list.onBeforeChange.listen((data) {
      if(data != null) {
        history.add(data);
        history.save();
      }
    });
    list.onChanged.listen((data) => player.load(data.url, autoplay: true));
    list.next();
  }
}

class AppModule extends Module {
  AppModule() {
    bind(TimeFilter);
    bind(ReverseFilter);
  }
}

void main() {
  applicationFactory()
    .rootContextType(App)
    .addModule(new AppModule())
    .run();
}
