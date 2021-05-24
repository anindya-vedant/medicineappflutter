# Medico (Medicine booking app)

This is a dummy medicine booking mobile app that I developed while trying to learn Flutter. The frontend of the app is developed using Flutter whereas for the backend Firebase has been made use of.

Quick Overview -

*  Login options
*  Homescreen (composition/design)
*  Medicine Description page
*  Cart
*  Order Completion
*  Map
*  Known bugs/issues
*  Future updates

The landing page of the looks like this

<img src = 'https://firebasestorage.googleapis.com/v0/b/flutterfirebaselogin-ba439.appspot.com/o/Screenshot_20210519-112028.jpg?alt=media&token=eab78732-8b57-43db-bdad-efb0ccacbcf4' width = '250' height = '550'/>

*************

## Login Options

Currently the app has 2 login methods: -

* Via Phone Number
* Via Facebook

##### Via Phone Number

If the user selects the option to login via phone number it will redirect you to a page where it will ask for your phone number which when entered calls a Firebase authentication method which will automatically send a 6 digit OTP to the entered mobile number.

> _Note: - The firebase authentication method requires the entire phone, meaning it should include country code as well. Since I am based out of India, the current country I have set is +91, if you plan on using this app outside of India then you may need to change the country code in the method_


<img src = 'https://firebasestorage.googleapis.com/v0/b/flutterfirebaselogin-ba439.appspot.com/o/Screenshot_20210519-112033.jpg?alt=media&token=2379f439-e99f-454a-8acb-22191ae8edf6' width = '250' height = '550'/>


##### Via Facebook

If the user selects the option to login via Facebook, an embedded web browser shall open up which wil then ask the user for their Facebook credentials (only for login purposes).


**_Note: - There is no registration page for the app since it is not required. Even when the user opts for phone number login and enters a new phone number that is not present in the Firebase database, it automatically registers the new number._**


-----------------------

## Homescreen

For fetching and displaying data on the home screen `FutureBuilder()` has been used since the list of the medicine is static (as of now). Hence a grid view for each document in the firebase collection of the medicine list is opted for, as the look 

##### Composition

The details that comprise the home screen are some basic details. A welcome greeting, a search bar, a catalog and a cart button, and a list of the medicine that is fetched from Firebase.

##### Design

The design of the page is also a minimalistic design (see video below), and to better suit the display of the list of the medicine, a grid view has been utilized rather than a list view


https://user-images.githubusercontent.com/30995908/118767038-d8ff0c80-b89a-11eb-8db8-8e98460e88f7.mp4


----------------

## Medicine Description Page

Every container containing one document of the list of the medicine, in other words, every box that has medicine listed on the homes page has a `GestureDetector()` wrapped around it which gets triggerd by the `onTap()` feature. When tapped on, the app redirects to a page which has a set template (see image below) and fetches the data from the respective document of the medicine and displays it on the page.

<img src = 'https://firebasestorage.googleapis.com/v0/b/flutterfirebaselogin-ba439.appspot.com/o/Screenshot_20210520-150443.jpg?alt=media&token=586cd00f-e8ca-4ebb-8932-30a83be33ae5' width = '250' height = '550'/>

-------------

## Cart

The Medicine Description Page also has the add to cart feature on it which when pressed adds the medicine to the cart (collection of the firebase) specific to the user that is logged in. The way this bifurcation is achieved is by fetching the user id from the firebase and then creating collection based on the user id. 

When the _`Add to Cart`_ button is pressed, if successful (which is always), a snackbar appears at the bottom of the screen notifying the user of the same.

The Cart page is build using a `StreamBuilder()` thus enables real-time updation of the cart. The elements of the cart page have a delete function, which lets user remove an item from their cart.

For a working example of the cart feature please see the video below:

https://user-images.githubusercontent.com/30995908/119329045-6c24b180-bca2-11eb-9594-28c1bdc60418.mp4


-----------------

## Order Completion

Currently in a very crude state, the cart page has a button for completing the order. When tapped, it _pseudo_-completes (I know that that's not a word) the order and provides the user with a button to view the map.






## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
