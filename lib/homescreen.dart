import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicineapp/cart.dart';
import 'package:medicineapp/map.dart';
import 'package:medicineapp/medicinepage.dart';

class HomeScreen extends StatefulWidget {
  final bool hasOrdered; //this is a boolean that is going to be used to display the map page if the user decides to order something
  const HomeScreen({Key key, this.hasOrdered = false}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CollectionReference
      _medicine = //Creating an instance of a Firebase collection that is used to store data of medicine
      Firestore.instance.collection('medicine');

  final CollectionReference _usercart = Firestore.instance.collection(
      'cart'); //Creating an instance of a Firebase collection to simulate a cart of a user

  final FirebaseAuth auth = FirebaseAuth.instance; //Firebase Auth instance

  String uid;

  Future _addToCart(_pid, _mname, _mprice) async {
    final FirebaseUser user = await auth.currentUser();
    uid = user.uid;
    return _usercart
        .document(uid)
        .collection('cart')
        .document(_pid)
        .setData({"name": _mname, "price": _mprice});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                left: 20.0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(20.0, 50.0, 10.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Hi,",
                            style: TextStyle(
                              fontSize: 30.0,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            " User",
                            style: TextStyle(
                              fontSize: 30.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 190.0,
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.black,
                              size: 19,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CartPage(userid: uid)),
                              );
                            },
                          ),
                          (widget.hasOrdered)?IconButton(                       //If the user has an active order then display the map button
                            icon: Icon(
                              Icons.map_rounded,
                              color: Colors.black,
                              size: 19,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MapPage()),
                              );
                            },
                          ):Container(),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 140.0,
                left: 19.0,
                child: Container(
                  width: 375.0,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                    child: TextField(
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        hintText: "Search for medicine",
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 270.0,
                left: 40.0,
                child: Container(
                  alignment: Alignment.bottomLeft,
                  width: 330.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: EdgeInsets.fromLTRB(43.0, 25.0, 0.0, 0.0),
                  child: Container(
                    child: Column(
                      children: [
                        Text(
                          "We will deliver you medicines",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height:40.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue[600],
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          width: 105.0,
                          height: 45.0,
                          child: Center(
                            child: Text(
                              "Catalog",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10.0, 470.0, 10.0, 0.0),
                child: FutureBuilder<QuerySnapshot>(
                                                                                //Using FutureBuilder (since the product list is static) to build a list view
                    future: _medicine.getDocuments(),
                                                                                //of the medicine list with their price and a add to cart button
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                                                                                //In case the firebase query fails then display the error
                        return Scaffold(
                          body: Center(
                            child: Text("Error: ${snapshot.error}"),
                          ),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                                                                                //In case the firebase query goes through then return a gridview
                        return GridView(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.60,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 10),
                          padding: EdgeInsets.all(20),
                          scrollDirection: Axis.vertical,
                          children: snapshot.data.documents.map((document) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MedicineDesc(
                                            medicineid: document.documentID)));
                              },
                              child: Container(
                                padding:
                                    EdgeInsets.fromLTRB(10.0, 12.5, 20.0, 10.0),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple[50],
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                height: 20.0,
                                margin: EdgeInsets.symmetric(
                                  vertical: 12.0,
                                  horizontal: 18.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(
                                      "${document.data['image']}",
                                      scale: 10.0,
                                    ),
                                    SizedBox(height: 30.0),
                                    Text(
                                      "${document.data['name']}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                          fontFamily: "Lexend"),
                                    ),
                                    SizedBox(
                                      height: 7.0,
                                    ),
                                    Text(
                                      "${document.data['type']} \u2022 ${document.data['stock']} tablets",
                                      style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 11.0,
                                          fontFamily: "Lexend"),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Text(
                                      "Rs. ${document.data['price']}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Lexend"),
                                    ),

                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }

                      return Scaffold(
                        body: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
