import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

Widget dragAndDropSquare(
  VoidCallback onClick,
  ColorScheme colorScheme,
  String aboveText,
  String belowText,
  IconData icon,
) {
  return GestureDetector(
    onTap: onClick,
    child: DottedBorder(
      color: colorScheme.tertiary,
      dashPattern: const [15, 6],
      strokeWidth: 3,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          height: 350,
          width: 350,
          color: colorScheme.tertiaryContainer,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                aboveText,
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              Icon(icon, size: 100),
              Text(
                belowText,
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
