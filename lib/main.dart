import 'package:covid_tracker_app/network_services.dart';
import 'package:covid_tracker_app/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NetworkServices>(
      create: (context) => NetworkServices(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'COVID TRACKER APP',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          primaryColor: Colors.deepPurple,
          accentColor: Colors.deepPurple,
          inputDecorationTheme: InputDecorationTheme(
            hintStyle:
                Theme.of(context).textTheme.title.copyWith(color: Colors.white),
          ),
        ),
        home: HomeScreen(),
      ),
    );
  }
}
