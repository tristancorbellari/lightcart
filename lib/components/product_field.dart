import 'package:flutter/material.dart';

class ProductField extends StatelessWidget {
  final String header;
  final List<Widget> widgets;
  final String fineText;

  const ProductField(
      {Key? key,
      required this.header,
      required this.widgets,
      this.fineText = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(11, 8, 11, 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          RichText(
            text: TextSpan(
              text: header,
              style: const TextStyle(
                  fontSize: 18,
                  height: 1,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: widgets.length > 1
                ? [
                    widgets.elementAt(0),
                    const SizedBox(width: 10),
                    widgets.elementAt(1)
                  ]
                : widgets, // This is a bit wonky but gets the job done
          ),
          const SizedBox(height: 3),
          if (fineText != "")
            Text(fineText, style: const TextStyle(fontSize: 10)),
        ]),
      ),
    );
    //   )
    // ]);
  }
}

class TextFieldWidget extends StatefulWidget {
  final String textFieldHintText;
  final bool acceptOnlyNumbers;
  final String prefix;
  final void Function(String) update;
  final String? initialValue;
  bool hasError;

  TextFieldWidget(
      {Key? key,
      required this.textFieldHintText,
      this.acceptOnlyNumbers = false,
      this.prefix = "",
      required this.update,
      this.initialValue,
      required this.hasError})
      : super(key: key);

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
          controller: TextEditingController(text: widget.initialValue),
          keyboardType: widget.acceptOnlyNumbers
              ? TextInputType.number
              : TextInputType.text,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
              enabledBorder: widget.hasError
                  ? const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1.0),
                    )
                  : null,
              isDense: true,
              contentPadding: const EdgeInsets.all(8),
              border: const OutlineInputBorder(),
              prefixIcon: Padding(
                  padding: const EdgeInsets.fromLTRB(6, 0, 3, 1.5),
                  child: Text(widget.prefix,
                      style: const TextStyle(fontSize: 16.5))),
              prefixIconConstraints:
                  const BoxConstraints(minWidth: 0, minHeight: 0),
              hintText: widget.textFieldHintText,
              hintStyle: const TextStyle(fontWeight: FontWeight.w400)),
          onChanged: (text) {
            widget.update(text);
          }),
    );
  }
}

class AutoCompleteWidget extends StatefulWidget {
  final String textFieldHintText;
  final void Function(String) update;
  final String? initialValue;
  bool hasError;
  Map<dynamic, dynamic> productsWithSameBarcode;

  AutoCompleteWidget(
      {Key? key,
      required this.textFieldHintText,
      required this.update,
      this.initialValue,
      required this.hasError,
      required this.productsWithSameBarcode})
      : super(key: key);

  @override
  State<AutoCompleteWidget> createState() => _AutoCompleteWidgetState();
}

class _AutoCompleteWidgetState extends State<AutoCompleteWidget> {
  static const List<String> _kOptions = <String>[
    'string 1',
    'string 2',
    'string 3'
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return const Iterable<String>.empty();
          }

          return _kOptions.where((String option) {
            return option.contains(textEditingValue.text.toLowerCase());
          });
        },
        fieldViewBuilder: (BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted) {
          return TextFormField(
            controller: textEditingController,
            decoration: InputDecoration(
                enabledBorder: widget.hasError
                    ? const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.0),
                      )
                    : null,
                isDense: true,
                contentPadding: const EdgeInsets.all(8),
                border: const OutlineInputBorder(),
                prefixIcon: const Padding(
                    padding: EdgeInsets.fromLTRB(6, 0, 3, 1.5),
                    child: Text("", style: TextStyle(fontSize: 16.5))),
                prefixIconConstraints:
                    const BoxConstraints(minWidth: 0, minHeight: 0),
                hintText: widget.textFieldHintText,
                hintStyle: const TextStyle(fontWeight: FontWeight.w400)),
            focusNode: focusNode,
          );
        },
        onSelected: (String selection) {},
      ),
    );
  }
}

class DropdownMenuWidget extends StatefulWidget {
  final List<String> dropdownItems;
  final double? width;
  final void Function(String) update;
  final String? initialValue;
  final bool hasError;

  const DropdownMenuWidget(
      {Key? key,
      required this.dropdownItems,
      this.width,
      required this.update,
      this.initialValue,
      required this.hasError})
      : super(key: key);

  @override
  State<DropdownMenuWidget> createState() => _DropdownMenuWidgetState();
}

class _DropdownMenuWidgetState extends State<DropdownMenuWidget> {
  late String? dropdownValue = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      width: widget.width,
      initialSelection: widget.initialValue,
      inputDecorationTheme: const InputDecorationTheme(
        isDense: true,
        contentPadding: EdgeInsets.all(8),
        border: OutlineInputBorder(),
        constraints: BoxConstraints(maxHeight: 36),
      ),
      onSelected: (value) {
        setState(() {
          dropdownValue = value!;
          widget.update(dropdownValue!);
          // widget.update(value!);
        });
      },
      dropdownMenuEntries:
          widget.dropdownItems.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}
