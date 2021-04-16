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

  int selectedRadio;
  int selectedRadioTile;
  Category selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
    selectedRadioTile = 0;
  }

  void setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  void setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  void setSelectedCategory(Category category) {
    setState(() {
      selectedCategory = category;
    });
  }

  List<Widget> createCategoriesList(List<Category> categories) {
    List<Widget> widgets = [];
    for (Category category in categories) {
      widgets.add(
        RadioListTile(
          value: category,
          groupValue: selectedCategory,
          title: Text(category.name),
          subtitle: Text(category.categoryId.toString()),
          onChanged: (currentCategory) {
            print("Current Category ${currentCategory.name}");
            setSelectedCategory(currentCategory);
          },
          selected: selectedCategory == category,
        ),
      );
    }
    return widgets;
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
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: Language.of(context).newPoiTitle,
                      icon: Icon(Icons.account_circle),
                    ),
                    validator: (value) {},
                    controller: _titleController,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: Language.of(context).newPoiDescription,
                      icon: Icon(Icons.text_snippet),
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    validator: (value) {},
                    controller: _descriptionController,
                  ),
                  Consumer<CategoriesServiceProvider>(
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
                                return Column(
                                  children: createCategoriesList(categories),
                                );
                              },
                            );
                          }
                      }
                    },
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
