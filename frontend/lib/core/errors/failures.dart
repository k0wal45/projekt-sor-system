abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = "Wystąpił błąd serwera."]);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = "Nieprawidłowe dane logowania."]);
}
