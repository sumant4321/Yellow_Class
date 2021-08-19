
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yellow_class/add_edit_movie.dart';
import 'package:yellow_class/authentication/methods.dart';
import 'package:yellow_class/models/data_model.dart';
import 'package:yellow_class/services/db_service.dart';
import 'package:yellow_class/utils/form_helper.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DBService dbService;

  @override
  void initState() {
    super.initState();
    dbService = new DBService();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(widget.title),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: () => logOut(context))
        ],
      ),
      body: _fetchData(),
    );
  }

  Widget _fetchData() {
    return FutureBuilder<List<MovieModel>>(
      future: dbService.getMovies(),
      builder:
          (BuildContext context, AsyncSnapshot<List<MovieModel>> movies) {
        if (movies.hasData) {
          return _buildUI(movies.data);
        }

        return CircularProgressIndicator();
      },
    );
  }
  Widget _buildUI(List<MovieModel> movies) {
    List<Widget> widgets = new List<Widget>();

    widgets.add(
      new Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddEditMovie(),
              ),
            );
          },
          child: Container(
            height: 35.0,
            width: 90,
            color: Colors.redAccent,
            child: Center(
              child: Text(
                "Add Movie",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    widgets.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [_buildDataTable(movies)],
      ),
    );

    return Padding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
      padding: EdgeInsets.all(5),
    );
  }

  Widget _buildDataTable(List<MovieModel> model) {
    return DataTable(
      columns: [
        DataColumn(
          label: Text(
            "Movie",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "Director",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "View/Action",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      sortColumnIndex: 1,
      rows: model
          .map(
            (data) => DataRow(
          cells: <DataCell>[
            DataCell(
              Text(
                data.movieName,
                style: TextStyle(fontSize: 13),
              ),
            ),
            DataCell(
              Text(
                data.movieDesc.toString(),
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
            ),
            DataCell(
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new IconButton(
                      padding: EdgeInsets.all(0),
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddEditMovie(
                              isEditMode: true,
                              model: data,
                            ),
                          ),
                        );
                      },
                    ),
                    new IconButton(
                      padding: EdgeInsets.all(0),
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        FormHelper.showMessage(
                          context,
                          "YELLOW CLASS",
                          "Do you want to delete this record?",
                          "Yes",
                              () {
                            dbService.deleteMovie(data).then((value) {
                              setState(() {
                                Navigator.of(context).pop();
                              });
                            });
                          },
                          buttonText2: "No",
                          isConfirmationDialog: true,
                          onPressed2: () {
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
          .toList(),
    );
  }
}