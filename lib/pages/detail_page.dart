import 'package:ahp/widgets/button.dart';
import 'package:ahp/widgets/slider.dart';
import 'package:analyzer_plugin/utilities/pair.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final List<String> criteries;
  final int count;
  const DetailPage({
    Key? key,
    required this.criteries,
    required this.count,
  }) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<String> criteries = [];
  List<double> values = [];

  @override
  void initState() {
    criteries = widget.criteries;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail")),
      body: body(),
    );
  }

  Widget body() {
    final pairs = getPairs(criteries);
    final sliders = getSliders(pairs);

    return SingleChildScrollView(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
            child: Text(
              "Choose an option and indicate its priority",
              style: TextStyle(fontSize: 20),
            ),
          ),
          for (Widget slider in sliders) slider,
          CustomButton(
              text: "Result",
              onTap: () {
                final pairsWithValue = pairsWithPrioritets(
                    sliders
                        .map((e) =>
                            e.pair ?? Pair(e.firstCriteria, e.secondCriteria))
                        .toList(),
                    sliders.map((e) {
                      return (e.value ?? 1).toDouble();
                    }).toList());

                Navigator.pushNamed(context, "/result",
                    arguments: Pair(pairsWithValue, widget.count));
              }),
        ],
      ),
    );
  }

  List<Pair<Pair, double>> pairsWithPrioritets(
      List<Pair> pairs, List<double> values) {
    return List.generate(
        pairs.length, (index) => Pair(pairs[index], values[index]));
  }

  List<CustomSlider> getSliders(List<Pair> pairs) {
    return pairs
        .map((e) => CustomSlider(
              firstCriteria: e.first,
              secondCriteria: e.last,
            ))
        .toList();
  }

  List<Pair> getPairs(List<String> criteries) {
    List<Pair> pairs = [];
    for (var first in criteries) {
      for (var second in criteries) {
        if (first != second &&
            (!pairs.contains(Pair(first, second)) &&
                !pairs.contains(Pair(second, first)))) {
          pairs.add(Pair(first, second));
        }
      }
    }
    return pairs;
  }
}
