import 'package:flutter/material.dart';
import 'package:practice/database/database_helper.dart';
import 'package:practice/database/form.dart';
import 'package:practice/module/enum/skill_type.dart';
import 'package:practice/module/practice_view.dart';

class HomePage extends StatelessWidget {
  void selectPractice(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new StartPracticeDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Parent build method invoked");
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
      ),
      body: History(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => selectPractice(context),
        tooltip: 'Select Skill',
        child: Icon(Icons.add),
      ),
    );
  }
}

class StartPracticeDialog extends StatefulWidget {
  const StartPracticeDialog({Key key}) : super(key: key);

  @override
  _StartPracticeDialogState createState() => _StartPracticeDialogState();
}

class _StartPracticeDialogState extends State<StartPracticeDialog> {
  SkillType dropdownValue = SkillType.Joke;

  void startPractice() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PracticePage(skillType: dropdownValue)),
    ).then((value) {
      setState(() {});
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Dialog build method invoked");
    return new AlertDialog(
      title: new Text('Select Skill'),
      content: new DropdownButton(
          value: dropdownValue,
          items: SkillType.values.map((SkillType skillType) {
            return DropdownMenuItem<SkillType>(
                value: skillType,
                child: Text(skillType
                    .toString()
                    .substring(skillType.toString().indexOf('.') + 1)));
          }).toList(),
          onChanged: (SkillType newValue) {
            setState(() {
              dropdownValue = newValue;
            });
          }),
      actions: <Widget>[
        new FlatButton(
          onPressed: () => startPractice(),
          child: new Text('Start'),
        ),
      ],
    );
  }
}

class History extends StatefulWidget {
  History({Key key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  DatabaseHelper helper = DatabaseHelper.instance;
  List<PracticeForm> _historyItems;
  bool _isSearching = true;

  refreshList() {
    helper.getForms().then((items) {
      if (items == null && _historyItems == null) {
        // app newly installed and no data in database
        setState(() {
          _historyItems = new List();
          _isSearching = false;
        });
      } else if (items != null && _historyItems == null) {
        // show values from database
        print('# of forms: ${items.length} & # of historyItems: 0');
        setState(() {
          _historyItems = items;
          _isSearching = false;
        });
      } else if (items != null &&
          _historyItems != null &&
          items.length > _historyItems.length) {
        // new form added by user
        print(
            '# of forms: ${items.length} & # of historyItems: ${_historyItems.length}');
        setState(() {
          _historyItems = items;
          _isSearching = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Child build method invoked");
    refreshList();
//    print(
//        'isSearching: $_isSearching # of historyItems: ${_historyItems.length}');
    var widget;
    if (_isSearching) {
      widget = Center(
          child: Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: CircularProgressIndicator()));
    } else if (_historyItems != null && _historyItems.length == 0) {
      widget = Text('No data found');
    } else {
      widget = ListView(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          children: _buildHistoryList());
    }
    return widget;
  }

  List<_HistoryListItem> _buildHistoryList() {
    return _historyItems.map((contact) => _HistoryListItem(contact)).toList();
  }
}

class _HistoryListItem extends ListTile {
  _HistoryListItem(PracticeForm practiceForm)
      : super(
            title: Text(practiceForm.skillType
                .toString()
                .substring(practiceForm.skillType.toString().indexOf('.') + 1)),
            subtitle: Text(practiceForm.createdAt),
            leading: null);
}
