import 'package:flutter/material.dart';

class CustomeElevatedButton extends StatelessWidget {
  const CustomeElevatedButton({
    super.key,
    this.onPressed,
    required this.text,
  });
  final void Function()? onPressed;
  final String text;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.blue),
          minimumSize: WidgetStatePropertyAll(
              Size(MediaQuery.of(context).size.width, 50))),
    );
  }
}
