enum ErrorType {
  network,
  server,
  unknown,
}

class Result<T> {
  final T? data;
  final String? error;
  final ErrorType? type;
  const Result({this.data, this.error, this.type});

  bool get isSuccess => data != null && error == null;
  bool get isError => error != null;
}
