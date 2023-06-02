import 'package:flutter/material.dart';

class CheckboxInputField extends StatelessWidget {
  const CheckboxInputField({
    Key? key,
    required this.value,
    required this.title,
    required this.onChanged,
  }) : super(key: key);

  final bool value;
  final String title;
  final Null Function(dynamic e) onChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
        title: Text(title),
        value: value,
        onChanged: onChanged);
  }
}
