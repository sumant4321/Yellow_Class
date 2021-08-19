import 'package:yellow_class/home.dart';
import 'package:yellow_class/models/data_model.dart';
import 'package:yellow_class/services/db_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yellow_class/utils/form_helper.dart';

class AddEditMovie extends StatefulWidget {
  AddEditMovie({Key key, this.model, this.isEditMode = false})
      : super(key: key);
  MovieModel model;
  bool isEditMode;

  @override
  _AddEditMovieState createState() => _AddEditMovieState();
}

class _AddEditMovieState extends State<AddEditMovie> {
  MovieModel model;
  DBService dbService;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dbService = new DBService();
    model = new MovieModel();

    if (widget.isEditMode) {
      model = widget.model;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        automaticallyImplyLeading: true,
        title: Text(widget.isEditMode ? "Edit Movie" : "Add Movie"),
      ),
      body: new Form(
        key: globalFormKey,
        child: _formUI(),
      ),
    );
  }

  Widget _formUI() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormHelper.fieldLabel("Movie Name"),
                FormHelper.textInput(
                  context,
                  model.movieName,
                      (value) => {
                    this.model.movieName = value,
                  },
                  onValidate: (value) {
                    if (value.toString().isEmpty) {
                      return 'Please enter Movie Name.';
                    }
                    return null;
                  },
                ),
                FormHelper.fieldLabel("Movie Director"),
                FormHelper.textInput(
                    context,
                    model.movieDesc,
                        (value) => {
                      this.model.movieDesc = value,
                    },
                    isTextArea: true, onValidate: (value) {
                  return null;
                }),
                FormHelper.fieldLabel("Select Movie Photo"),
                FormHelper.picPicker(
                  model.moviePic,
                      (file) => {
                    setState(
                          () {
                        model.moviePic = file.path;
                      },
                    )
                  },
                ),
                btnSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }


  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget btnSubmit() {
    return new Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          if (validateAndSave()) {
            print(model.toMap());
            if (widget.isEditMode) {
              dbService.updateMovie(model).then((value) {
                FormHelper.showMessage(
                  context,
                  "YELLOW CLASS",
                  "Data Submitted Successfully",
                  "Ok",
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(title: "Yellow Class"),
                      ),
                    );
                  },
                );
              });
            } else {
              dbService.addMovie(model).then((value) {
                FormHelper.showMessage(
                  context,
                  "YELLOW CLASS",
                  "Data Modified Successfully",
                  "Ok",
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(title:"Yellow Class"),
                      ),
                    );
                  },
                );
              });
            }
          }
        },
        child: Container(
          height: 35.0,
          margin: EdgeInsets.all(10),
          width: 90,
          color: Colors.blueAccent,
          child: Center(
            child: Text(
              "Save Movie",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}