import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:interval/core/common/app/current_theme_mode.dart';
import 'package:interval/core/extensions/context_extensions.dart';

class InputField extends StatefulWidget {
  const InputField({
    required this.controller,
    this.obscureText = false,
    this.defaultValidation = true,
    this.enabled = true,
    this.readOnly = false,
    this.expandable = false,
    super.key,
    this.suffixIcon,
    this.hintText,
    this.labelText,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.prefix,
    this.contentPadding,
    this.prefixIcon,
    this.focusNode,
    this.onTap,
    this.suffixIconConstraints,
  });

  final Widget? suffixIcon;
  final String? hintText;
  final String? Function(String? value)? validator;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool defaultValidation;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefix;
  final bool enabled;
  final bool readOnly;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final bool expandable;
  final BoxConstraints? suffixIconConstraints;
  final String? labelText;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CurrentThemeMode.instance,
      builder: (_, themeMode, __) {
        final isDark = themeMode == ThemeMode.dark ||
            (themeMode == ThemeMode.system && context.isDarkMode);
        return TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          focusNode: _focusNode,
          obscureText: widget.obscureText,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          maxLines: widget.expandable ? 5 : 1,
          minLines: widget.expandable ? 1 : null,
          onTap: widget.onTap,
          onTapOutside: (_) {
            _focusNode.unfocus();
          },
          decoration: InputDecoration(
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: isDark ? Colors.white : context.theme.primaryColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: context.theme.primaryColorLight),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red),
            ),
            hintText: widget.hintText,
            labelText: widget.labelText,
            suffixIcon: widget.suffixIcon,
            suffixIconConstraints: widget.suffixIconConstraints,
            prefix: widget.prefix,
            prefixIcon: widget.prefixIcon,
            contentPadding: widget.contentPadding ??
                const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
            filled: true,
            fillColor:
                isDark ? const Color(0xff2e2e2e) : const Color(0xffe4e4e9),
          ),
          inputFormatters: widget.inputFormatters,
          validator: widget.defaultValidation
              ? (value) {
                  if (value == null || value.isEmpty) return 'Required Field';
                  return widget.validator?.call(value);
                }
              : widget.validator,
        );
      },
    );
  }
}
