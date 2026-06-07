import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/size_config.dart';

class InputTextField extends StatefulWidget {
  final String? Function(String?)? validation;
  final Function()? onEditComplete;
  final TextEditingController? textEditingController;
  final String hint;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final bool enable;
  final String title;
  final String? initialValue;
  final bool obsecureText;
  final TextAlign textAlign;
  final TextInputAction textInputAction;
  final Function(String val)? onChange;
  final double? width;
  final double? height;
  final Widget? prefixIcon;
  final int? maxLines;
  const InputTextField(
      {Key? key,
      this.width,
      this.height,
      this.prefixIcon,
      this.validation,
      this.textEditingController,
      this.hint = "",
      this.onChange,
      this.textInputType,
      required this.title,
      this.inputFormatters,
      this.enable = true,
      this.initialValue,
      this.obsecureText = false,
      this.textAlign = TextAlign.left,
      this.onEditComplete,
      this.textInputAction = TextInputAction.next,
      this.maxLines})
      : super(key: key);

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  bool _isVisible = false;

  @override
  void initState() {
    _isVisible = widget.obsecureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Theme(
        data: Theme.of(context).copyWith(
          inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
            iconColor: WidgetStateColor.resolveWith((Set<WidgetState> states) {
              if (states.contains(WidgetState.focused)) {
                return kSecondaryColor;
              }
              if (states.contains(WidgetState.error)) {
                return kErrorColor;
              }
              return Colors.grey;
            }),
          ),
        ),
        child: TextFormField(
          style: TextStyle(fontSize: getProportionateScreenWidth(14)),
          maxLines: widget.maxLines != null && widget.maxLines! > 1
              ? widget.maxLines
              : 1,
          cursorColor: kSecondaryColor,
          textDirection: TextDirection.ltr,
          controller: widget.textEditingController,
          initialValue: widget.initialValue,
          validator: widget.validation ??
              (val) {
                return null;
              },
          keyboardType: widget.textInputType,
          inputFormatters: widget.inputFormatters,
          textInputAction: widget.textInputAction,
          enabled: widget.enable,
          onChanged: (val) {
            if (widget.onChange != null) {
              widget.onChange!(val);
            }
          },
          onEditingComplete: widget.onEditComplete,
          obscureText: _isVisible,
          textAlign: widget.textAlign,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            prefixIconColor: WidgetStateColor.resolveWith(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.focused)) {
                  return kPrimaryColor; // Cor quando focado
                }
                return Colors.grey; // Cor padrão
              },
            ),
            errorStyle: const TextStyle(height: 1),
            isDense: true,
            contentPadding: widget.prefixIcon != null
                ? const EdgeInsets.only(bottom: 0.0, top: 0.0)
                : const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            border: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: kPrimaryColor),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: kErrorColor),
              borderRadius: BorderRadius.circular(8),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: kErrorColor),
              borderRadius: BorderRadius.circular(8),
            ),
            filled: false,
            hintText: widget.title,
            hintStyle: TextStyle(fontSize: getProportionateScreenWidth(14)),
            labelStyle: TextStyle(fontSize: getProportionateScreenWidth(14)),
            prefixIcon: widget.prefixIcon ?? widget.prefixIcon,
            suffixIcon: widget.obsecureText
                ? GestureDetector(
                    child: _isVisible
                        ? const Icon(
                            Icons.visibility_off,
                            size: 20,
                            color: Colors.grey,
                          )
                        : const Icon(
                            Icons.visibility,
                            size: 20,
                            color: Colors.grey,
                          ),
                    onTap: () => setState(() {
                      _isVisible = !_isVisible;
                    }),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
