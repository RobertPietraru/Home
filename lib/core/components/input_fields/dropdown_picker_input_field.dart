import 'package:flutter/material.dart';
import 'package:homeapp/core/components/theme/app_theme.dart';

class DropdownPickerInputField<T> extends StatefulWidget {
  final List<T> options;
  final Function(T?) onChanged;
  final Widget Function(T option) getChild;
  final String hint;
  final String? error;
  final IconData? leadingIcon;
  final Color? backgroundColor;
  final T? initialValue;
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
    required this.getChild,
  }) : super(key: key);

  @override
  State<DropdownPickerInputField<T>> createState() =>
      _DropdownPickerInputFieldState<T>();
}

class _DropdownPickerInputFieldState<T>
    extends State<DropdownPickerInputField<T>> {
  T? selectedValue;
  @override
  void initState() {
    if (widget.options.contains(widget.initialValue)) {
      selectedValue = widget.initialValue;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return DropdownButtonFormField<T>(
      value: selectedValue,
      onChanged: (T? newValue) {
        setState(() {
          selectedValue = newValue;
        });
        widget.onChanged(newValue);
      },
      items: widget.options.map((T option) {
        return DropdownMenuItem<T>(
          value: option,
          child: widget.getChild(option),
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
