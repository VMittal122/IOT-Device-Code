import 'package:flutter/material.dart';

moveTo(BuildContext context, Widget page) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => page,
    ), // Ensure this matches your actual class name
  );
}

moveReplace(BuildContext context, Widget page) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => page,
    ), // Ensure this matches your actual class name
  );
}
