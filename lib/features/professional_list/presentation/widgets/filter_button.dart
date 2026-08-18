import 'package:ajudafio_mobile/core/theme/app_pallet.dart';
import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Implement your filter logic here
      },
      style: ElevatedButton.styleFrom(
        fixedSize: Size(44, 55),
        backgroundColor: AppPallet.primaryColor,
        shadowColor: AppPallet.transparentColor,
      ),
      child: const Icon(Icons.filter_list),
    );
  }
}
