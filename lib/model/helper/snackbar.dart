import 'package:flutter/material.dart';

class SnackBarController {
  SnackBarController(this.context);

  final BuildContext context;

  void pushSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(content)),
    );
  }
}
