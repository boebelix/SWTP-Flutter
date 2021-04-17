import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swtp_app/models/category.dart';
import 'package:swtp_app/providers/categories_service_provider.dart';

// ignore: must_be_immutable
class BuildRadioButtons extends StatefulWidget {
  List categories;

  BuildRadioButtons({this.categories});

  @override
  _BuildRadioButtonsState createState() => _BuildRadioButtonsState();
}

class _BuildRadioButtonsState extends State<BuildRadioButtons> {
  Category _selectedCategory;

  void setSelectedCategory({Category category}) {
    setState(() {
      Provider.of<CategoriesServiceProvider>(context, listen: false).setCurrentSeletedCategory(category);
      _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
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
