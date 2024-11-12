import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwitchButton extends StatefulWidget {
  final String text;
  const SwitchButton({super.key, required this.text});

  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  bool isSwitchOn = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CupertinoSwitch(
          value: isSwitchOn,
          onChanged: (value) {
            setState(() {
              isSwitchOn = !isSwitchOn;
            });
          },
        ),
        SizedBox(width: 8), // Space between Switch and Text
        Text(
          widget.text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w300,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
