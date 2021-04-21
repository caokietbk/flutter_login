import 'package:formz/formz.dart';

class Username extends FormzInput<String, String> {
  const Username.pure([String value = '']) : super.pure(value);
  const Username.dirty([String value = '']) : super.dirty(value);

  @override
  String? validator(String? value) {
    if (value != null) {
      if (value.isEmpty) {
        return "The username can't be empty";
      } else if (value.length < 6) {
        return 'Username must have at least 6 characters';
      }
      return null;
    }
    return "Username can't be null";
  }
}
