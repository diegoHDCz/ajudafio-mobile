import 'package:flutter/material.dart';

/// Paleta de cores extraída da logo "Ajuda Fio".
class AppPallet {
  AppPallet._();

  // Azul (faixa "Ajuda")
  static const Color primaryColor = Color(0xFF0460C5);
  static const Color primaryColorLight = Color(0xFF097EDA);
  static const Color primaryColorDark = Color(0xFF0145AE);

  // Verde (texto/folha "Fio")
  static const Color secondaryColor = Color.fromARGB(255, 27, 138, 60);
  static const Color secondaryColorLight = Color(0xFF4AAF29);
  static const Color secondaryColorDark = Color(0xFF1C6C17);

  // Vermelho (coração com cruz de saúde)
  static const Color accentColor = Color(0xFFE5100F);

  // Neutros
  static const Color backgroundColor = Color(0xFFEDF1F3);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color textColor = Color(0xFF1A1D1F);
  static const Color textColorSecondary = Color(0xFF6B7280);
  static const Color transparentColor = Colors.transparent;
}
