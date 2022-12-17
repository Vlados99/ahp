import 'package:analyzer_plugin/utilities/pair.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class CustomSlider extends StatefulWidget {
  double? value;
  Pair? pair;
  String firstCriteria;
  String secondCriteria;

  CustomSlider({
    Key? key,
    this.value,
    this.pair,
    required this.firstCriteria,
    required this.secondCriteria,
  }) : super(key: key);

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  double value = 0.0;
  double min = 0;
  double max = 180;
  String firstCriteria = "";
  String secondCriteria = "";
  String groupValue = "";

  @override
  void initState() {
    value = widget.value ?? min;
    firstCriteria = widget.firstCriteria;
    secondCriteria = widget.secondCriteria;
    groupValue = firstCriteria;

    widget.pair = Pair(firstCriteria, secondCriteria);
    widget.firstCriteria = firstCriteria;
    widget.secondCriteria = secondCriteria;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                firstCriteria,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                secondCriteria,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Radio(
        //         value: firstCriteria,
        //         groupValue: groupValue,
        //         onChanged: (String? value) {
        //           setState(() {
        //             groupValue = value!;
        //             widget.pair = Pair(firstCriteria, secondCriteria);
        //           });
        //         }),
        //     Radio(
        //         value: secondCriteria,
        //         groupValue: groupValue,
        //         onChanged: (String? value) {
        //           setState(() {
        //             groupValue = value!;
        //             widget.pair = Pair(secondCriteria, firstCriteria);
        //           });
        //         }),
        //   ],
        // ),
        SfSlider(
          interval: 1,
          stepSize: min,
          value: value,
          onChanged: (currentValue) {
            setState(() {
              widget.value = currentValue;
              value = currentValue;
            });
          },
          min: min,
          max: max,
        ),
        const Divider(
          color: Colors.grey,
          thickness: 2,
        ),
      ],
    );
  }
}
