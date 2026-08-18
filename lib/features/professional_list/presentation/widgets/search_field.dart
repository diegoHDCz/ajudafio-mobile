import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SearchField extends StatelessWidget {
  const SearchField({Key? key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'Buscar profissional....',
        filled: true,
        fillColor: Colors.grey.shade300,
        border: OutlineInputBorder(),
      ),
    );
  }
}
