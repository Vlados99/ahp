import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController numberOfCriteriaController;
  final TextInputFormatter formatter;
  final String hintText;
  final TextInputType textInputType;

  const CustomTextField({
    Key? key,
    required this.numberOfCriteriaController,
    required this.hintText,
    required this.formatter,
    required this.textInputType,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String hintText = "";
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    hintText = widget.hintText;
    controller = widget.numberOfCriteriaController;

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: widget.textInputType,
      inputFormatters: [widget.formatter],
      decoration: InputDecoration(hintText: hintText),
    );
  }
}
