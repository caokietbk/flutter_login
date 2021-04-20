import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/login/login.dart';
import 'package:formz/formz.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Authentication failure')),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _UsernameField(),
            const SizedBox(height: 12),
            _PasswordField(),
            const SizedBox(height: 12),
            _SubmitButton(),
          ],
        ),
      ),
    );
  }
}

class _UsernameField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextField(
          onChanged: (username) {
            context.read<LoginBloc>().add(UsernameChange(username: username));
          },
          decoration: InputDecoration(
            labelText: 'Username',
            errorText: state.username.invalid ? state.username.error : null,
          ),
        );
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextField(
          onChanged: (password) {
            context.read<LoginBloc>().add(PasswordChange(password: password));
          },
          decoration: InputDecoration(
            labelText: 'Password',
            errorText: state.password.invalid ? state.password.error : null,
          ),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state.status.isSubmissionInProgress) {
          return const CircularProgressIndicator();
        }
        return ElevatedButton(
          child: const Text('Login'),
          onPressed: state.status.isValidated
              ? () {
                  context.read<LoginBloc>().add((const LoginSubmit()));
                }
              : null,
        );
      },
    );
  }
}
