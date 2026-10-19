class OutOfStockException implements Exception {
  final String message;
  OutOfStockException(this.message);

  @override
  String toString() => 'OutOfStockException: $message';
}

class InvalidReturnException implements Exception {
  final String message;
  InvalidReturnException(this.message);

  @override
  String toString() => 'InvalidReturnException: $message';
}