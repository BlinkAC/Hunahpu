import 'package:cursoflutter/app/singin/StringValidator.dart';
import 'package:cursoflutter/common%20widgets/form_submit_button.dart';
import 'package:cursoflutter/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum emailSignInformType { sigIn, register }

class EmailSiginForm extends StatefulWidget with EmailAndPasswordValidators {
  EmailSiginForm({ required this.auth});
  final AuthBase auth;

  @override
  _EmailSiginFormState createState() => _EmailSiginFormState();
}

class _EmailSiginFormState extends State<EmailSiginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _submitted = false;
  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  emailSignInformType _formType = emailSignInformType.sigIn;

  void _submit() async {
    setState(() {
      _submitted = true;
    });
    try {
      if (_formType == emailSignInformType.sigIn) {
        await widget.auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await widget.auth.createAccountWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error de inicio de sesión'),
              content: Text(e.toString()),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Entendido',
                      style: TextStyle(color: Colors.indigo),
                    ))
              ],
            );
          });
    }
  }

  void _toogleFormType() {
    setState(() {
      _submitted = false;
      _formType = _formType == emailSignInformType.sigIn
          ? emailSignInformType.register
          : emailSignInformType.sigIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  List<Widget> _buildChildren() {
    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password);
    final primaryText = _formType == emailSignInformType.sigIn
        ? 'Iniciar sesión'
        : 'Crear cuenta';

    final secondaryText = _formType == emailSignInformType.register
        ? '¿Ya tienes una cuenta? Inicia sesión'
        : '¿No tienes una cuenta? Registrate';
    return [
      _buildEmailTextField(),
      SizedBox(
        height: 8,
      ),
      _buildPasswordTectField(),
      SizedBox(
        height: 8,
      ),
      FormSubmitButton(
        onPressed: submitEnabled ? _submit : null,
        text: primaryText,
      ),
      SizedBox(
        height: 8,
      ),
      TextButton(onPressed: _toogleFormType, child: Text(secondaryText))
    ];
  }

  Widget _buildEmailTextField() {
    bool emailValid = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
          labelText: 'Tu correo',
          hintText: 'correo@ejemplo.com',
          errorText: emailValid ? widget.invalidEmailErrorText : null),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: _emailEditingComplete,
    );
  }

  Widget _buildPasswordTectField() {
    bool passwordValid =
        _submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
          labelText: 'Contraseña',
          errorText: passwordValid ? widget.invalidPasswordErrorText : null),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }
}
