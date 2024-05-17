import 'package:flutter/material.dart';

class FilterCategory extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onSelectCategory;

  const FilterCategory({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelectCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories
            .map(
              (category) => GestureDetector(
                onTap: () => onSelectCategory(category),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: category == selectedCategory
                        ? Color.fromRGBO(255, 83, 137, 1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Color.fromRGBO(255, 83, 137, 1),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    category,
                    style: category == selectedCategory
                        ? TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)
                        : TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
