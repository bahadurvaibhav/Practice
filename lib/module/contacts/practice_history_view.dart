import 'package:flutter/material.dart';

import '../../data/practice_item.dart';
import '../enum/skill_type.dart';
import 'practice_history_presenter.dart';

class ContactsPage extends StatelessWidget {
  void selectPractice(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('Select Skill'),
          content: new Text('body'),
          actions: <Widget>[
            new FlatButton(onPressed: null, child: new Text('Close')),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
      ),
      body: PracticeHistory(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => selectPractice(context),
        tooltip: 'Select Skill',
        child: Icon(Icons.add),
      ),
    );
  }
}

///
///   Contact List
///

class PracticeHistory extends StatefulWidget {
  PracticeHistory({Key key}) : super(key: key);

  @override
  _PracticeHistoryState createState() => _PracticeHistoryState();
}

class _PracticeHistoryState extends State<PracticeHistory>
    implements PracticeHistoryContract {
  PracticeHistoryPresenter _presenter;

  List<PracticeItem> _contacts;

  bool _isSearching;

  _PracticeHistoryState() {
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

///
///   Contact List Item
///

class _ContactListItem extends ListTile {
  _ContactListItem(PracticeItem contact)
      : super(
            title: Text(contact.skillType),
            subtitle: Text(contact.createdAt),
            leading: null);
}
