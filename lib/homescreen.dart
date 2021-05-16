import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicineapp/cart.dart';
import 'package:medicineapp/map.dart';

class HomeScreen extends StatefulWidget {
  final bool hasOrdered;                                                            //this is a boolean that is going to be used to display the map page if the user decides to order something
  const HomeScreen({Key key, this.hasOrdered=false}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CollectionReference _medicine =                                             //Creating an instance of a Firebase collection that is used to store data of medicine
      Firestore.instance.collection('medicine');

  final CollectionReference _usercart = Firestore.instance.collection('cart');     //Creating an instance of a Firebase collection to simulate a cart of a user

  final FirebaseAuth auth = FirebaseAuth.instance;                                 //Firebase Auth instance

  String _productid;                                                               //Variables to fetch ProductId, Medicine Name, Price of the medicine and Firebase User ID
  String _medicinename;
  int _price;
  String uid;

  Future _addToCart(_pid, _mname, _mprice) async {                                //this function is used to create a collection respective to user id to add and/or delete products from it (A cart)
    final FirebaseUser user = await auth.currentUser();
    uid = user.uid;
    return _usercart
        .document(uid)
        .collection('cart')
        .document(_pid)
        .setData({"name": _mname, "price": _mprice});
  }

  final SnackBar _snackBar =                                                      //SnackBar to be displayed if a medicine if added to the cart
      SnackBar(content: Text("Medicine added to the cart"));


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Colors.green[200],
            Colors.lightBlue[100],
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(20.0, 50.0, 10.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Welcome User",
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
                    Stack(
                      children: [
                        Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35.0),
                          ),
                          child: SizedBox(
                            width: 35,
                            height: 35,
                            child: IconButton(
                              icon: Icon(
                                Icons.shopping_cart_outlined,
                                color: Colors.black,
                                size: 19,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CartPage(userid: uid)),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10.0, 150.0, 10.0, 0.0),
                child: FutureBuilder<QuerySnapshot>(                                //Using FutureBuilder (and not Stream Builder since the product list is static) to build a list view
                    future: _medicine.getDocuments(),                               //of the medicine list with their price and a add to cart button
                    // ignore: missing_return
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {                                      //In case the firebase query fails then display the error
                        return Scaffold(
                          body: Center(
                            child: Text("Error: ${snapshot.error}"),
                          ),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.done) {       //In case the firebase query goes through then return the listview
                        return ListView(
                          children: snapshot.data.documents.map((document) {
                            return Container(
                              padding:
                                  EdgeInsets.fromLTRB(10.0, 12.5, 20.0, 10.0),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      Text(
                                        "\$ ${document.data['price']}",
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
                                  TextButton(
                                    child: Text(
                                      "ADD TO CART",
                                      style: TextStyle(
                                        color: Colors.black,
                                        letterSpacing: 2.0,
                                        fontSize: 9.0,
                                      ),
                                    ),
                                    onPressed: () async {                             //when added to cart, this function gets the medicine id and name and adds it to user's collection(cart)
                                      _productid = document.documentID;
                                      _medicinename = document.data['name'];
                                      _price = document.data['price'];
                                      await _addToCart(
                                          _productid, _medicinename, _price);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(_snackBar);
                                    },
                                  )
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      }
                    }),
              ),
              (widget.hasOrdered)?Positioned(                                         //if user has ordered something, then help them to navigate to map otherwise return empty container
                bottom: 100,
                left: 20,
                child:Container(
                  padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
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
                                MaterialPageRoute(builder: (context) => MapPage())
                            );
                          },
                          child: Text(
                            "Track your Order",
                            style: TextStyle(color: Colors.black),
                          )),
                    ],
                  ),
                )
              ): Container(),
            ],
          ),
        ),
      ),
    );
  }
}
