import 'package:equatable/equatable.dart';

class AuthFailure extends Equatable {
  const AuthFailure(this.message, [this.code]);

  final String message;
  final String? code;

  @override
  List<Object?> get props => [message, code];
}

class NetworkFailure extends Equatable {
  const NetworkFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Equatable {
  const ServerFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
