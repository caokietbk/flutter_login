part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class AuthenticationStatusChange extends AuthenticationEvent {
  final AuthenticationStatus status;

  const AuthenticationStatusChange(this.status);

  @override
  List<Object?> get props => [status];
}

class AuthenticationLogoutRequest extends AuthenticationEvent {}
