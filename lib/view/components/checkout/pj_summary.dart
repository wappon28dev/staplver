import 'package:aibas/view/routes/fab/checkout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompPjSummary extends ConsumerWidget {
  const CompPjSummary({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CompCheckoutHelper().wrap(
      context: context,
      ref: ref,
      isValidContents: true,
      mainContents: const SizedBox(),
    );
  }
}
