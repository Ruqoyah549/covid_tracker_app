import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:covid_tracker_app/components/data_source.dart';
import 'package:covid_tracker_app/network_services.dart';
import 'package:covid_tracker_app/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CountryPage extends StatefulWidget {
  @override
  _CountryPageState createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  List countryData;

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

  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<NetworkServices>(context);
    data.getAllCountry();
    countryData = data.allCountryData;
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: Search(countryData));
            },
          )
        ],
        title: Text('All Countries Stats'),
      ),
      body: Builder(builder: (_) {
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
        return data.fetchingCountry
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                scrollDirection: Axis.vertical,
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: countryData == null ? 0 : countryData.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ExpansionTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              '${countryData[index]['country_name']}',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              '${countryData[index]['cases']} Cases',
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          decoration: BoxDecoration(
                            color: Color(0xff503CAA),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0),
                            ),
                          ),
                          child: DataSource(
                            data: countryData,
                            totalCases: countryData[index]['cases'],
                            totalDeaths: countryData[index]['deaths'],
                            activeCases: countryData[index]['active_cases'],
                            totalRecovered: countryData[index]
                                ['total_recovered'],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
      }),
    );
  }
}
