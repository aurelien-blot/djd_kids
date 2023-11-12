import 'package:flutter/material.dart';

class ValidationButton extends StatefulWidget {

  Function? onPressed;
  bool isEnabled;

  ValidationButton({super.key, this.onPressed, required this.isEnabled});

  @override
  _ValidationButtonState createState() => _ValidationButtonState();
}

class _ValidationButtonState extends State<ValidationButton> {
  static const String _submitLabel = "Valider";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = Colors.white;
    Color backgroundColor = widget.isEnabled==true ? Colors.blue : Colors.grey;

    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: textColor, backgroundColor:backgroundColor,
      ),
      onPressed: () async {
        if (widget.isEnabled==true && widget.onPressed != null) {
          widget.onPressed!();
        }
      },
      child: const Text(_submitLabel),
    );
  }

}
