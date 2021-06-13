import 'package:bakirdal_final/screens/SplashScreen/splahScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


Future<void> main() async {

  // Firebase'i Kur
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(ShopApp());
}


class ShopApp extends StatefulWidget {
  @override
  _ShopAppState createState() => _ShopAppState();
}

class _ShopAppState extends State<ShopApp> {


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red
      ),
      home: SplashScreen(),
    );
  }

}
