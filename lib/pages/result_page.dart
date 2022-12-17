import 'dart:math';

import 'package:analyzer_plugin/utilities/pair.dart';
import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

class ResultPage extends StatefulWidget {
  final List<Pair<Pair, double>> data;
  final int count;
  const ResultPage({
    Key? key,
    required this.data,
    required this.count,
  }) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List<Pair<Pair, double>> data = [];
  int count = 0;

  @override
  void initState() {
    data = widget.data;
    count = widget.count;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Result")),
      body: body(),
    );
  }

  Widget body() {
    final result = pairsWithValuesExample();
    final matrix = createMatrixOfCor(length: count);
    final vectorEigenValues = matrix.eigenvalue.realEigenvalues;
    final principalEigenValue = maxEigenValue(vectorEigenValues);
    final indexPrincipalEigenValue = indexMaxEigenValue(vectorEigenValues);
    final vectorOfSum = vectorOfSumColumn(matrix);
    final normWeightMatrix = normalizedWeightMatrix(matrix);

    return Column(
      children: [
        // const Text("Sliders value"),
        // Row(
        //   children: [
        //     Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: result,
        //     ),
        //   ],
        // ),
        matrixWidget(
            title: "Decision Matrix", matrix: matrixToListList(matrix)),

        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(
              "Principal eigen value = ${principalEigenValue.toStringAsFixed(3)}"),
        ),
        const Text("Priorities"),
        showVector(normalizedMatrix(normWeightMatrix)),
      ],
    );
  }

  List<Map<String, dynamic>> namesOfCriteria(List<Pair> pair) {
    List<Map<String, dynamic>> list = [
      {"name": pair.first.first}
    ];
    return list;
  }

  Widget showVector(List<double> list) {
    return Row(
      children: list
          .map((e) => Padding(
                padding: const EdgeInsets.all(8),
                child: Text(e.toStringAsFixed(2)),
              ))
          .toList(),
    );
  }

  Matrix<double> createMatrixOfCor({required int length}) {
    Matrix<double> mtx = Matrix(DataType.float64, count, count);

    var values = data.map((e) => getPriorityValue(e.last)).toList();

    for (int i = 0; i < count; i++) {
      for (int j = 0; j < count; j++) {
        if (i == j) {
          mtx[i][j] = 1;
          for (int k = 1 + j; k < count; k++) {
            var value = values.first.toDouble();
            values.removeAt(0);
            mtx[i][k] = value;
            mtx[k][j] = (1 / value);
          }
        }
      }
    }

    return mtx;
  }

  List<List<double>> matrixToListList(Matrix matrix) {
    return List<List<double>>.generate(count, (i) {
      return List<double>.generate(count, (j) {
        return matrix[i][j];
      });
    });
  }

  Widget matrixWidget(
      {required String title, required List<List<double>> matrix}) {
    var displayedMatrix = Column(
      children: matrix
          .map((e) => Row(
              children: e
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(e.toStringAsFixed(2)),
                    ),
                  )
                  .toList()))
          .toList(),
    );
    return Column(
      children: [
        Text(title),
        displayedMatrix,
      ],
    );
  }

  List<Widget> pairsWithValuesExample() {
    return data.map((e) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
            "${e.first.first} -> ${e.first.last} --- ${e.last.toStringAsFixed(3)} === ${getPriorityValue(e.last)}"),
      );
    }).toList();
  }

  List<double> normalizedMatrix(Matrix<double> matrix) {
    return List<double>.generate(count, (index) {
      return ((matrix.row(index).sum) / count) * 100;
    });
  }

  Matrix<double> normalizedWeightMatrix(Matrix<double> matrix) {
    final vector = vectorOfSumColumn(matrix);
    List<List<double>> res = [];

    for (var row in matrix.rows) {
      res.add(row.map((index, value) => value / vector[index]).toList());
    }

    return Matrix.fromRows(DataType.float64, res);
  }

  List<double> vectorOfSumColumn(Matrix<double> matrix) {
    return List<double>.generate(matrix.columnCount,
        (index) => sumColumn(matrix.column(index).toList()));
  }

  double sumColumn(List<double> column) {
    return column.sum();
  }

  List<double> getEigenVector(Matrix<double> matrix, int indexMaxEigenValue) {
    return matrix.column(indexMaxEigenValue).toList();
  }

  double maxEigenValue(List<double> list) {
    return list.reduce(max);
  }

  int indexMaxEigenValue(List<double> list) {
    return list.indexWhere((element) => element == maxEigenValue(list));
  }

  double getPriorityValue(double sliderValue) {
    List<double> values = [9, 7, 5, 3, 1, 1 / 3, 1 / 5, 1 / 7, 1 / 9];

    for (int i = 9; i > 0; i--) {
      int end = i * 20, start = end - 20;
      if (sliderValue > start && sliderValue <= end) {
        return values[i - 1];
      }
    }

    return 9;
  }
}
