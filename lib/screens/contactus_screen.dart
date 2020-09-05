import 'package:flutter/material.dart';

class ContactScreenScreen extends StatelessWidget {
  static final routeName = '/contact';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 30,
                  ),
                  Image.asset(
                    'assets/img/logo.png',
                    width: 100,
                    scale: 10,
                    fit: BoxFit.fitWidth,
                  ),
                  SizedBox(
                    width: 60,
                  ),
                  Text(
                    'Contact Us',
                    style: TextStyle(
                        fontSize: 30,
                        color: const Color(0xff006cf9),
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(
                thickness: 1,
              ),
              Container(
                  child: Text(
                      'Please let us know incase any error faced. We will get back to you soon.',
                      style: TextStyle(fontSize: 25, color: Colors.blue),
                      textAlign: TextAlign.center)),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    minLines: 10,
                    maxLines: 15,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: 'tell us more..',
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              RaisedButton(
                onPressed: () {},
                textColor: Colors.white,
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    gradient: LinearGradient(
                      colors: <Color>[
                        Color(0xFF0D47A1),
                        Color(0xFF1976D2),
                        Color(0xFF42A5F5),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: const Text('Submit', style: TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
