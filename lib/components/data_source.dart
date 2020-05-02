import 'package:flutter/material.dart';

class DataSource extends StatelessWidget {
  final List data;
  final String totalCases;
  final String totalDeaths;
  final String totalRecovered;
  final String activeCases;

  DataSource(
      {this.data,
      this.totalCases,
      this.totalDeaths,
      this.activeCases,
      this.totalRecovered});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 10.0),
      child: GridView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 2),
        children: <Widget>[
          StatusPanel(
            title: 'Total Cases',
            panelColor: Colors.white,
            textColor: Colors.yellow[800],
            count: totalCases ?? '',
          ),
          StatusPanel(
            title: 'Active Cases',
            panelColor: Colors.white,
            textColor: Colors.blue[800],
            count: activeCases ?? '',
          ),
          StatusPanel(
            title: 'Total Recovered',
            panelColor: Colors.white,
            textColor: Colors.green[800],
            count: totalRecovered,
          ),
          StatusPanel(
            title: 'Total Deaths',
            panelColor: Colors.white,
            textColor: Colors.red[800],
            count: totalDeaths,
          ),
        ],
      ),
    );
  }
}

class StatusPanel extends StatelessWidget {
  final Color panelColor;
  final Color textColor;
  final String title;
  final String count;

  const StatusPanel(
      {Key key, this.panelColor, this.textColor, this.title, this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: panelColor,
      ),
      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      height: 60,
      width: width / 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w400, fontSize: 15, color: textColor),
          ),
          Text(
            count ?? '',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
          )
        ],
      ),
    );
  }
}
