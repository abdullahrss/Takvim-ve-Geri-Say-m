import '../helpers/constants.dart';

class Setting {
  String _theme;
  String _fontName;

  Setting({theme,fontName}) {
    this._theme = theme;
    this._fontName = fontName;
  }
  String get theme => _theme;
  String get fontName => _fontName;

  set theme(String th) {
    this._theme = th;
  }
  set fontName(String fn) {
    this._fontName = fn;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map[SettingsConstants.COLUMN_THEME]= _theme;
    map[SettingsConstants.COLUMN_FONTNAME] = _fontName;

    return map;
  }

  Setting.fromMap(Map input) {
    this._theme = input[SettingsConstants.COLUMN_THEME];
    this._fontName = input[SettingsConstants.COLUMN_FONTNAME];
  }
}
