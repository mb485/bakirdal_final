import 'package:bakirdal_final/screens/AddProductPage/addProductPage.dart';
import 'package:bakirdal_final/screens/CartPage/cartPage.dart';
import 'package:bakirdal_final/screens/HomePage/homePage.dart';
import 'package:bakirdal_final/screens/ProfilePage/profilePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  // Giriş Yaptıktan sonra Firebase kullanıcısnı al
  User firebaseUser;

  BottomNavBar(this.firebaseUser);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  //Bu sayfa uygulamanın altındaki menü(Ana Sayfa, Sepet, Profil) Widget'ları arasında geçiş yapmayı sağlar

  User user;

  // _currentIndex:0 ise Ana Sayfa
  // _currentIndex:1 ise Sepet
  // _currentIndex:2 ise Profil
  int _currentIndex = 0;

  List<Widget> _children;

  @override
  void initState() {
    super.initState();
    user = widget.firebaseUser;
    _children = [
      HomePage(),
      CartPage(),
      ProfilePage(user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Bakırdal Shop'),
          leading: SizedBox(),
          centerTitle: true,
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddProductPage())),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) => {
            // Menuden herhangi butona dokunduğunda _currentIndex i değiştir
            setState(() {
              _currentIndex = index;
            })
          },
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(icon: new Icon(Icons.home), label: "Ana Sayfa"),
            BottomNavigationBarItem(icon: new Icon(Icons.shopping_cart), label: "Sepet"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil")
          ],
        ),
        body: _children[_currentIndex],
      ),
    );
  }
}
