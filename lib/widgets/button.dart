import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final Function() onTap;
  final String text;
  const CustomButton({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.purple,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        width: 80,
        height: 40,
        alignment: Alignment.center,
        child: Text(widget.text),
      ),
    );
  }
}
