import 'dart:math';

import 'package:bakirdal_final/screens/Login/loginPage.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  // Açılış Ekranında Uygulama Logosunu Döndermek için animasyon kullanıldı
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.forward();

    // 3 sn bekledikten sonra giriş sayfasına yönlendir
    Future.delayed(Duration(seconds: 3)).then((value) => {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context)=>LoginPage())
      )
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
         width: MediaQuery.of(context).size.width,
         height: MediaQuery.of(context).size.height,
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             AnimatedBuilder(
               animation: _animationController.view,
               builder: (context, child) {
                 return Transform.rotate(angle: _animationController.value * 2 * pi, child: child);
               },
               child: Container(
                 width: 150,
                 height: 150,
                 child: Image.asset("assets/images/logo.png"),
               ),
             ),
             SizedBox(height: 200),
             CircularProgressIndicator(),
             SizedBox(height: 20),
             Text("Lütfen Bekleyin...")
           ],
      ),
    ));
  }
}
