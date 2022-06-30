class Status {
  Status({
    required this.statusCode,
    this.object,
    this.exception,
    this.message,
  });

  final int statusCode;
  final Object? object;
  final Object? exception;
  final String? message;
}
