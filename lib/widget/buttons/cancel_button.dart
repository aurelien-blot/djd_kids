import 'package:flutter/material.dart';

class CancelButton extends StatefulWidget {

  Function? onPressed;
  BuildContext? parentContext;

  CancelButton({super.key, this.onPressed, this.parentContext});

  @override
  _CancelButtonState createState() => _CancelButtonState();
}

class _CancelButtonState extends State<CancelButton> {
  static const String _submitLabel = "Annuler";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = Colors.grey;

    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: textColor
      ),
      onPressed: () async {
        if (widget.onPressed != null) {
          widget.onPressed!();
        }
        else if(widget.parentContext != null){
          Navigator.pop(widget.parentContext!);
        }
      },
      child: const Text(_submitLabel),
    );
  }

}
