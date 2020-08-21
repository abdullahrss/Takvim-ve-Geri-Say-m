import 'package:flutter/material.dart';
import 'pages/mainmenu.dart';
import 'helpers/ads.dart';

void main()  {
  WidgetsFlutterBinding.ensureInitialized();
  Advert advert = Advert();
  advert.showIntersitial();
  runApp(MainMenu());
}
