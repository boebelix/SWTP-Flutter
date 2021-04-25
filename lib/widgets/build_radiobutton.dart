import 'package:flutter/material.dart';
import 'package:swtp_app/models/category.dart';

class BuildRadioButtons extends StatefulWidget {
  final List categories;
  final SelectedCategoryCallback onCategorySelect;

  BuildRadioButtons({this.categories, this.onCategorySelect});

  @override
  _BuildRadioButtonsState createState() => _BuildRadioButtonsState();
}

class _BuildRadioButtonsState extends State<BuildRadioButtons> {
  Category _selectedCategory;

  void setSelectedCategory({Category category}) {
    setState(() {
      _selectedCategory = category;
      widget.onCategorySelect(category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.categories.length,
      itemBuilder: (context, index) {
        return _radioListTileElement(widget.categories, index);
      },
    );
  }

  RadioListTile<Category> _radioListTileElement(List<Category> categories, int index) {
    return RadioListTile(
      value: categories[index],
      groupValue: _selectedCategory,
      title: Text(categories[index].name),
      onChanged: (currentCategory) {
        setSelectedCategory(
          category: currentCategory,
        );
      },
      selected: _selectedCategory == categories[index],
    );
  }
}

typedef SelectedCategoryCallback = void Function(Category category);