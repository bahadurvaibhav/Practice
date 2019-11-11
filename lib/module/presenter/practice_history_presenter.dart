import '../../data/practice_item.dart';
import '../../injection/dependency_injection.dart';

abstract class PracticeHistoryContract {
  void onLoadContactsComplete(List<PracticeItem> items);
  void onLoadContactsError();
}

class PracticeHistoryPresenter {
  PracticeHistoryContract _view;
  PracticeRepository _repository;

  PracticeHistoryPresenter(this._view) {
    _repository = Injector().contactRepository;
  }

  void loadItems() {
    assert(_view != null);

    _repository
        .fetch()
        .then((contacts) => _view.onLoadContactsComplete(contacts))
        .catchError((onError) {
      print(onError);
      _view.onLoadContactsError();
    });
  }
}
