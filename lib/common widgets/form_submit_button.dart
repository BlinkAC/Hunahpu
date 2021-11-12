import 'package:cursoflutter/common%20widgets/custom_elevated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormSubmitButton extends CustomElevatedButton {
  FormSubmitButton({
    @required String? text,
    @required VoidCallback? onPressed,
  }) : super(
            child: Text(
              text!,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            color: Colors.green,
            radius: 1,
            onPressed: onPressed);
}
