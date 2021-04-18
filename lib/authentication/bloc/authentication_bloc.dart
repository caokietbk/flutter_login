import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  late StreamSubscription<AuthenticationStatus>
      _authenticationStatusSubscription;

  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
    required UserRepository userRepository,
  })   : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        super(const AuthenticationState.unknown()) {
    _authenticationStatusSubscription =
        _authenticationRepository.status.listen((status) {
      add(AuthenticationStatusChange(status));
    });
  }

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationStatusChange) {
      yield await _mapAuthenticationStatusChangeToState(event);
    } else if (event is AuthenticationLogoutRequest) {
      _authenticationRepository.logOut();
    }
  }

  Future<AuthenticationState> _mapAuthenticationStatusChangeToState(
      AuthenticationStatusChange event) async {
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return const AuthenticationState.unanthenticated();
      case AuthenticationStatus.authenticated:
        final user = await _tryGetUser();
        if (user != null) {
          return AuthenticationState.authenticated(user);
        }
        return const AuthenticationState.unanthenticated();
      default:
        return const AuthenticationState.unknown();
    }
  }

  Future<User?> _tryGetUser() async {
    try {
      final user = await _userRepository.getUser();
      return user;
    } on Exception {
      return null;
    }
  }

  @override
  Future<void> close() {
    _authenticationRepository.dispose();
    _authenticationStatusSubscription.cancel();
    return super.close();
  }
}
