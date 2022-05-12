import 'package:cab_rider/brand_colors.dart';
import 'package:cab_rider/screens/loginpage.dart';
import 'package:cab_rider/screens/mainpage.dart';
import 'package:cab_rider/widgets/ProgressDialog.dart';
import 'package:cab_rider/widgets/TaxiButton.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  static const String id = 'register';

  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  var fullNameController = TextEditingController();

  var phoneController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  void createUser() async {
    try {
      // display please wait Dialog
      showDialog(barrierDismissible: false, context: context, builder: (BuildContext context) => ProgressDialog(status: 'Registering you'));


      UserCredential user =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);

      // turn off dialog
      Navigator.pop(context);
      // check if user registration is successfull
      if (user != null) {
        DatabaseReference newUserRef = FirebaseDatabase.instance.ref('users/${user.user?.uid}');

        // Prepare data to be saved on users table
        Map userMap = {
          'fullname': fullNameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
        };

        newUserRef.set(userMap);

        // Take user to the main page
        Navigator.pushNamedAndRemoveUntil(context, LoginPage.id, (route) => false);
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
                    'Create a Rider\'s Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        // Full Name
                        TextField(
                          controller: fullNameController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              labelText: 'Full Name',
                              labelStyle: TextStyle(
                                fontSize: 14,
                              ),
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 10)),
                          style: const TextStyle(fontSize: 14),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        // Email Address
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

                        // Phone Number
                        TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              labelStyle: TextStyle(
                                fontSize: 14,
                              ),
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 10)),
                          style: const TextStyle(fontSize: 14),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        // Password
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                fontSize: 14,
                              ),
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 10)),
                          style: const TextStyle(fontSize: 14),
                        ),

                        const SizedBox(
                          height: 40,
                        ),

                        TaxiButton("REGISTER", BrandColors.colorGreen, () async {
                          // check the Internet connection
                          var connectivityResult = await Connectivity().checkConnectivity();
                          if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
                            showSnackBar('No internet connection');
                            return;
                          }
                          // name at least 4 chars
                          if (fullNameController.text.length < 3) {
                            showSnackBar('Please provide a valid Full Name (at least 4 characters)');
                            return;
                          }
                          // email validation
                          if (!emailController.text.contains('@')) {
                            showSnackBar('Please provide a valid Email');
                            return;
                          }
                          // phone validation
                          if (phoneController.text.length != 9) {
                            showSnackBar('Please provide a valid Phone Number (9 digits)');
                            return;
                          }
                          // password validation
                          if (passwordController.text.length < 8) {
                            showSnackBar('Please provide a better Password (at least 8 characters)');
                            return;
                          }

                          // if everything was correct - create user
                          createUser();
                        })
                      ],
                    ),
                  ),
                  FlatButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(context, LoginPage.id, (route) => false);
                      },
                      child: const Text('Already have a RIDER account? Log in'))
                ],
              ),
            ),
          ),
        ));
  }
}
