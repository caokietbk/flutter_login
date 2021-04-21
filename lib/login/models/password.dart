import 'package:formz/formz.dart';

class Password extends FormzInput<String, String> {
  const Password.pure([String value = '']) : super.pure(value);
  const Password.dirty([String value = '']) : super.dirty(value);

  @override
  String? validator(String? value) {
    if (value != null) {
      if (value.isEmpty) {
        return "Password can't be empty";
      } else if (value.length < 6) {
        return 'Password must have at least 6 characters';
      }
      return null;
    }
    return "Password can't be null";
  }
}
