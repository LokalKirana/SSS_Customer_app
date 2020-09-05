import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:sss_customer_app/screens/contactus_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

import './homePages/store_page.dart';
import './homePages/cart_page.dart';
import './homePages/catagory_page.dart';
import './homePages/offers_page.dart';

import './user_location_screen.dart';

class HomeScreen extends StatefulWidget {
  final cart = 10;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey _bottomNavigationKey = GlobalKey();
  int _currentIndex = 0;
  bool _locationLoading = false;
  bool _isInit = true;
  double _longitude;
  double _latitude;
  String _location = 'Unknown';

  List<Widget> _tabPages = <Widget>[
    StorePage(),
    OffersPage(),
    CatagoryPage(),
    CartPage(),
  ];

  var _navTabs;

  Future<void> _getCurrentUserLocation() async {
    setState(() {
      _locationLoading = true;
    });
    final locData = await loc.Location().getLocation();
    final location = await getPlaceDetails(locData.latitude, locData.longitude);
    setState(() {
      _locationLoading = false;
      _location = location;
    });
  }

  Future<String> getPlaceDetails(
    double latitude,
    double longitude,
  ) async {
    final placeList =
        await Geolocator().placemarkFromCoordinates(latitude, longitude);
    final place = placeList[0];
    return place.locality;
  }

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _getCurrentUserLocation();
    }
    _isInit = false;
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
            _locationLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      strokeWidth: 2.0,
                    ),
                  )
                : GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(
                      LocationScreen.routeName,
                      arguments: _getCurrentUserLocation,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.location_on),
                        Text(
                          _location,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
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
          PopupMenuButton(
            color: Colors.purpleAccent,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text('Logout'),
              ),
              PopupMenuItem(
                value: 2,
                child: Text('About Us'),
              ),
            ],
            onSelected: (int menu) {
              if (menu == 1) {
                Provider.of<Auth>(context, listen: true).logout();
              } else if (menu == 2) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ContactScreenScreen()));
              }
            },
          ),
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
