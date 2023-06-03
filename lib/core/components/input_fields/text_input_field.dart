import 'package:flutter/material.dart';
import 'package:homeapp/core/components/theme/app_theme.dart';

class TextInputField extends StatefulWidget {
  final Function(String) onChanged;
  final String hint;
  final String? error;
  final IconData? leading;
  final bool isPassword;
  final int maxLines;
  final bool showLabel;
  final Color? backgroundColor;
  final String? initialValue;
  final TextInputType? keyboardType;
  const TextInputField({
    Key? key,
    required this.onChanged,
    required this.hint,
    this.maxLines = 1,
    this.error,
    this.leading,
    this.isPassword = false,
    this.showLabel = true,
    this.backgroundColor,
    this.initialValue,
    this.keyboardType,
  }) : super(key: key);

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  final TextEditingController controller = TextEditingController();
  bool isObscured = true;
  @override
  void initState() {
    controller.text = widget.initialValue ?? '';
    isObscured = widget.isPassword;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    //#3a3a3a
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showLabel)
          Column(
            children: [
              Text(widget.hint,
                  style: theme.informationTextStyle
                      .copyWith(color: theme.primaryColor)),
              const SizedBox(height: 5),
            ],
          ),
        TextFormField(
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            obscureText: isObscured,
            style: TextStyle(color: theme.primaryColor),
            decoration: InputDecoration(
              fillColor: widget.backgroundColor ??
                  const Color.fromARGB(255, 212, 212, 212),
              filled: true,
              hintText: widget.hint,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none),
              prefixIcon: widget.leading == null ? null : Icon(widget.leading),
              errorStyle: TextStyle(fontSize: theme.spacing.mediumLarge),
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                          isObscured ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => isObscured = !isObscured),
                    )
                  : null,
              errorText: widget.error,
            ),
            controller: controller,
            onChanged: widget.onChanged),
      ],
    );
  }
}
