class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is Map && error['detail'] != null) {
      return error['detail'];
    }
    return error.toString();
  }
}
