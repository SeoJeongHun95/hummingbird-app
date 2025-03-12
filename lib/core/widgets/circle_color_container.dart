import 'package:flutter/material.dart';

class CircleColorContainer extends StatelessWidget {
  const CircleColorContainer(
      {super.key, required this.width, required this.color, this.isSelected});

  final String color;
  final double width;
  final bool? isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 1),
        color: Color(int.parse('0xff$color')),
      ),
      child: isSelected == true
          ? Icon(
              Icons.check,
              color: Colors.black,
            )
          : null,
    );
  }
}
