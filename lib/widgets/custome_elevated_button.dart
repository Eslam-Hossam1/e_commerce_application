import 'package:flutter/material.dart';

class CustomeElevatedButton extends StatelessWidget {
  const CustomeElevatedButton({
    super.key,
    this.onPressed,
    required this.text,
    this.hight,
    this.width,
    this.color,
  });
  final void Function()? onPressed;
  final String text;
  final double? hight;
  final double? width;
  final Color? color;
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
          backgroundColor: WidgetStatePropertyAll(color ?? Colors.blue),
          minimumSize: WidgetStatePropertyAll(
              Size(width ?? MediaQuery.of(context).size.width, hight ?? 50))),
    );
  }
}
