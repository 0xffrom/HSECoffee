
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFieldWrapper extends StatelessWidget {
  final int minLengthName;
  final int maxLengthName;
  final TextInputType textInputType;
  final String hintText;
  final String labelText;
  final String iconPath;
  final int maxLines;
  final bool ignoreValidate;
  final TextEditingController controller;

  TextFieldWrapper(
      {Key key,
        this.hintText,
        this.labelText,
        this.controller,
        this.minLengthName: 2,
        this.maxLengthName: 15,
        this.textInputType: TextInputType.name,
        this.maxLines: 1,
        this.iconPath, this.ignoreValidate: false})
      : super(key: key);

  bool _isValidName(String text) {
    return text != null &&
        text.length > minLengthName &&
        text.length < maxLengthName;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      keyboardType: textInputType,
      controller: this.controller,
      validator: (input) => ignoreValidate ? null :
      _isValidName(input) ? null : "Пожалуйста, заполните корректно поле!",
      cursorColor: Colors.blue,
      decoration: InputDecoration(
        prefixIcon:
        iconPath != null ? Image.asset(iconPath, scale: 2.25) : null,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(
            width: 2,
            color: Colors.blue,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(
            width: 2,
            color: Colors.red,
          ),
        ),
        labelText: labelText,
      ),
    );
  }
}