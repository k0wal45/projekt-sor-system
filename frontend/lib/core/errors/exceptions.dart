class ServerException implements Exception {
  final String message;
  ServerException([this.message = "Błąd serwera"]);
}

class InvalidCredentialsException implements Exception {
  final String message;
  InvalidCredentialsException([this.message = "Nieprawidłowy login lub hasło"]);
}
