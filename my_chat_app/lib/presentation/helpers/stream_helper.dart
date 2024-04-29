import 'dart:async';

class StreamHelper {
  final StreamController _controller = StreamController();

  Stream<dynamic> get stream => _controller.stream;

  void add(dynamic value) => _controller.sink.add(value);

  void close() {
    _controller.close();
  }
}
