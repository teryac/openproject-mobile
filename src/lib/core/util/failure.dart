class NetworkFailure {
  final int? statusCode;
  final String errorMessage;

  const NetworkFailure({
    this.statusCode,
    required this.errorMessage,
  });
}
