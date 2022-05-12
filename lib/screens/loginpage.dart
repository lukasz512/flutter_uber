import 'package:cab_rider/brand_colors.dart';
import 'package:cab_rider/screens/registrationpage.dart';
import 'package:cab_rider/widgets/ProgressDialog.dart';
import 'package:cab_rider/widgets/TaxiButton.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'mainpage.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void showSnackBar(String title) {
    final snackbar = SnackBar(
        content: Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 15),
    ));
    scaffoldKey.currentState?.showSnackBar(snackbar);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  void login() async {

    // display please wait Dialog
    showDialog(barrierDismissible: false, context: context, builder: (BuildContext context) => ProgressDialog(status: 'Logging you in'));
    
    try {
      UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);

      // check if user exists
      if (user != null) {
        // verify user
        DatabaseReference userRef = FirebaseDatabase.instance.ref('users/${user.user?.uid}');

        userRef.once().then((snapshot) => {
              if (snapshot.snapshot.value != null) {Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false)}
            });
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showSnackBar(e.code);
    } catch (e) {
      Navigator.pop(context);
      showSnackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 70,
                  ),
                  const Image(
                    alignment: Alignment.center,
                    height: 100,
                    width: 100,
                    image: AssetImage('images/logo.png'),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    'Sign as a Rider',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              labelText: 'Email Address',
                              labelStyle: TextStyle(
                                fontSize: 14,
                              ),
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 10)),
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                fontSize: 14,
                              ),
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 10)),
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        TaxiButton("LOGIN", BrandColors.colorGreen, () async {
                          // check the Internet connection
                          var connectivityResult = await Connectivity().checkConnectivity();
                          if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
                            showSnackBar('No internet connection');
                            return;
                          }

                          // validate email
                          if (!emailController.text.contains('@')) {
                            showSnackBar('Enter valid email address');
                            return;
                          }

                          // validate password
                          if (passwordController.text.length < 8) {
                            showSnackBar('Enter valid password');
                            return;
                          }

                          // if validation OK
                          login();

                          // Login
                        })
                      ],
                    ),
                  ),
                  FlatButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(context, RegistrationPage.id, (route) => false);
                      },
                      child: const Text('Don\'t have an account, sign up here'))
                ],
              ),
            ),
          ),
        ));
  }
}
