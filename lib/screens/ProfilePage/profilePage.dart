import 'package:bakirdal_final/screens/SplashScreen/splahScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  User firebaseUser;

  ProfilePage(this.firebaseUser);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {




  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            child: Icon(
              Icons.person_pin,
              size: 200,
              color: Colors.pinkAccent,
            ),
            backgroundColor: Colors.white,
            radius: 100,
          ),
          SizedBox(height: 30),
          Text(
            widget.firebaseUser.email,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
          ),
          SizedBox(height: 10),
          Text(
            widget.firebaseUser.uid,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade800),
          ),
          SizedBox(height: 30),
          ElevatedButton(
              onPressed: () async => {
                await FirebaseAuth.instance.signOut(),
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=>SplashScreen())
                )
              },
              child: Text("Çıkış Yap")
          )
        ],
      ),
    );
  }
}
