import 'package:flutter/material.dart';

class TitleAndBox extends StatelessWidget {
  final String title;
  final Widget child;

  TitleAndBox({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 8),
        child,
      ],
    );
  }
}