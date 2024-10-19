import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../styles/app_colors.dart';

class AppTextFormField extends StatefulWidget {
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? inputTextStyle;
  final TextStyle? hintStyle;
  final String hintText;
  final bool? isObscureText;
  final Widget? suffixIcon;
  final Color? backgroundColor;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final String? initialValue;
  final int? maxLength;
  final int? minLines;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final bool? withTitle;
  final String? title;
  final bool? isFilled;
  final BorderRadius? borderRadius;
  final bool? enable;
  // late FocusNode? focusNode;
  final Color? borderColor;
   const AppTextFormField({
    super.key,
    this.contentPadding,
    this.focusedBorder,
    this.enabledBorder,
    this.inputTextStyle,
    this.hintStyle,
    required this.hintText,
    this.isObscureText,
    this.suffixIcon,
    this.backgroundColor,
    this.controller,
    this.validator,
    this.onChanged,
    this.withTitle,
    this.initialValue,
    this.title,
    this.minLines = 1,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.borderRadius,
    this.isFilled,
    this.enable,
    // this.focusNode,
    this.borderColor,
  });

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // focusNode: widget.focusNode,
      enabled: widget.enable ?? true,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      controller: widget.controller,
      initialValue: widget.initialValue,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(20.0.r),
        ),
        isDense: true,
        labelText: widget.withTitle == true ? widget.title : null,
        labelStyle: const TextStyle(
          color: AppColors.primary,
        ),
        contentPadding: widget.contentPadding ??
            EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        focusedBorder: widget.focusedBorder ??
            OutlineInputBorder(
              borderSide:  BorderSide(
                color: widget.borderColor??AppColors.primary,
                width: 1.3,
              ),
              borderRadius: widget.borderRadius ?? BorderRadius.circular(20.0.r),
            ),
        enabledBorder: widget.enabledBorder ??
            OutlineInputBorder(
              borderSide:  BorderSide(
                color: widget.borderColor??AppColors.primary,
                width: 1.3,
              ),
              borderRadius: widget.borderRadius ?? BorderRadius.circular(20.0.r),
            ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.3,
          ),
          borderRadius: widget.borderRadius ?? BorderRadius.circular(20.0.r),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.3,
          ),
          borderRadius: widget.borderRadius ?? BorderRadius.circular(20.0.r),
        ),
        hintStyle: widget.hintStyle ?? const TextStyle(
          color: AppColors.primary,
        ),
        hintText: widget.hintText,
        suffixIcon: widget.suffixIcon,
        fillColor: widget.backgroundColor ?? Colors.transparent,
        filled: widget.isFilled ?? false,
      ),
      obscureText: widget.isObscureText ?? false,
      style: const TextStyle(
        color: AppColors.primary,
      ),
      onChanged: widget.onChanged,
      validator: widget.validator,
    );
  }
}
