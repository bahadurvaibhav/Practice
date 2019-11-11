import 'package:flutter/material.dart';
import 'package:practice/module/enum/skill_type.dart';
import 'package:practice/module/practice_view.dart';

import '../data/practice_item.dart';
import 'presenter/practice_history_presenter.dart';

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
      MaterialPageRoute(builder: (context) => PracticePage()),
    );
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

class _HistoryState extends State<History> implements PracticeHistoryContract {
  PracticeHistoryPresenter _presenter;

  List<PracticeItem> _contacts;

  bool _isSearching;

  _HistoryState() {
    _presenter = PracticeHistoryPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _isSearching = true;
    _presenter.loadItems();
  }

  @override
  void onLoadContactsComplete(List<PracticeItem> items) {
    setState(() {
      _contacts = items;
      _isSearching = false;
    });
  }

  @override
  void onLoadContactsError() {
    // TODO: implement onLoadContactsError
  }

  @override
  Widget build(BuildContext context) {
    var widget;

    if (_isSearching) {
      widget = Center(
          child: Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: CircularProgressIndicator()));
    } else {
      widget = ListView(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          children: _buildContactList());
    }

    return widget;
  }

  List<_ContactListItem> _buildContactList() {
    return _contacts.map((contact) => _ContactListItem(contact)).toList();
  }
}

class _ContactListItem extends ListTile {
  _ContactListItem(PracticeItem contact)
      : super(
            title: Text(contact.skillType),
            subtitle: Text(contact.createdAt),
            leading: null);
}
