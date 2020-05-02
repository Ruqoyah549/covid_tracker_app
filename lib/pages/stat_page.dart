import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:covid_tracker_app/components/data_panel.dart';
import 'package:covid_tracker_app/components/my_piechart.dart';
import 'package:covid_tracker_app/network_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StatPage extends StatefulWidget {
  @override
  _StatPageState createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {
  String pieChartTitle = 'Global 🌍';

  bool isGlobal = true;
  bool isCountry = false;

  Map<String, double> worldMap = Map();
  Map<String, double> myCountryMap = Map();

  NetworkServices services = NetworkServices();

  Map worldData;
  Map nigeriaData;

  Connectivity connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> subscription;
  String networkState;

  void checkConnectivity() async {
    // subscribe to connectivity change
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      var conn = getConnectionValue(result);
      if (mounted) {
        setState(() {
          networkState = conn;
        });
      }
    });
  }

  // Method to convert connectivity to a string value;
  String getConnectionValue(var connectivityResult) {
    String status = '';
    switch (connectivityResult) {
      case ConnectivityResult.mobile:
        status = 'mobile';
        break;
      case ConnectivityResult.wifi:
        status = 'wifi';
        break;
      case ConnectivityResult.none:
        status = 'none';
        break;
      default:
        status = 'none';
        break;
    }
    return status;
  }

  _removeComma(String withComma) {
    if (withComma != null && withComma.isNotEmpty) {
      List<String> stringList = withComma.split(',');
      String withoutComma = stringList.join();

      return double.parse(withoutComma);
    }
  }

  _dateToString(String date) {
    if (date != null && date.isNotEmpty) {
      return DateFormat.yMMMMEEEEd("en_US").format(DateTime.parse(date));
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.of(context).size.width / 2) - 25;
    final data = Provider.of<NetworkServices>(context);

    data.getWorldStat();
    worldData = data.allWorldData;

    if (worldData != null) {
      worldMap.putIfAbsent(
          "Active Cases", () => _removeComma(worldData['active_cases']));
      worldMap.putIfAbsent(
          "Total Recovered", () => _removeComma(worldData['total_recovered']));
      worldMap.putIfAbsent(
          "Total Deaths", () => _removeComma(worldData['total_deaths']));
    }

    data.getNigeriaStat();
    nigeriaData = data.allNigeriaData;

    if (nigeriaData != null) {
      myCountryMap.putIfAbsent(
          "Active Cases", () => _removeComma(nigeriaData['active_cases']));
      myCountryMap.putIfAbsent("Total Recovered",
          () => _removeComma(nigeriaData['total_recovered']));
      myCountryMap.putIfAbsent(
          "Total Deaths", () => _removeComma(nigeriaData['total_deaths']));
    }

    return Scaffold(
      body: SafeArea(
        child: Builder(builder: (_) {
          if (networkState == 'none') {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    image: AssetImage('assets/images/loadingg.png'),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Check your Internet Connection!!!',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return data.fetching && worldData == null && nigeriaData == null
              ? Center(child: CircularProgressIndicator())
              : ListView(
                  children: <Widget>[
                    Container(
                      padding:
                          EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Color(0xff503CAA),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25.0),
                          bottomRight: Radius.circular(25.0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Statistics',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30.0,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 45.0,
                            padding: EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: Color(0xff7F6FC8),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isGlobal = true;
                                      isCountry = false;
                                      pieChartTitle = 'Global 🌍';
                                    });
                                  },
                                  child: Container(
                                    width: width,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      color: isGlobal
                                          ? Colors.white
                                          : Color(0xff7F6FC8),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20.0),
                                        bottomLeft: Radius.circular(20.0),
                                        bottomRight: isGlobal
                                            ? Radius.circular(20)
                                            : Radius.circular(0),
                                        topRight: isGlobal
                                            ? Radius.circular(20)
                                            : Radius.circular(0),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Global 🌍',
                                        style: TextStyle(
                                          letterSpacing: 1.0,
                                          fontSize: 18.0,
                                          color: isGlobal
                                              ? Color(0xff503CAA)
                                              : Colors.white,
                                          fontWeight: isGlobal
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isCountry = true;
                                      isGlobal = false;
                                      pieChartTitle = 'Nigeria 💚';
                                    });
                                  },
                                  child: Container(
                                    width: width,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      color: isCountry
                                          ? Colors.white
                                          : Color(0xff7F6FC8),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20.0),
                                        bottomRight: Radius.circular(20.0),
                                        bottomLeft: isCountry
                                            ? Radius.circular(20)
                                            : Radius.circular(0),
                                        topLeft: isCountry
                                            ? Radius.circular(20)
                                            : Radius.circular(0),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Nigeria 💚',
                                        style: TextStyle(
                                          letterSpacing: 1.0,
                                          fontSize: 18.0,
                                          color: isCountry
                                              ? Color(0xff503CAA)
                                              : Colors.white,
                                          fontWeight: isCountry
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30.0),
                          Center(
                            child: Text(
                              isGlobal &&
                                      worldData != null &&
                                      nigeriaData != null
                                  ? _dateToString(
                                      worldData['statistic_taken_at'])
                                  : _dateToString(nigeriaData['record_date']) ??
                                      '',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          isGlobal && worldData != null && nigeriaData != null
                              ? DataPanel(
                                  data: worldData,
                                )
                              : DataPanel(
                                  data: nigeriaData,
                                ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Pie Chart - $pieChartTitle',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    isGlobal && worldData != null && nigeriaData != null
                        ? MyPieChart(worldMap)
                        : MyPieChart(myCountryMap),
                  ],
                );
        }),
      ),
    );
  }
}
