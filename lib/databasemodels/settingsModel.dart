import '../helpers/constants.dart';

class Setting {
  String _fontName;

  Setting({fontName}) {
    this._fontName = fontName;
  }

  String get fontName => _fontName;

  set fontName(String fn) {
    this._fontName = fn;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map[SettingsConstants.COLUMN_FONTNAME] = _fontName;

    return map;
  }

  Setting.fromMap(Map input) {
    this._fontName = input[SettingsConstants.COLUMN_FONTNAME];
  }
}
