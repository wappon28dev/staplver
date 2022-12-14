import 'package:aibas/model/state.dart';
import 'package:aibas/view/components/navbar.dart';
import 'package:aibas/vm/contents.dart';
import 'package:aibas/vm/now.dart';
import 'package:aibas/vm/theme.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PageHome extends ConsumerWidget {
  const PageHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.of(context).orientation;
    final navbar = NavBar(ref: ref, orientation: orientation);

    final nowState = ref.watch(nowProvider);
    final dateStr =
        DateFormat.yMMMMEEEEd('ja').format(nowState.value ?? DateTime.now());
    final timeStr = DateFormat.Hms().format(nowState.value ?? DateTime.now());

    final titleWidget = Padding(
      padding: const EdgeInsets.only(left: 20),
      child: AutoSizeText.rich(
        TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: <TextSpan>[
            TextSpan(
              text: 'AIBAS',
              style: GoogleFonts.mPlus1(
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.primary,
                fontSize: 40,
              ),
            ),
            TextSpan(
              text: ' へようこそ',
              style: GoogleFonts.mPlus1(
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ],
        ),
        minFontSize: 20,
        maxLines: 1,
      ),
    );

    final clockWidget = Padding(
      padding: const EdgeInsets.only(right: 20),
      child: AutoSizeText.rich(
        TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: <TextSpan>[
            TextSpan(
              text: dateStr,
              style: const TextStyle(
                fontSize: 10,
              ),
            ),
            TextSpan(
              text: '\n$timeStr',
              style: GoogleFonts.mPlus1(
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.right,
        minFontSize: 20,
        maxLines: 2,
      ),
    );

    return navbar.getRailsNavbar(
      Column(
        children: <Widget>[
          SizedBox(
            height: 100,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: titleWidget,
                ),
                Expanded(
                  child: clockWidget,
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 2,
          ),
          const Text('data'),
        ],
      ),
    );
  }
}
