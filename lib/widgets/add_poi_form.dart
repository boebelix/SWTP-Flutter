import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:swtp_app/generated/l10n.dart';
import 'package:swtp_app/models/notifier_state.dart';
import 'package:swtp_app/models/position.dart';
import 'package:swtp_app/providers/categories_service_provider.dart';
import 'package:swtp_app/providers/poi_service_provider.dart';
import 'package:swtp_app/widgets/build_radiobutton.dart';
import 'package:latlong/latlong.dart';
import 'package:swtp_app/widgets/loading_indicator.dart';
import 'package:swtp_app/widgets/warning_dialog.dart';

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
  File _image;
  final picker = ImagePicker();

  Future<void> getImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
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
    final LatLng currentPosition = ModalRoute.of(context).settings.arguments as LatLng;

    return Scaffold(
      appBar: AppBar(
        title: Text(Language.of(context).addNewPoi),
      ),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Card(
            elevation: 20,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.shortestSide * 0.66,
                    width: MediaQuery.of(context).size.shortestSide * 0.66,
                    child: GestureDetector(
                      onTap: getImage,
                      child: _image == null
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                //color: Colors.amber,
                                border: Border.all(
                                  color: Colors.black45,
                                  width: 4,
                                ),
                              ),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                size: 80,
                              ),
                            )
                          : Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                child: Image.file(
                                  _image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    ),
                  ),
                  Spacer(),
                  Flexible(
                    flex: 8,
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          _inputTitle(context),
                          _inputDescription(context),
                          _inputCategories(context),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        final String _title = _titleController.text;
                        final String _description = _titleController.text;
                        final int _categoryId = Provider.of<CategoriesServiceProvider>(context, listen: false)
                            .currentSeletedCategory
                            .categoryId;
                        final Position _position =
                            Position(latitude: currentPosition.latitude, longitude: currentPosition.longitude);

                        _createPoi(context, _title, _description, _categoryId, _position);
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.98,
                        child: Card(
                          color: Theme.of(context).buttonColor,
                          elevation: 10,
                          child: Center(child: Text("Button")),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Consumer<CategoriesServiceProvider>(
          builder: (_, notifier, __) {
            switch (notifier.state) {
              case NotifierState.initial:
                return Container();
                break;
              case NotifierState.loading:
                return LoadingIndicator();
                break;
              default:
                return notifier.categoriesResponse.fold(
                      (failure) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      notifier.resetState();
                    });
                    return PopUpWarningDialog(
                      context: context,
                      failure: failure,
                    );
                  },
                      (r) {
                    return Container();
                  },
                );
            }

            {}
          },
        ),
      ]),
    );
  }

  void _createPoi(BuildContext context, String _title, String _description, int _categoryId, Position _position) async {
    await Provider.of<PoiServiceProvider>(context, listen: false).createPoi(
      title: _title,
      description: _description,
      categoryId: _categoryId,
      position: _position,
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

  Widget _inputDescription(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          fit: FlexFit.tight,
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 28, 10, 0),
            child: Icon(
              Icons.description_outlined,
              color: Colors.black45,
            ),
          ),
        ),
        Flexible(
          flex: 9,
          child: TextFormField(
            decoration: InputDecoration(
              labelText: Language.of(context).newPoiDescription,
              alignLabelWithHint: true,
            ),
            keyboardType: TextInputType.multiline,
            maxLines: 8,
            validator: (value) {
              return null;
            },
            controller: _descriptionController,
          ),
        ),
      ],
    );
  }

  Widget _inputTitle(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          fit: FlexFit.tight,
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
            child: Icon(
              Icons.description_outlined,
              color: Colors.black45,
            ),
          ),
        ),
        Flexible(
          flex: 9,
          child: TextFormField(
            decoration: InputDecoration(
              labelText: Language.of(context).newPoiTitle,
            ),
            validator: (value) {
              return null;
            },
            controller: _titleController,
          ),
        ),
      ],
    );
  }
}
