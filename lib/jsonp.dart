library jsonp;

import "dart:js";
import "dart:html";
import "dart:async";

var _count = 0;
String _generateName() => "__jsonp_cb_" + (_count++).toString();

Future request(String url, {key: "callback"}) {
  var name = _generateName();
  var completer = new Completer();

  var uri = Uri.parse(url);
  var query = new Map<String, String>.from(uri.queryParameters);
  query[key] = name;
  uri = uri.replace(queryParameters: query);
  url = uri.toString();

  var script = new ScriptElement();
  script.src = url;

  context[name] = (data) {
    completer.complete(data);
    context[name] = null;
    script.remove();
  };

  script.onError.listen((_) => completer.completeError(_));
  document.body.append(script);

  return completer.future;
}
