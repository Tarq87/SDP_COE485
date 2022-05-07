import 'package:flutter/material.dart';

// For the old login and sinup screens
// Repeated code for TextField
const kTextFiledInputDecoration = InputDecoration(
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.black),
  ),
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 2),
  ),
  labelText: " Email address",
  labelStyle:
      TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400),
);
