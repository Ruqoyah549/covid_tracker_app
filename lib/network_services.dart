import 'dart:convert';

import 'package:covid_tracker_app/components/toast_message.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NetworkServices extends ChangeNotifier {
  Map<String, String> headers = {
    'x-rapidapi-host': 'coronavirus-monitor.p.rapidapi.com',
    'x-rapidapi-key': 'd5dc61d7c7msh5025f1f1b1c08f5p13d027jsnda0b7e3bceb5',
  };

  final worldStatUrl =
      'https://coronavirus-monitor.p.rapidapi.com/coronavirus/worldstat.php';

  final nigeriaUrl =
      'https://coronavirus-monitor.p.rapidapi.com/coronavirus/latest_stat_by_country.php?country=nigeria';

  final allCountryUrl =
      'https://coronavirus-monitor.p.rapidapi.com/coronavirus/cases_by_country.php';

  bool _isFetchingWorld = true;
  bool _isFetchingNigeria = true;
  bool _isFetchingAllCountry = true;
  bool _isDoneFetching = true;

  bool get fetching {
    if (_isFetchingWorld && _isFetchingNigeria) {
      _isDoneFetching = true;
    } else {
      _isDoneFetching = false;
    }
    return _isDoneFetching;
  }

  bool get fetchingCountry => _isFetchingAllCountry;

  List _allCountryData;
  Map _nigeriaData;
  Map _worldData;

  List get allCountryData => _allCountryData;
  Map get allNigeriaData => _nigeriaData;
  Map get allWorldData => _worldData;

  void _setAllCountryData(value) {
    _allCountryData = value;
    notifyListeners();
  }

  void _setAllNigeriaData(value) {
    _nigeriaData = value;
    notifyListeners();
  }

  void _setAllWorldData(value) {
    _worldData = value;
    notifyListeners();
  }

  getWorldStat() async {
    try {
      Map worldData;
      await http.get(worldStatUrl, headers: headers).then((res) {
        if (res.statusCode == 200) {
          worldData = json.decode(res.body);
          _setAllWorldData(worldData);
        }
        _isFetchingAllCountry = false;
        notifyListeners();
      });
    } catch (e) {
      ToastMessage.toast('Failed to load from Internet');
    }
  }

  getNigeriaStat() async {
    try {
      Map nigeriaData;
      await http.get(nigeriaUrl, headers: headers).then((res) {
        if (res.statusCode == 200) {
          var data = json.decode(res.body);
          nigeriaData = data['latest_stat_by_country'][0];
          _setAllNigeriaData(nigeriaData);
        }
        _isFetchingNigeria = false;
        notifyListeners();
      });
    } catch (e) {
//      ToastMessage.toast('Failed to load from Internet');
    }
  }

  getAllCountry() async {
    try {
      List countryData;
      await http.get(allCountryUrl, headers: headers).then((res) {
        if (res.statusCode == 200) {
          var data = json.decode(res.body);
          countryData = data['countries_stat'];
          countryData.removeAt(0);
          _setAllCountryData(countryData);
        }
        _isFetchingAllCountry = false;
        notifyListeners();
      });
    } catch (e) {
      ToastMessage.toast('Failed to load from Internet');
    }
  }
}
