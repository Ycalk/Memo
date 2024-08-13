import 'package:flutter/material.dart';

class ChooseColor extends StatelessWidget {
  final Color color;
  final double size;
  final bool isSelected;
  const ChooseColor({super.key, required this.color, required this.size, 
  this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
        color: color,
        shape: BoxShape.circle,
      ),
      child: isSelected ? Icon(
        Icons.check_rounded, 
        color: Colors.white,
        size: size / 1.4,
      ) : null,
    );
  }
}