import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:medicineapp/homescreen.dart';
import 'package:medicineapp/login.dart';

void main() {
  runApp(MaterialApp(
    home: LandingHomePage(),
    theme: ThemeData(fontFamily: 'Lexend'),
  ));
}

class LandingHomePage extends StatefulWidget {
  const LandingHomePage({Key key}) : super(key: key);

  @override
  _LandingHomePageState createState() => _LandingHomePageState();
}

class _LandingHomePageState extends State<LandingHomePage> {
  final FirebaseAuth _auth = FirebaseAuth
      .instance; //Firebase Auth instance to check for authentication process

  FacebookLogin _facebookLogin = FacebookLogin();

  Future _handlelogin() async {
    //function to handle user login from from facebook
    FacebookLoginResult _result = await _facebookLogin.logIn(['email']);
    switch (_result.status) {
      case FacebookLoginStatus.cancelledByUser:
        print("Cancelled By user");
        break;
      case FacebookLoginStatus.error:
        String error_message = FacebookLoginStatus.error.toString();
        print("Failed due to error : $error_message");
        break;
      case FacebookLoginStatus
          .loggedIn: //in case the Login Result Status (_result) is successful then we log in the user by using the _loginWithFacebook function
        await _loginWithFacebook(_result);
    }
  }

  Future _loginWithFacebook(FacebookLoginResult _result) async {
    //this function fetches the facebook accesstoken, provides it to Firebase and check for it authenticity
    FacebookAccessToken _accessToken = _result.accessToken;
    AuthCredential _credential =
        FacebookAuthProvider.getCredential(accessToken: _accessToken.token);
    var a = await _auth.signInWithCredential(_credential);
    FirebaseUser fbuser = a.user;
    if (fbuser != null) {
      //like we did with the phone number authentication, if the user is not null then redirect them to the Home Screen
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      print("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Scaffold(
          body: Container(
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 95.0, 15.0, 0.0),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          "medico",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[300],
                            fontSize: 40.0,
                          ),
                        ),
                        SizedBox(height: 40.0),
                        Text(
                          "get your medical needs met",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[200],
                            fontSize: 20.0,
                          ),
                        ),
                        Image.asset(
                          "images/home_screen.png",
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.height * 0.5,
                        ),
                        SizedBox(height: 10.0),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Your personal pharmacy",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Stack(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      child: Container(
                        height: 120.0,
                        padding: EdgeInsets.fromLTRB(130.0, 25.0, 70.0, 0.0),
                        width: 900.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.green[300],
                        ),
                        child: Text(
                          "Login with Number",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      child: GestureDetector(
                        onTap: (){
                          _handlelogin();
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(125.0, 15.0, 70.0, 22.0),
                          width: 412.0,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.white,
                          ),
                          child: Text(
                            "log in with Facebook",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
