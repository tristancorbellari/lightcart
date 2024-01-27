import 'package:flutter/material.dart';

void showOptionDialog(BuildContext context, String option_1,
    VoidCallback function_1, String option_2, VoidCallback function_2) {
  showDialog(
    context: context,
    barrierColor: const Color.fromARGB(30, 0, 0, 0),
    builder: (context) {
      return OptionDialog(
          option_1: option_1,
          function_1: function_1,
          option_2: option_2,
          function_2: function_2);
    },
  );
}

class OptionDialog extends StatelessWidget {
  final String option_1;
  final VoidCallback function_1;
  final String option_2;
  final VoidCallback function_2;

  const OptionDialog({
    Key? key,
    required this.option_1,
    required this.function_1,
    required this.option_2,
    required this.function_2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Confirm reset"),
      content: const Text("Would you like to reset your products list?"),
      backgroundColor: Colors.white,
      actions: [
        ElevatedButton(
            onPressed: () {
              function_1();
              Navigator.of(context).pop(false);
            },
            child: const Text("No")),
        ElevatedButton(
            onPressed: () {
              function_2();
              Navigator.of(context).pop(false);
            },
            child: const Text("Yes"))
      ],
    );
  }
}
