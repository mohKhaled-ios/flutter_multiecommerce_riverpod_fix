import 'package:flutter/material.dart';

class ReusableDoubleTextRow extends StatelessWidget {
  final String firstText;
  final String secondText;
  final double fontSize;

  const ReusableDoubleTextRow({
    super.key,
    required this.firstText,
    required this.secondText,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            firstText,
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            secondText,
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
