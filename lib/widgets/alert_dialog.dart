import 'dart:async';

import 'package:flutter/material.dart';

class AlertAutoDialog {
  static void showMessageDialog(String s, BuildContext context) {
    Timer? timer;
    showDialog(
        context: context,
        builder: (_) {
          timer = Timer(const Duration(seconds: 2), () {
            Navigator.of(context).pop();
          });

          return SimpleDialog(
            alignment: Alignment.bottomCenter,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  s,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          );
        }).then((val) {
      if (timer!.isActive) {
        timer!.cancel();
      }
    });
  }
}
