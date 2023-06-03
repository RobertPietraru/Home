import 'package:flutter/material.dart';
import 'package:homeapp/core/components/theme/app_theme.dart';

class DropdownPickerInputField extends StatefulWidget {
  final List<String> options;
  final Function(String) onChanged;
  final String hint;
  final String? error;
  final IconData? leadingIcon;
  final Color? backgroundColor;
  final String? initialValue;
  final TextInputType? keyboardType;

  const DropdownPickerInputField({
    Key? key,
    required this.options,
    required this.onChanged,
    required this.hint,
    this.error,
    this.leadingIcon,
    this.backgroundColor,
    this.initialValue,
    this.keyboardType,
  }) : super(key: key);

  @override
  State<DropdownPickerInputField> createState() =>
      _DropdownPickerInputFieldState();
}

class _DropdownPickerInputFieldState extends State<DropdownPickerInputField> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return DropdownButtonFormField<String>(
      value: selectedValue,
      onChanged: (String? newValue) {
        setState(() {
          selectedValue = newValue;
        });
        widget.onChanged(newValue!);
      },
      items: widget.options.map((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      decoration: InputDecoration(
        fillColor:
            widget.backgroundColor ?? const Color.fromARGB(255, 212, 212, 212),
        filled: true,
        hintText: widget.hint,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none),
        prefixIcon:
            widget.leadingIcon == null ? null : Icon(widget.leadingIcon),
        errorStyle: TextStyle(fontSize: theme.spacing.mediumLarge),
        errorText: widget.error,
      ),
    );
  }
}
