import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicineapp/map.dart';

class CartPage extends StatefulWidget {
  final String
      userid; //Firebase User Id that is currently logged in, this will help in fetching the respective cart of the user

  const CartPage({Key key, this.userid}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  CollectionReference _usercart = Firestore.instance
      .collection('cart'); //fetching the cart collection of the user
  bool _hasOrdered =
      false; //to check for the order status of the user, currently set to false

  @override
  Widget build(BuildContext context) {
    //Building a scaffold with a listview to display the medicines present in the cart of the user logged in
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
        body: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20.0, 50.0, 10.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "User Cart",
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 7.0,
                              color: Colors.grey[700],
                              offset: Offset(1.0, 1.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10.0, 150.0, 10.0, 0.0),
                  child: StreamBuilder(
                      stream: _usercart
                          .document(widget.userid)
                          .collection('cart')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          //In case the firebase query fails then display the error
                          return Scaffold(
                            body: Center(
                              child: Text("Error: ${snapshot.error}"),
                            ),
                          );
                        }
                        /*if (snapshot.connectionState == ConnectionState.done) {
                          return Scaffold(
                            backgroundColor: Colors.transparent,
                            body: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        };*/

                        if (!snapshot.hasData) {
                          return Scaffold(
                            backgroundColor: Colors.transparent,
                            body: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        /*return ListView(
                          children: snapshot.data.documents.map<Widget>((document) {
                            Container(
                                padding: EdgeInsets.fromLTRB(
                                    10.0, 12.5, 20.0, 10.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                height: 100.0,
                                margin: EdgeInsets.symmetric(
                                  vertical: 12.0,
                                  horizontal: 18.0,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${document.data['name']}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20.0,
                                              fontFamily: "Lexend"),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 3.0,
                                    ),
                                  ],
                                ));
                          }).toList(),
                        );*/
                        else {
                          return new ListView.builder(
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot ds =
                                    snapshot.data.documents[index];
                                return Container(
                                    padding: EdgeInsets.fromLTRB(
                                        10.0, 12.5, 20.0, 10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    height: 75.0,
                                    margin: EdgeInsets.symmetric(
                                      vertical: 12.0,
                                      horizontal: 18.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${ds['name']}",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20.0,
                                                  fontFamily: "Lexend"),
                                            ),
                                            IconButton(
                                                icon:
                                                    Icon(Icons.delete_rounded),
                                                onPressed: () {
                                                      _usercart
                                                          .document(
                                                              widget.userid)
                                                          .collection('cart')
                                                          .document(
                                                              ds.documentID).delete();

                                                })
                                          ],
                                        ),
                                        SizedBox(
                                          height: 3.0,
                                        ),
                                      ],
                                    ));
                              });
                        }
                      }),
                  /*child: FutureBuilder<QuerySnapshot>(                             //Currently implemented with FutureBuilder (looking to implement StreamBuilder) a listview to display the cart list
                      future: _usercart
                          .document("${widget.userid}")
                          .collection("cart")
                          .getDocuments(),
                      // ignore: missing_return
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {                                  //display error if connection fails
                          return Scaffold(
                            body: Center(
                              child: Text("Error: ${snapshot.error}"),
                            ),
                          );
                        }

                        if (snapshot.connectionState == ConnectionState.done) {   //display the list if connection is established
                          return ListView(
                            children: snapshot.data.documents.map((document) {
                              return Column(
                                children: [
                                  Container(
                                      padding: EdgeInsets.fromLTRB(
                                          10.0, 12.5, 20.0, 10.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      height: 65.0,
                                      margin: EdgeInsets.symmetric(
                                        vertical: 12.0,
                                        horizontal: 18.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${document.data['name']}",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20.0,
                                                    fontFamily: "Lexend"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                ],
                              );
                            }).toList(),
                          );
                        }
                      })*/
                ),
                Positioned(
                    //Since a stack is implemented, using positioned to position a button to complete order
                    bottom: 100,
                    left: 20,
                    child: Row(
                      children: [
                        Container(
                          width: 190.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: Colors.white),
                          child: Center(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.done,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _hasOrdered = true;
                                      });
                                    },
                                    child: Text(
                                      "Complete your Order",
                                      style: TextStyle(color: Colors.black),
                                    )),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 12.0),
                        (_hasOrdered) //if order is completed then the user has the option to go to the map
                            ? Container(
                                padding:
                                    EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                width: 175.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: Colors.white),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.map_rounded,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MapPage()));
                                        },
                                        child: Text(
                                          "Track your Order",
                                          style: TextStyle(color: Colors.black),
                                        )),
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
