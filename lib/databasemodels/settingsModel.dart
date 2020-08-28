import '../helpers/constants.dart';

class Setting {
  String _theme;
  String _fontName;
  int _warning;

  Setting({theme,fontName,warning}) {
    this._theme = theme;
    this._fontName = fontName;
    this._warning = warning;
  }
  String get theme => _theme;
  String get fontName => _fontName;
  int get warning => _warning;

  set theme(String th) {
    this._theme = th;
  }
  set fontName(String fn) {
    this._fontName = fn;
  }

  set warning(int w){
    warning = w;
  }
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map[SettingsConstants.COLUMN_THEME]= _theme;
    map[SettingsConstants.COLUMN_FONTNAME] = _fontName;
    map[SettingsConstants.COLUMN_WARNING] = _warning;
    return map;
  }

  Setting.fromMap(Map input) {
    this._theme = input[SettingsConstants.COLUMN_THEME];
    this._fontName = input[SettingsConstants.COLUMN_FONTNAME];
    this._warning = input[SettingsConstants.COLUMN_WARNING];
  }
}
