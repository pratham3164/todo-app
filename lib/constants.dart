import 'package:flutter/material.dart';

final kInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
  hintStyle: TextStyle(color: Colors.white60),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 1),
      borderRadius: BorderRadius.circular(32)),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 2),
      borderRadius: BorderRadius.circular(32)),
);
