import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    super.key,
    required this.categoryName,
    required this.onSelected,
  });

  final String categoryName;
  final Function(bool isSelected) onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 50,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: FilterChip(
        label: Text(categoryName),
        onSelected: onSelected,
      ),
    );
  }
}
