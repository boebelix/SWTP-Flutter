import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swtp_app/generated/l10n.dart';
import 'package:swtp_app/models/notifier_state.dart';
import 'package:swtp_app/providers/categories_service_provider.dart';
import 'package:swtp_app/widgets/build_radiobutton.dart';

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
    return Consumer<CategoriesServiceProvider>(builder: (_, notifier, __) {
      if (notifier.state == NotifierState.loaded) {
        var categories = notifier.categories;
        return BuildRadioButtons(
          categories: categories,
        );
      } else {
        return Container();
      }
    });
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
