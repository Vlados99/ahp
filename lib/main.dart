import 'package:ahp/pages/main_page.dart';
import 'package:ahp/pages/detail_page.dart';
import 'package:ahp/pages/result_page.dart';
import 'package:analyzer_plugin/utilities/pair.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const MainPage(),
        '/detail': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Pair<List<String>, int>;
          return DetailPage(
            criteries: args.first,
            count: args.last,
          );
        },
        '/result': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Pair<List<Pair<Pair, double>>, int>;
          return ResultPage(
            data: args.first,
            count: args.last,
          );
        },
      },
      debugShowCheckedModeBanner: false,
      title: 'AHP Calculator',
      theme: ThemeData.dark(),
    );
  }
}
