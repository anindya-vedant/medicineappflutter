import 'package:flutter/material.dart';
import 'package:medicineapp/login.dart';

void main() {
  runApp(MaterialApp(
    home: LandingPage(),
    theme: ThemeData(fontFamily: 'Lexend'),
  ));
}

class LandingPage extends StatelessWidget {
  const LandingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

                                                                                // created a landing page something that loads up as soon as the app is loaded
                                                                                // this page navigates to the login page
    return SafeArea(
      child: Container(
        child: Scaffold(
          body: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 150.0, 15.0, 0.0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      "Medico",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 40.0,
                      ),
                    ),
                    SizedBox(height: 10.0),
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
                          TextButton(
                              child: Text(
                                "Log In",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                );
                              })
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
