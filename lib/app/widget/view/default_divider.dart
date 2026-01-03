import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deepple_app/core/extension/extended_context.dart';

class DefaultDivider extends ConsumerWidget {
  const DefaultDivider({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Divider(height: 1, color: color ?? context.palette.shadow);
  }
}

class DefaultVerticalDivider extends ConsumerWidget {
  const DefaultVerticalDivider({super.key, this.color, this.size});

  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: size,
      child: VerticalDivider(width: 1, color: color ?? context.palette.shadow),
    );
  }
}
