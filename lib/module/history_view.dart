import 'package:flutter/material.dart';
import 'package:practice/database/database_helper.dart';
import 'package:practice/database/form.dart';
import 'package:practice/module/enum/skill_type.dart';
import 'package:practice/module/practice_view.dart';

GlobalKey<_HistoryState> globalKey = GlobalKey();

class HomePage extends StatelessWidget {
  void selectPractice(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new StartPracticeDialog(callbackRefreshList);
      },
    );
  }

  void callbackRefreshList() {
    print('Home Page callback Refresh list called');
    globalKey.currentState.refreshList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
      ),
      body: History(key: globalKey),
      floatingActionButton: FloatingActionButton(
        onPressed: () => selectPractice(context),
        tooltip: 'Select Skill',
        child: Icon(Icons.add),
      ),
    );
  }
}

class StartPracticeDialog extends StatefulWidget {
  Function callbackRefreshList;

  StartPracticeDialog(this.callbackRefreshList);

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
      widget.callbackRefreshList();
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: new Text('Select Skill'),
      content: new DropdownButton(
          value: dropdownValue,
          items: SkillType.values.map((SkillType skillType) {
            return DropdownMenuItem<SkillType>(
              value: skillType,
              child: ClipRect(
                child: Text(getSkillTypeDisplayValue(skillType)),
              ),
            );
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
  List<PracticeForm> _historyItems = new List();
  bool _isSearching = true;

  @override
  void initState() {
    super.initState();
    refreshList();
  }

  refreshList() {
    print('History refreshList called');
    _isSearching = true;
    helper.getForms().then((items) {
      if (items == null) {
        // app newly installed and no data in database
        setState(() {
          _historyItems = new List();
          _isSearching = false;
        });
      } else if (_historyItems.length == 0) {
        // show values from database (items != null && _historyItems == null)
        setState(() {
          _historyItems = items;
          _isSearching = false;
        });
      } else if (items != null &&
          _historyItems.length > 0 &&
          items.length > _historyItems.length) {
        // new form added by user
        setState(() {
          _historyItems = items;
          _isSearching = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var widget;
    if (_isSearching) {
      widget = Center(
          child: Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: CircularProgressIndicator()));
    } else if (_historyItems.length == 0) {
      widget = Text('No data found');
    } else {
      widget = ListView(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          children: _buildHistoryList());
    }
    return widget;
  }

  List<_HistoryListItem> _buildHistoryList() {
    return _historyItems
        .map((contact) => _HistoryListItem(context, contact))
        .toList();
  }
}

class _HistoryListItem extends ListTile {
  _HistoryListItem(BuildContext context, PracticeForm practiceForm)
      : super(
            title: Text(practiceForm.skillType
                .toString()
                .substring(practiceForm.skillType.toString().indexOf('.') + 1)),
            subtitle: Text(practiceForm.createdAt),
            leading: null,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PracticePage(
                          skillType: practiceForm.skillType,
                          formId: practiceForm.id,
                        )),
              );
            });
}
