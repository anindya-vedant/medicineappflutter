import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicineapp/cart.dart';

class MedicineDesc extends StatefulWidget {
  final String medicineid;

  const MedicineDesc({Key key, this.medicineid}) : super(key: key);

  @override
  _MedicineDescState createState() => _MedicineDescState();
}

class _MedicineDescState extends State<MedicineDesc> {
  final CollectionReference
      _medicine = //Creating an instance of a Firebase collection that is used to store data of medicine
      Firestore.instance.collection('medicine');

  final CollectionReference _usercart = Firestore.instance.collection('cart'); //Creating an instance of a Firebase collection to simulate a cart of a user

  final FirebaseAuth auth = FirebaseAuth.instance; //Firebase Auth instance

  String
      _productid; //Variables to fetch ProductId, Medicine Name, Price of the medicine and Firebase User ID
  String _medicinename;
  double _price;
  String uid;

  Future _addToCart(_pid, _mname, _mprice) async {
    //this function is used to create a collection respective to user id to add and/or delete products from it (A cart)
    final FirebaseUser user = await auth.currentUser();
    uid = user.uid;
    return _usercart
        .document(uid)
        .collection('cart')
        .document(_pid)
        .setData({"name": _mname, "price": _mprice});
  }

  final SnackBar
      _snackBar = //SnackBar to be displayed if a medicine if added to the cart
      SnackBar(content: Text("Medicine added to the cart"));

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple[600],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue[100],
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          actions: <Widget>[
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
                    builder: (context) =>
                    CartPage(userid: uid)));
              },
            )
          ],
        ),
        body: Stack(
          children: [
            Container(
              color: Colors.lightBlue[100],
              child: FutureBuilder(
                  //Using FutureBuilder (and not Stream Builder since the product list is static) to build a list view
                  future: _medicine.document(widget.medicineid).get(),
                  //of the medicine list with their price and a add to cart button
                  // ignore: missing_return
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
                      //In case the firebase query goes through then return the listview
                      Map<String, dynamic> documentData = snapshot.data.data;
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          Image.network(
                            "${documentData['image']}",
                            scale: 2.0,
                          ),
                          Container(
                            height: 395.0,
                            width: 95.0,
                            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: Colors.white,
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 10.0,
                                  left: 10.0,
                                  child: Text("${documentData['name']}",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Positioned(
                                  top: 55.0,
                                  left: 12.0,
                                  child: Row(
                                    children: [
                                      Text("${documentData['type']}",
                                          style: TextStyle(
                                            fontSize: 17.0,
                                            color: Colors.grey[600],
                                          )),
                                      SizedBox(
                                        width: 7.0,
                                      ),
                                      Text(
                                          "\u2022 ${documentData['stock']} in stock",
                                          style: TextStyle(
                                            fontSize: 17.0,
                                            color: Colors.grey[600],
                                          )),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 90.0,
                                  left: 10.0,
                                  child: Text(
                                    "\$ ${documentData['price']}",
                                    style: TextStyle(
                                      fontSize: 24.0,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 150.0,
                                  left: 10.0,
                                  child: Text(
                                    "Dosage Form",
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 150.0,
                                  left: 255.0,
                                  child: Text(
                                    "Active Substance",
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 170.0,
                                  left: 10.0,
                                  child: Text(
                                    "${documentData['dosage form']}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 170.0,
                                  left: 255.0,
                                  child: Text(
                                    "${documentData['name']}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 220.0,
                                  left: 10.0,
                                  child: Text(
                                    "Dosage",
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 220.0,
                                  left: 255.0,
                                  child: Text(
                                    "Manufacturer",
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 240.0,
                                  left: 10.0,
                                  child: Text(
                                    "${documentData['dosage']}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 240.0,
                                  left: 255.0,
                                  child: Text(
                                    "${documentData['manufacturer']}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 300.0,
                                  left: 10.0,
                                  child: GestureDetector(
                                    onTap: () async {
                                      _productid = widget.medicineid;
                                      _medicinename = documentData['name'];
                                      _price = documentData['price'];
                                      await _addToCart(
                                          _productid, _medicinename, _price);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(_snackBar);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      height: 65.0,
                                      width: 360.0,
                                      alignment: Alignment.centerLeft,
                                      child: Center(
                                        child: Text(
                                          "Add to Cart",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }

                    return Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
