import 'package:ajudafio_mobile/core/theme/app_pallet.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loader extends StatelessWidget {
  const Loader({super.key, this.size = 55, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      child: Container(
        color: Colors.black.withValues(alpha: 0.6),
        alignment: Alignment.center,
        child: LoadingAnimationWidget.waveDots(
          color: color ?? AppPallet.primaryColorLight,
          size: size,
        ),
      ),
    );
  }
}
