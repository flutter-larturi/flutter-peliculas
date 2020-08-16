// Dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Pages
import 'package:peliculas/src/pages/home_page.dart';
import 'package:peliculas/src/pages/pelicula_detalle.dart';
import 'package:peliculas/src/pages/actor_detalle.dart';
 


void main(){
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
       [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
       .then((_){
           runApp(MyApp());
       }
    );
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue, 
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(elevation: 0.0, color: Colors.black12),
        inputDecorationTheme: InputDecorationTheme(border: UnderlineInputBorder())
      ),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(brightness: Brightness.dark),
      title: 'Peliculas',
      initialRoute: '/',
      routes: {
        '/'         :   (BuildContext context) => HomePage(),
        'detalle'   :   (BuildContext context) => PeliculaDetalle(),
        'actor'     :   (BuildContext context) => ActorDetelle(),
      },
    );
  }
}