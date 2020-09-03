import 'package:flutter/material.dart';

class LocationScreen extends StatefulWidget {
  static const routeName = '/location';

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Function _changeLocation;

  @override
  void didChangeDependencies() {
    _changeLocation = ModalRoute.of(context).settings.arguments as Function;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(
              Icons.close,
              size: 30,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    'Set Location',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        color: Theme.of(context).primaryColor,
                        size: 30,
                      ),
                      Container(
                        height: 20,
                        width:
                            MediaQuery.of(context).size.width - (20 + 20 + 34),
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: Text(
                            'Search by locality, Pincode or Area...',
                            style: TextStyle(
                              color: Theme.of(context).primaryColorLight,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    _changeLocation();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.my_location,
                          color: Theme.of(context).accentColor,
                          size: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Use Current Location',
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 2,
                  color: Theme.of(context).accentColor,
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 10),
                //   child: Row(
                //     children: [
                //       Icon(
                //         Icons.add,
                //         color: Theme.of(context).accentColor,
                //         size: 30,
                //       ),
                //       SizedBox(
                //         width: 10,
                //       ),
                //       Text(
                //         'Add a new Address',
                //         style: TextStyle(
                //           color: Theme.of(context).accentColor,
                //           fontSize: 20,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // Divider(
                //   thickness: 2,
                //   color: Theme.of(context).accentColor,
                // ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
