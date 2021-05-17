import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:medicineapp/homescreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Initialized some variables to be used, described below:

  String
      _number; //This is the final number that is going to be used to authenticate phone number
  final _phonenumber =
      new TextEditingController(); //Text Editing Controller to fetch the number entered
  String _otp; // OTP variable that is going to be used to verify authentication
  final _otpcontroller = new TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth
      .instance; //Firebase Auth instance to check for authentication process

  FacebookLogin _facebookLogin =
      FacebookLogin(); //Facebook Login instance to be used for facebook login process

  FirebaseUser user; //Firebase User instance to fetch user details

  Future<bool> loginUser(String phoneno, BuildContext context) async {
    _auth.verifyPhoneNumber(
      //verifyPhoneNumber is a FirebaseAuth method that can be used to authenticate phone number, it enables to auto/manually verify phone number
      phoneNumber: phoneno,
      timeout: Duration(seconds: 120),
      verificationCompleted: (AuthCredential credential) async {
        AuthResult result = await _auth.signInWithCredential(
            credential); //attempting to auto verify the phone number, by auto verify, I mean to automatically detect the sent OTP
        Navigator.of(context)
            .pop(); //If sucessfully auto-verified, then pop the current context off of the navigator

        FirebaseUser user =
            result.user; //saving the fetched user details for future use

        if (user != null) {
          //if the result fetched from previous statement gives a valid user then navigate to home screen
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        } else {
          print("Error");
        }
      },
      verificationFailed: (AuthException exception) {
        print(exception.message);
      },
      codeSent: (String verificationId, [int forceResendingToken]) {
        //This method is exceuted as soon as the code is sent and has the logic of manually verifying the user. If the auto verification method does not work then this method will kick in
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text("Enter OTP"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _otpcontroller,
                      keyboardType: TextInputType.number,
                    )
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                      child: Text("Submit"),
                      onPressed: () async {
                        _otp = _otpcontroller.text.trim();
                        AuthCredential credential =
                            PhoneAuthProvider.getCredential(
                                verificationId: verificationId, smsCode: _otp);
                        AuthResult result =
                            await _auth.signInWithCredential(credential);
                        FirebaseUser user = result.user;
                        if (user != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        } else {
                          print("Error");
                        }
                      })
                ],
              );
            });
      },
    );
  }

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
    //Code for Scaffold of the page
    return Container(
      decoration: BoxDecoration(
        /*gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Colors.green[200],
            Colors.lightBlue[100],
          ],
        )*/
        color: Colors.green[200],
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 110.0, 30.0, 0.0),
            child: Column(
              children: <Widget>[
                Text(
                  "medico",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 7.0,
                        color: Colors.grey[700],
                        offset: Offset(1.0, 1.0),
                      ),
                    ], //shadows[]
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Container(
                  height: 100.0,
                  padding: EdgeInsets.fromLTRB(70.0, 10.0, 70.0, 10.0),
                  child: Text(
                    "enter your mobile number",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.0,
                ),
                Text(
                  "You will receive a 6 digit code to verify next",
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.grey[100],
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Container(
                  width: 350.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.fromLTRB(14.0, 2.0, 0.0, 0.0),
                  child: Row(
                    children: [
                      Text(
                        "+91",
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 19.0,
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      VerticalDivider(),
                      Expanded(
                          child: TextField(
                        textAlign: TextAlign.left,
                        controller: _phonenumber,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Phone number',
                          hintStyle:
                              TextStyle(fontSize: 19, color: Colors.grey[400]),
                          filled: true,
                          contentPadding: EdgeInsets.all(16),
                          fillColor: Colors.white,
                        ),
                      )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                GestureDetector(
                  onTap: (){
                    String country_code = "+91";
                    _number = country_code + _phonenumber.text;
                    print(_number);
                    loginUser(_number, context);
                  },
                  child: Container(
                    width: 100.0,
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 10.0),
                    decoration: BoxDecoration(
                      color: Colors.green[500],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: Row(
                        children: [
                          Text(
                            'Send OTP',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 5.0,),
                          Icon(Icons.arrow_right,
                          color: Colors.white,),
                        ],
                      ),
                    ),
                  ),
                ),
                /*TextButton(
                    child: Text(
                      "Get OTP",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          letterSpacing: 1.0),
                    ),
                    onPressed: () {
                      String country_code = "+91";
                      _number = country_code + _phonenumber.text;
                      print(_number);
                      loginUser(_number, context);
                    }),
                SizedBox(height: 70.0),*/
                /*TextButton(
                    child: Text(
                      "Login with Facebook",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    onPressed: () {
                      _handlelogin();
                    }),
                SizedBox(height: 50.0),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
