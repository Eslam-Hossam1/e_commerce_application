import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgElevatedButton extends StatelessWidget {
  const SvgElevatedButton({
    super.key,
    this.onPressed,
    required this.svgImagePath,
    this.color,
  });
  final void Function()? onPressed;
  final String svgImagePath;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
          child: SvgPicture.asset(svgImagePath,
              height: 30,
              width: 30,
              colorFilter: color == null
                  ? null
                  : ColorFilter.mode(
                      Colors.blue, // Change the color of the SVG image
                      BlendMode.srcIn,
                    )),
        ));
  }
}
