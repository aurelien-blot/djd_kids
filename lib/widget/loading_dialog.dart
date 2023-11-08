import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget{

  static const String _loadingMessage = "Veuillez patienter...";

  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SimpleDialog(
          key: key,
          backgroundColor: Colors.white,
          children: const <Widget>[
            Center(
              child: Column(children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  _loadingMessage,
                  style: TextStyle(color: Colors.blueAccent),
                )
              ]),
            )
          ]
      ),
    );
  }
}
