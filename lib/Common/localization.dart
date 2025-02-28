import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DemoLocalization {
  static final DemoLocalization _singleton = DemoLocalization._internal();

  factory DemoLocalization() {
    return _singleton;
  }

  DemoLocalization._internal();



  //DemoLocalization._internal(this._localeDefault, this.appRefreshState) {_locale = _localeDefault;}

  //DemoLocalization(this._localeDefault, this.appRefreshState) {_locale = _localeDefault;}

  late Function _appRefreshState;
  late Locale _localeDefault;
  late Locale _locale;


  void init(Locale localeDefault, Function appRefreshState)
  {
    _locale = localeDefault;
    _localeDefault = localeDefault;
    _appRefreshState = appRefreshState;
  }

  final String SHAREDPREFS_LANGUAGE_CODE = 'languageCode';

  static DemoLocalization? of(BuildContext context) {
    return Localizations.of<DemoLocalization>(context, DemoLocalization);
  }

  Future<void> setLocale(Locale value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(SHAREDPREFS_LANGUAGE_CODE, value.toLanguageTag());

    _locale = value;
    _appRefreshState();
  }

  Locale getLocale() {
    return _locale;
  }

  Map<String, Map<dynamic, dynamic>> _localizedValues = {};
  List<String> supportedLangs = ['cz', 'en'];

  Future<void> load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _locale = Locale.fromSubtags(languageCode: prefs.getString(SHAREDPREFS_LANGUAGE_CODE) ?? _localeDefault.toLanguageTag());

    if (kIsWeb) {
      for (String langAsset in supportedLangs) {
        final response = await http.get(Uri.parse('assets/lang/$langAsset.json'),
          // NB: you don't need to fill headers field
          headers: {
            'Content-Type': 'application/json'
            // 'application/x-www-form-urlencoded' or whatever you need
          },
          /*body: {
          'api_token': '768ef1810185cd6562478f61d2',
          'product_id': '100',
          'quantity': '1',
        },*/
        );

        if (response.statusCode == 200) {
          //print(response.body);
          _localizedValues[langAsset] = json.decode(utf8.decode(response.bodyBytes)).map((key, value) => MapEntry(key, value.toString()));
        } else {
          //print("Error ${response.statusCode}: ${response.body}");
          supportedLangs.remove(langAsset);
        }
      }

    } else {
      try {
        final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
        // This returns a List<String> with all your images
        final imageAssetsList = assetManifest.listAssets().where((string) => string.startsWith("assets/lang/")).toList();

        for (var fileOrDir in imageAssetsList) {
          String lang = fileOrDir.substring(fileOrDir.lastIndexOf('/')+1, fileOrDir.lastIndexOf('.'));
          //print(lang);
          //print(fileOrDir);
          String data = await rootBundle.loadString(fileOrDir);
          //print(data);
          _localizedValues[lang] = json.decode(data);
        }
      } catch (e) {
        // If encountering an error, return 0
      }
      /*try {
        final file = await _localFile;

        // Read the file
        final contents = await file.readAsString();

        return int.parse(contents);
      } catch (e) {
        // If encountering an error, return 0
        return 0;
      }*/
    }
    // do search for files of langs and load of them
    //String jsonStringValues = await rootBundle.loadString('lib/lang/${_locale.languageCode}.json');
    //Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    //_localizedValues = mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  String translate(String key) {
    if (_localizedValues[_locale.toLanguageTag()] != null) {
      return _localizedValues[_locale.toLanguageTag()]?[key];
    }
    return "<$key>";
  }

  bool isSupported(Locale locale) {
    return supportedLangs.contains(locale.languageCode);// do dynamic on listed file
  }

  List<String> getSupported() {
    return supportedLangs;// do dynamic on listed file
  }
}
