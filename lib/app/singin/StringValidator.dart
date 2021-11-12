abstract class StringValidator{
  bool isValid(String value);
}

class NotEmptyStringValidator implements StringValidator {
  @override
  bool isValid(String value){
    return value.isNotEmpty;
  }
}

class EmailAndPasswordValidators{
  final StringValidator emailValidator = NotEmptyStringValidator(); 
  final StringValidator passwordValidator = NotEmptyStringValidator(); 
  final String invalidEmailErrorText = 'El correo es obligatorio';
  final String invalidPasswordErrorText = 'La contraseña es obligatoria';
}