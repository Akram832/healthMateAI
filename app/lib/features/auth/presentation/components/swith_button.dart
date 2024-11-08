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
        Switch(
          activeColor:
              Theme.of(context).colorScheme.primary, // Thumb color when active
          activeTrackColor: Theme.of(context)
              .colorScheme
              .secondary, // Track color when active
          inactiveThumbColor: Theme.of(context)
              .colorScheme
              .secondary, // Thumb color when inactive
          inactiveTrackColor: Theme.of(context)
              .colorScheme
              .primary, // Track color when inactive
          value: isSwitchOn,
          onChanged: (value) {
            setState(() {
              isSwitchOn = value;
            });
          },
        ),
        SizedBox(width: 8), // Space between Switch and Text
        Text(
          widget.text,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
