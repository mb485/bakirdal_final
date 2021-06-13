import 'package:bakirdal_final/screens/BottomNavBar/BottomNavBar.dart';
import 'package:bakirdal_final/screens/Register/registerPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {

    // WillPopScope : Telefondan Geri Tuşuna basıldığında önceki sayfaya gitmesini engeller
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              centerTitle: true,
              title: Text("Giriş Yap"),
              leading: Container(),
            ),
            body: !_loading
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          child: Image.asset("assets/images/logo.png"),
                        ),
                        SizedBox(height: 50),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Email form
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: TextFormField(
                                  onSaved: (value) {
                                    _email = value;
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Bu Alanı Doldurun';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: "Email Adresini Giriniz",
                                    fillColor: Colors.white,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),

                              // Parola form
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: TextFormField(
                                  obscureText: true,
                                  onSaved: (value) {
                                    _password = value;
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Bu Alanı Doldurun';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: "Parola Giriniz",
                                    fillColor: Colors.white,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),

                              ElevatedButton(
                                onPressed: () => login(),
                                child: Text("Giriş Yap"),
                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.green)),
                              ),
                              SizedBox(height: 30),

                              TextButton(
                                onPressed: () => {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => RegisterPage(), fullscreenDialog: true))
                                },
                                child: Text("Hesabınız Yoksa Kayıt Olun"),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  )));
  }

  Future<void> login() async {

    // Form'u doğrula ve Firebase'e Giriş Yap
    FirebaseAuth auth = FirebaseAuth.instance;

    if (_formKey.currentState.validate()) {

      _formKey.currentState.save();

      setState(() {
        _loading = true;
      });


      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(email: _email, password: _password);

        if(userCredential.user != null) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=>BottomNavBar(userCredential.user))
          );
        }

      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      } catch (e) {
        print(e);
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }

  }



}
