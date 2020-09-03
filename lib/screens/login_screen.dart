import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../providers/auth.dart';

import '../models/http_exception.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  final _phoneController = TextEditingController();

  final focusNode = FocusNode();

  Widget showInfoDialog(
          BuildContext context, String title, List<String> messagelines) =>
      AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              ...messagelines.map((msg) => Text(msg)).toList()
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );

  Future<void> submitPhone(BuildContext ctx) async {
    focusNode.unfocus();
    if (_phoneController.text.length != 0) {
      final phone = int.tryParse(_phoneController.text);
      if (phone != null && phone.toString().length == 10) {
        //user enters a valid phone numner. login process starts
        setState(() {
          _isLoading = true;
        });
        try {
          await Provider.of<Auth>(ctx, listen: false)
              .requestOtp(phone.toString());
          setState(() {
            _isLoading = false;
          });
          Toast.show('OTP sent', ctx,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        } on HttpException catch (error) {
          setState(() {
            _isLoading = false;
          });
          showDialog<void>(
            context: ctx,
            barrierDismissible: false,
            builder: (BuildContext context) => showInfoDialog(
              context,
              'Error Occured',
              [error.getErrorMessage],
            ),
          );
        } catch (e) {
          setState(() {
            _isLoading = false;
          });
          showDialog<void>(
            context: ctx,
            barrierDismissible: false,
            builder: (BuildContext context) => showInfoDialog(
              context,
              'Error Occured',
              ['Please Try Again in sometime!!!'],
            ),
          );
        }
      } else {
        // show alert when user enters an invalid mobile number
        showDialog<void>(
          context: ctx,
          barrierDismissible: false,
          builder: (BuildContext context) => showInfoDialog(
            context,
            'Invalid Mobile number',
            [
              'Not a valid phone number',
              'Key in your 10 digit mobile number without country code.'
            ],
          ),
        );
      }
    } else {
      // show alert when user enters no mobile number and taps on the sign in button
      showDialog<void>(
        context: ctx,
        barrierDismissible: false,
        builder: (BuildContext context) => showInfoDialog(
          context,
          'No Mobile',
          [
            'Could not find the mobile number',
            'Please enter the registered Mobile to signIn.'
          ],
        ),
      );
    }
    return Future.delayed(Duration(microseconds: 0));
  }

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    final _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              height: _screenHeight,
              width: _screenWidth,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FittedBox(
                      child: Image.asset(
                        'assets/img/logo.png',
                        height: 300,
                        width: 300,
                      ),
                      fit: BoxFit.cover,
                    ),
                    // Phone input box
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 40),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 20,
                            color: Theme.of(context).accentColor,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _phoneController,
                        style: TextStyle(
                          color: const Color(0xFF289261),
                        ),
                        decoration: InputDecoration(
                          labelText: 'mobile',
                          icon: const Icon(Icons.phone_android),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // SigIn Button
                    InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        submitPhone(context);
                      },
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        width: 150,
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Theme.of(context).accentColor,
                              Theme.of(context).primaryColor,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 5,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sign',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Text(
                              'In',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
