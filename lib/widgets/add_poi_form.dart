import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swtp_app/generated/l10n.dart';
import 'package:swtp_app/models/category.dart';
import 'package:swtp_app/models/notifier_state.dart';
import 'package:swtp_app/widgets/warning_dialog.dart';
import 'loading_indicator.dart';
import 'package:swtp_app/providers/categories_service_provider.dart';

class AddPoiForm extends StatefulWidget {
  static const routeName = '/addPoiForm';

  @override
  _AddPoiFormState createState() => _AddPoiFormState();
}

class _AddPoiFormState extends State<AddPoiForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  int selectedRadioTile;
  Category selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedRadioTile = 0;
  }

  void setSelectedCategory(Category category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Language.of(context).addNewPoi),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
            elevation: 20,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  _inputTitle(context),
                  _inputDescription(context),
                  _inputCategories(context),
                ],
              ),
            )),
      ),
    );
  }

  Consumer<CategoriesServiceProvider> _inputCategories(BuildContext context) {
    return Consumer<CategoriesServiceProvider>(
      builder: (_, notifier, __) {
        switch (notifier.state) {
          case NotifierState.initial:
            {
              return Container();
            }
            break;

          case NotifierState.loading:
            {
              return LoadingIndicator();
            }
            break;

          default:
            {
              return notifier.categoriesResponse.fold(
                //Fehlerfall
                (failure) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    notifier.resetState();
                  });
                  return PopUpWarningDialog(
                    context: context,
                    failure: failure,
                  );
                },
                // Alles in Ordnung
                (categories) {
                  return _buildCategories(categories);
                },
              );
            }
        }
      },
    );
  }

  ListView _buildCategories(List<Category> categories) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return _radioListTileElement(categories, index);
      },
    );
  }

  RadioListTile<Category> _radioListTileElement(List<Category> categories, int index) {
    return RadioListTile(
      value: categories[index],
      groupValue: selectedCategory,
      title: Text(categories[index].name),
      onChanged: (currentCategory) {
        print("Current Category ${currentCategory.name}");
        setSelectedCategory(currentCategory);
      },
      selected: selectedCategory == categories[index],
    );
  }

  TextFormField _inputDescription(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: Language.of(context).newPoiDescription,
        icon: Icon(Icons.text_snippet),
      ),
      keyboardType: TextInputType.multiline,
      maxLines: null,
      validator: (value) {
        return null;
      },
      controller: _descriptionController,
    );
  }

  TextFormField _inputTitle(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: Language.of(context).newPoiTitle,
        icon: Icon(Icons.account_circle),
      ),
      validator: (value) {
        return null;
      },
      controller: _titleController,
    );
  }
}
