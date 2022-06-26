import 'package:colombo_rocco/screens/calendarpage.dart';
import 'package:colombo_rocco/screens/homepage.dart';
import 'package:colombo_rocco/screens/notepage.dart';
import 'package:colombo_rocco/screens/prediction.dart';
import 'package:colombo_rocco/screens/profilepage.dart';
import 'package:colombo_rocco/screens/register.dart';
import 'package:colombo_rocco/screens/relation.dart';
import 'package:flutter/material.dart';
import 'package:colombo_rocco/screens/login.dart';
import 'package:provider/provider.dart';
import 'package:colombo_rocco/database/database.dart';
import 'package:colombo_rocco/repository/databaseRepository.dart';

// We modified the main
Future<void> main() async {
  //This is a special method that use WidgetFlutterBinding to interact with the Flutter engine.
  //This is needed when you need to interact with the native core of the app.
  //Here, we need it since when need to initialize the DB before running the app.
  WidgetsFlutterBinding.ensureInitialized();

  //This opens the database.
  final AppDatabase database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  //This creates a new DatabaseRepository from the AppDatabase instance just initialized
  final databaseRepository = DatabaseRepository(database: database);

  //Here, we run the app and we provide to the whole widget tree the instance of the DatabaseRepository.
  //That instance will be then shared through the platform and will be unique.
  runApp(ChangeNotifierProvider<DatabaseRepository>(
    create: (context) => databaseRepository,
    child: const MyApp(),
  ));
} //main

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //This specifies the app entrypoint
      initialRoute: '/login/',
      //This maps names to the set of routes within the app
      routes: {
        '/login/': (context) => const MyLogin(),
        '/homepage/': (context) => HomePage(),
        '/profilepage/': (context) => ProfilePage(),
        '/notepage/': (context) => NotePage(),
        '/calendarpage/': (context) => const calendarPage(),
        '/relation/': (context) => RelationPage(),
        '/prediction/': (context) => PredictionPage(),
        '/register/': (context) => const MyRegister(),
      },
    );
  } //build
} //MyApp
