import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final title;
  final onPress;
  RoundedButton({this.title, this.onPress});
  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.red,
        borderRadius: BorderRadius.circular(30),
        child: MaterialButton(
          height: 40,
          child:
              Text(title, style: TextStyle(color: Colors.white, fontSize: 18)),
          onPressed: onPress,
        ));
  }
}
