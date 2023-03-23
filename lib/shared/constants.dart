import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  contentPadding: EdgeInsets.all(12.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.pink, width: 2.0),
  ),
);

class DialogBox extends StatelessWidget {
  String? currentName;
  void Function(String?) onPress;
  var controller = TextEditingController();
  final buttontext;

  DialogBox({
    super.key,
    required this.currentName,
    required this.onPress,
    required this.buttontext,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return AlertDialog(
      backgroundColor: Colors.yellow,
      content: Container(
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  hintText: currentName,
                  suffixIcon: IconButton(
                    onPressed: () => controller.clear(),
                    icon: const Icon(
                      Icons.clear,
                    ),
                  ),
                ),
              ),
              MaterialButton(
                child: Text(
                  buttontext,
                  selectionColor: Colors.amber,
                ),
                onPressed: () => onPress(controller.text.toLowerCase()),
              ),
            ],
          ),
        ),
        //
      ),
    );
    //   },
    // );
  }
}

class IncomeEditDialog extends StatefulWidget {
  IncomeEditDialog({
    super.key,
    required this.edit,
    required this.leadHint,
    required this.trailHint,
  });
  void Function(String?, int?) edit;
  String trailHint;
  String leadHint;

  @override
  State<IncomeEditDialog> createState() => _IncomeEditDialogState();
}

class _IncomeEditDialogState extends State<IncomeEditDialog> {
  TextEditingController leadingcontroller = TextEditingController();
  TextEditingController trailingcontroller = TextEditingController();
  String? validate;

  @override
  void dispose() {
    trailingcontroller.dispose();
    leadingcontroller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.yellow,
      content: Form(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            // key: _formkey,
            validator: (String? ammount) {
              if (ammount == null) {
                return "please provide ammount";
              }
              return null;
            },
            controller: leadingcontroller,
            decoration: textInputDecoration.copyWith(
                hintText: widget.leadHint,
                //border: const UnderlineInputBorder(),
                labelText: "Income",
                fillColor: Colors.orange[50]),
            keyboardType: TextInputType.text,
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            key: _formkey,
            validator: (String? ammount) {
              if (ammount == null) {
                return "please provide ammount";
              }
              return null;
            },
            controller: trailingcontroller,
            decoration: textInputDecoration.copyWith(
              hintText: widget.trailHint,
              border: UnderlineInputBorder(),
              labelText: "Ammount",
              hintTextDirection: TextDirection.ltr,
              fillColor: Colors.yellow[50],
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(
            child: Text(
              "$validate",
              style: const TextStyle(
                color: Colors.redAccent,
              ),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () async {
                  if (leadingcontroller.text.isNotEmpty &&
                      trailingcontroller.text.isNotEmpty) {
                    Navigator.pop(context);
                    widget.edit(leadingcontroller.text,
                        int.parse(trailingcontroller.text));
                  } else {
                    setState(() {
                      validate = "Please provide both fields";
                    });
                  }
                },
                icon: const Icon(Icons.save),
                label: const Text("Save"),
              ),
              TextButton.icon(
                onPressed: (() => Navigator.of(context).pop()),
                icon: const Icon(Icons.cancel),
                label: const Text("cancle"),
              ),
            ],
          )
        ],
      )),
    );
  }
}

class Alertdialog extends StatelessWidget {
  Alertdialog({super.key, required this.message});
  String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.amber,
      contentPadding: const EdgeInsets.all(7),
      icon: Icon(
        Icons.warning_sharp,
        color: Colors.red[900],
      ),
      content: const Icon(
        Icons.warning_sharp,
      ),
      title: Text(message),
    );
  }
}
