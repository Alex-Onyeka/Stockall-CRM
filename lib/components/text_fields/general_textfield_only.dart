import 'package:flutter/material.dart';
import 'package:stockallcrm/main.dart';
import 'package:stockallcrm/providers/theme_provider.dart';

class GeneralTextfieldOnly extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final int lines;
  final ThemeProvider theme;
  final GlobalKey<FormState>? formState;
  final String? initialValue;
  final String? Function(String?)? validatorAction;
  const GeneralTextfieldOnly({
    super.key,
    required this.hint,
    required this.controller,
    required this.lines,
    required this.theme,
    this.onChanged,
    this.formState,
    this.initialValue,
    this.validatorAction,
  });

  @override
  State<GeneralTextfieldOnly> createState() =>
      _GeneralTextfieldOnlyState();
}

class _GeneralTextfieldOnlyState
    extends State<GeneralTextfieldOnly> {
  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          widget.controller.text = widget.initialValue!;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = returnThemeProvider();
    return Form(
      key: widget.formState,
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        minLines: widget.lines,
        maxLines: 6,
        validator: widget.validatorAction,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: theme.mobileTexts.b1.fontSize,
        ),
        onChanged: widget.onChanged,
        textCapitalization: TextCapitalization.sentences,
        autocorrect: true,
        enableSuggestions: true,
        decoration: InputDecoration(
          isCollapsed: true,
          labelText: widget.hint,
          labelStyle: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.grey.shade600,
            fontSize: theme.mobileTexts.b1.fontSize,
          ),
          floatingLabelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: theme.lightModeColor.prColor300,
            fontSize: theme.mobileTexts.b1.fontSize,
            letterSpacing: 0.5,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: theme.lightModeColor.prColor300,
              width: 1.3,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        controller: widget.controller,
      ),
    );
  }
}
