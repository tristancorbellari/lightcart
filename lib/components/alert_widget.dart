import 'package:flutter/material.dart';

String flattenAlertMessages(List<String> alertMessages) {
  String alertMessage = alertMessages.elementAt(0);
  for (int i = 1; i < alertMessages.length; i++) {
    alertMessage += "\n${alertMessages.elementAt(i)}";
  }
  return alertMessage;
}

void showAlertWidget(BuildContext context, String alertMessage) {
  showDialog(
    context: context,
    barrierColor: const Color.fromARGB(30, 0, 0, 0),
    builder: (context) {
      return AlertWidget(alertMessage: alertMessage);
    },
  );
}

class AlertWidget extends StatefulWidget {
  final String alertMessage;

  const AlertWidget({Key? key, required this.alertMessage}) : super(key: key);

  @override
  State<AlertWidget> createState() => _AlertWidgetState();
}

class _AlertWidgetState extends State<AlertWidget> {
  @override
  void initState() {
    super.initState();
    close();
  }

  void close() {
    Future.delayed(
      const Duration(seconds: 2),
      () {
        if (mounted) {
          Navigator.pop(context);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0))),
      backgroundColor: Colors.orange[50],
      shadowColor: const Color.fromARGB(158, 158, 158, 158),
      content: Text(
        widget.alertMessage,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 13),
      ),
      insetPadding: const EdgeInsets.fromLTRB(0, 500, 0, 0),
      contentPadding: const EdgeInsets.all(6),
    );
  }
}
