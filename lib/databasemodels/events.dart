import '../helpers/eventConstants.dart';

class Event {
  int _id;
  String _title;
  String _date;
  String _startTime;
  String _finishTime;
  String _desc;
  int _isActive;
  String _choice;
  int _countDownIsActive;

  Event({int id, String title, String date, String startTime, String finishTime, String desc, int isActive, String choice, int countDownIsActive}){
    this._id = id;
    this._title = title;
    this._date = date;
    this._startTime = startTime;
    this._finishTime = finishTime;
    this._desc = desc;
    this._isActive = isActive;
    this._choice = choice;
    this._countDownIsActive = countDownIsActive;
  }

  int get id => _id;

  String get title => _title;

  String get date => _date;

  String get startTime => _startTime;

  String get finishTime => _finishTime;

  String get desc => _desc;

  int get isActive => _isActive;

  String get choice => _choice;

  int get countDownIsActive => _countDownIsActive;

  set id(int newId) {
    _id = newId;
  }

  set title(String newTitle) {
    _title = newTitle;
  }

  set date(String newDate) {
    _date = newDate;
  }

  set startTime(String newStartTime) {
    _startTime = newStartTime;
  }

  set finishTime(String newFinishTime) {
    _finishTime = newFinishTime;
  }

  set desc(String newDesc) {
    _desc = newDesc;
  }

  set isActive(int newState) {
    _isActive = newState;
  }
  set choice(String newChoice){
    _choice = newChoice;
  }
  set countDownIsActive(int countDownIsActive){
    _countDownIsActive = countDownIsActive;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (_id != null) {
      map[EventConstants.COLUMN_ID] = _id;
    }
    map[EventConstants.COLUMN_TITLE] = _title;
    map[EventConstants.COLUMN_DATE] = _date;
    map[EventConstants.COLUMN_STARTTIME] = _startTime;
    map[EventConstants.COLUMUN_FINISHTIME] = _finishTime;
    map[EventConstants.COLUMN_DESCRIPTION] = _desc;
    map[EventConstants.COLUMN_ISACTIVE] = _isActive;
    map[EventConstants.COLUMN_NOTIFICATION] = _choice;
    map[EventConstants.COLUMN_COUNTDOWNISACTIVE] = _countDownIsActive;
    return map;
  }

  Event.fromMap(Map input) {
    this._id = input[EventConstants.COLUMN_ID];
    this._title = input[EventConstants.COLUMN_TITLE];
    this._date = input[EventConstants.COLUMN_DATE];
    this._startTime = input[EventConstants.COLUMN_STARTTIME].toString();
    this._finishTime = input[EventConstants.COLUMUN_FINISHTIME].toString();
    this._desc = input[EventConstants.COLUMN_DESCRIPTION];
    this._isActive = input[EventConstants.COLUMN_ISACTIVE];
    this._choice = input[EventConstants.COLUMN_NOTIFICATION];
    this._countDownIsActive = input[EventConstants.COLUMN_COUNTDOWNISACTIVE];
  }
}
