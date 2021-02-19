import 'dart:convert';

import 'package:dropdown/User.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Dropdowns",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(),
    );
  }
}

// ================== coped from stakeoverflow

class MultiSelectDialogItem<V> {
  const MultiSelectDialogItem(this.id, this.userName);

  final V id;
  final String userName;
}

class MultiSelectDialog<V> extends StatefulWidget {
  MultiSelectDialog({Key key, this.items, this.initialSelectedValues})
      : super(key: key);

  final List<MultiSelectDialogItem<V>> items;
  final Set<V> initialSelectedValues;

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
}

class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {


  final _selectedValues = Set<V>();

  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues);
    }
  }

  void _onItemCheckedChange(V itemValue, bool checked) {
    setState(() {
      if (checked) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Country'),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: widget.items.map(_buildItem).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: _onCancelTap,
        ),
        RaisedButton(

          child: Text('OK'),
          onPressed: _onSubmitTap,
        )
      ],
    );
  }

  Widget _buildItem(MultiSelectDialogItem<V> item) {
    final checked = _selectedValues.contains(item.id);
    return CheckboxListTile(
      value: checked,
      title: Text(item.userName),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.id, checked),
    );
  }
}

// ===================

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<User> users = [];
  int sDay = 9;
  int sMonth = 3;
  int sYear = 2021;
  int eDay = 22;
  int eMonth = 3;
  int eYear = 2021;
  String membersIdString;
  String projectTitleString = "Attendance APP";
  String projectDescriptionString = "This app is used for attendance.";

  Future<List<User>> loadUser() async {
    String url = "http://192.168.11.153:8075/api/users";
    final response = await http.get(url);

    var responseData = json.decode(response.body);

    //Creating a list to store input data;
    for (var singleUser in responseData) {
      User user = User(
          id: singleUser["id"],
          userName: singleUser["user_name"],
          role: singleUser["role"]);
      // print(responseData);
      //   //Adding user to the list.
      users.add(user);
    }
    setState(() {
      responseData = users;
    });
    print(users);

    return users;
  }
  String value = "";

  // ignore: deprecated_member_use
  List<DropdownMenuItem<String>> menuitems = List();
  bool disabledropdown = true;

  // ignore: deprecated_member_use
  List<MultiSelectDialogItem<int>> multiItem = List();

var valuestopopulate
  = {
    1: "Hafeez",
    2: "Bilal",
    3: "Sohaib",
    4: "Ahsan Mukhtar",
    5: "Kamran Ameen",
    6: "Abdull Whahab ",
    7: "Jr. Abdullah",
    8: "Sr. Abdullah",
    9: "Saharjeel Mustafa",
    10: "Osama Azeem",
    11: "Fakhar ul Hassan",
    };


  // };

  void populateMultiselect() {

    for (int v in valuestopopulate.keys) {
      multiItem.add(MultiSelectDialogItem(v, valuestopopulate[v]));
    }
  }

  void _showMultiSelect(BuildContext context) async {
    multiItem = [];
    populateMultiselect();
    final items = multiItem;
    // final items = <MultiSelectDialogItem<int>>[
    //   MultiSelectDialogItem(1, 'India'),
    //   MultiSelectDialogItem(2, 'USA'),
    //   MultiSelectDialogItem(3, 'Canada'),
    // ];

    final selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
          initialSelectedValues: [0].toSet(),
        );
      },
    );

    print(selectedValues);
    getvaluefromkey(selectedValues);
  }

  void getvaluefromkey(Set selection) {
    if (selection != null) {
      for (int x in selection.toList()) {
        print(valuestopopulate[x]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dropdown",
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "$value",
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            RaisedButton(
              child: Text("Open Multiselect"),
              onPressed: () => _showMultiSelect(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadUser();
  }
  void putGetApiDataInMultiSelectDialogueBox()
  {
    // loadUser({['id','user_name']});
    List<User> FromJson(String str) =>
        List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

  }
}
