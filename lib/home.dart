import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_icons/flutter_icons.dart';

import './Pages/store_page.dart';
import './Pages/cart_page.dart';
import './Pages/catagory_page.dart';
import './Pages/offers_page.dart';
import 'Pages/cart_page.dart';
import 'Pages/offers_page.dart';

class Home extends StatefulWidget {
  final cart = 10;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey _bottomNavigationKey = GlobalKey();
  int _currentIndex = 0;

  List<Widget> _tabPages = <Widget>[
    StorePage(),
    OffersPage(),
    CatagoryPage(),
    CartPage(),
  ];

  var _navTabs;

  @override
  initState() {
    _navTabs = <Widget>[
      Icon(
        Icons.store,
        size: 30,
      ),
      Icon(
        Icons.local_offer,
        size: 30,
      ),
      Icon(
        Icons.receipt,
        size: 30,
      ),
      if (widget.cart == 0)
        Icon(
          Icons.shopping_cart,
          size: 30,
        ),
      if (widget.cart > 0)
        Stack(
          children: [
            Icon(
              Icons.shopping_cart,
              size: 30,
            ),
            Positioned(
              right: 0,
              child: CircleAvatar(
                minRadius: 8,
                backgroundColor: Colors.redAccent,
                child: Text(
                  widget.cart.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            )
          ],
        ),
    ];
    super.initState();
  }

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sell Shop Store',
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            Row(
              children: [
                Icon(Icons.location_on),
                Text(
                  'Hyderbad',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            )
          ],
        ),
        leading: ClipOval(
          child: Image.network(
            'https://cdn.iconscout.com/icon/free/png-512/face-1659511-1410033.png',
            fit: BoxFit.cover,
            height: 50,
            width: 50,
          ),
        ),
        actions: <Widget>[
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
      body: _tabPages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        items: _navTabs,
        index: _currentIndex,
        height: 50.0,
        color: Theme.of(context).accentColor,
        buttonBackgroundColor: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).canvasColor,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        onTap: (int index) => setState(() {
          _currentIndex = index;
        }),
      ),
    );
  }
}
