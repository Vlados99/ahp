import 'package:ahp/common/snackbar.dart';
import 'package:ahp/widgets/button.dart';
import 'package:ahp/widgets/text_field.dart';
import 'package:analyzer_plugin/utilities/pair.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  double sliderValue = 0;
  int count = 0;

  List<TextEditingController> controllers = [];
  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    for (var element in controllers) {
      element.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AHP Calculator"),
      ),
      body: body(),
    );
  }

  Widget body() {
    return SingleChildScrollView(
        child: Column(
      children: [
        CustomTextField(
            textInputType: TextInputType.number,
            formatter: FilteringTextInputFormatter.digitsOnly,
            numberOfCriteriaController: controller,
            hintText: "Enter number (2-10)"),
        Padding(
            padding: const EdgeInsets.all(8),
            child: CustomButton(
              text: "Enter",
              onTap: () {
                if (controller.text.isEmpty) {
                  showSnakBarError(context: context, message: "Field is empty");
                  return;
                }
                if (int.parse(controller.text) < 2) {
                  showSnakBarError(
                      context: context,
                      message: "The number cannot be lower than 2");
                  return;
                }

                showAlertDialog();
              },
            )),
      ],
    ));
  }

  Future<dynamic> showAlertDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Name of criteria"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: textFieldsForCriteriaNames(),
            ),
            actions: [
              CustomButton(
                  text: "Cancel",
                  onTap: () {
                    Navigator.pop(context);
                  }),
              CustomButton(
                  text: "Next",
                  onTap: () {
                    final listOfNames = List<String>.generate(
                        count, (index) => controllers[index].text);
                    controllersIsEmpty(controllers)
                        ? showSnakBarError(
                            context: context,
                            message: "One or more fields are empty")
                        : !controllersIsDifferent(controllers)
                            ? showSnakBarError(
                                context: context,
                                message: "Values are not different")
                            : Navigator.pushNamed(context, "/detail",
                                arguments: Pair(listOfNames, count));
                  }),
            ],
          );
        });
  }

  bool controllersIsDifferent(List<TextEditingController> controllers) {
    final criteriaNames = List<String>.generate(
        controllers.length, (index) => controllers[index].text);
    for (var name in criteriaNames) {
      int count = criteriaNames.where((element) => element == name).length;
      if (count > 1) {
        return false;
      }
    }

    return true;
  }

  bool controllersIsEmpty(List<TextEditingController> controllers) {
    for (var controller in controllers) {
      if (controllerIsEmpty(controller)) {
        return true;
      }
    }

    return false;
  }

  bool controllerIsEmpty(TextEditingController controller) {
    return controller.text.isEmpty;
  }

  List<CustomTextField> textFieldsForCriteriaNames() {
    count = int.parse(controller.text);

    controllers = List.generate(count, (index) => TextEditingController());

    return List.generate(
        count,
        (index) => CustomTextField(
            numberOfCriteriaController: controllers[index],
            hintText: "Enter name of criteria",
            formatter: FilteringTextInputFormatter.singleLineFormatter,
            textInputType: TextInputType.text));
  }
}
