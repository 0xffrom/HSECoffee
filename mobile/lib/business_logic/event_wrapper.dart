class EventWrapper<T> {
  final int statusCode;
  final T _data;
  final String message;

  EventWrapper(this.statusCode, this._data, this.message);

  bool isSuccess() {
    return _data != null;
  }

  T getData() {
    if (isSuccess()) {
      return _data;
    }

    throw Exception("Data is null");
  }
}
