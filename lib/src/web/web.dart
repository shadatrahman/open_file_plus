import 'dart:async';
import 'dart:js_interop';

@JS('window.resolveLocalFileSystemURL')
external void _resolveLocalFileSystemUrl(
  String url,
  JSFunction successCallback,
  JSFunction errorCallback,
);

Future<bool> open(String uri) {
  final completer = Completer<bool>();
  _resolveLocalFileSystemUrl(
    uri,
    ((JSAny entry) => completer.complete(true)).toJS,
    ((JSAny error) => completer.complete(false)).toJS,
  );
  return completer.future;
}
