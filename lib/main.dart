import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './Pages/store_page.dart';
import './Pages/cart_page.dart';
import './Pages/catagory_page.dart';
import './Pages/offers_page.dart';

void main() async => {
      WidgetsFlutterBinding.ensureInitialized(),

      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp]), // To turn off landscape mode

      runApp(SSSCustomer())
    };

class SSSCustomer extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  Widget callPage(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return StorePage();
      case 1:
        return OffersPage();
      case 2:
        return CatagoryPage();
      case 3:
        return CartPage();
        break;
      default:
        return StorePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sell Shop Store'),
        leading: GestureDetector(
          onTap: () {/* Write listener code here */},
          child: Icon(
            Icons.account_circle, // add custom icons also
          ),
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.location_city,
                  size: 26.0,
                ),
              )),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.search,
                  size: 26.0,
                ),
              )),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(Icons.more_vert),
              )),
        ],
      ),
      //body: tabs[_currentIndex],
      body: callPage(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.store),
              title: Text('Store'),
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_offer),
              title: Text('Offers'),
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(Icons.category),
              title: Text('Category'),
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              title: Text('Cart'),
              backgroundColor: Colors.black),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
