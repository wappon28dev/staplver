import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DragAndDropSquare extends ConsumerWidget {
  const DragAndDropSquare({
    required this.onClick,
    required this.onDragDone,
    required this.colorScheme,
    required this.aboveText,
    required this.belowText,
    required this.icon,
    super.key,
  });

  final VoidCallback onClick;
  final void Function(List<XFile> files) onDragDone;
  final ColorScheme colorScheme;
  final String aboveText;
  final String belowText;
  final IconData icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onClick,
      child: DropTarget(
        onDragDone: (details) => onDragDone(details.files),
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
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Icon(icon, size: 100),
                  Text(
                    belowText,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
