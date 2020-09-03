import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

import '../providers/auth.dart';

import '../models/http_exception.dart';

class OtpConfirmScreen extends StatefulWidget {
  static const routeName = '/otp-confirm';
  @override
  _OtpConfirmScreenState createState() => _OtpConfirmScreenState();
}

class _OtpConfirmScreenState extends State<OtpConfirmScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  final int time = 60;
  AnimationController _controller;

  // Variables
  Size _screenSize;
  int _currentDigit;
  int _firstDigit;
  int _secondDigit;
  int _thirdDigit;
  int _fourthDigit;
  int _fifthDigit;
  int _sixthDigit;
  String _phone;

  Timer timer;
  int totalTimeInSeconds;
  bool _hideResendButton;

  bool didReadNotifications = false;
  int unReadNotificationsCount = 0;

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  String _deviceName;

  Future<Null> _startCountdown() async {
    setState(() {
      _hideResendButton = true;
      totalTimeInSeconds = time;
    });
    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);
  }

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData;

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    _deviceName = '${build.brand}: ${build.model}';
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    _deviceName = 'Apple - ${data.model}';
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  @override
  void initState() {
    totalTimeInSeconds = time;
    super.initState();
    initPlatformState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: time))
          ..addStatusListener((status) {
            if (status == AnimationStatus.dismissed) {
              setState(() {
                _hideResendButton = !_hideResendButton;
              });
            }
          });
    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);
    _startCountdown();
  }

  @override
  void didChangeDependencies() {
    _phone = Provider.of<Auth>(context).userPhone;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An error Occured'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Okay'),
          ),
        ],
      ),
    );
  }

  // Return OTP Screen Header
  get _screenHeader {
    final availableWidth = MediaQuery.of(context).size.width - (175 + 10);
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        FittedBox(
          child: Image.asset(
            'assets/img/logo.png',
            height: 175,
            width: 175,
          ),
          fit: BoxFit.cover,
        ),
        Column(
          children: [
            SizedBox(
              width: availableWidth,
              height: 40,
              child: FittedBox(
                fit: BoxFit.cover,
                child: Text(
                  'Mobile OTP',
                  style: TextStyle(
                    fontSize: 40,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: availableWidth,
              child: FittedBox(
                fit: BoxFit.cover,
                child: Text(
                  'Verification',
                  style: TextStyle(
                    fontSize: 40,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  // Return "OTP" input field
  get _getInputField {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _otpTextField(_firstDigit),
        _otpTextField(_secondDigit),
        _otpTextField(_thirdDigit),
        _otpTextField(_fourthDigit),
        _otpTextField(_fifthDigit),
        _otpTextField(_sixthDigit),
      ],
    );
  }

  // Returns "OTP" input part
  get _getInputPart {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _screenHeader,
          _getInputField,
          _hideResendButton ? _getTimerText : _getResendButton,
          _getOtpKeyboard,
          SizedBox(height: 5),
        ],
      ),
    );
  }

  // Returns "Timer" label
  get _getTimerText {
    return Container(
      height: 32,
      child: Offstage(
        offstage: !_hideResendButton,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.access_time,
              color: Theme.of(context).accentColor,
            ),
            SizedBox(
              width: 5.0,
            ),
            OtpTimer(_controller, 15.0, Theme.of(context).primaryColor)
          ],
        ),
      ),
    );
  }

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

  // Returns "Resend" button
  get _getResendButton {
    return InkWell(
      child: Container(
        height: 32,
        width: 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).accentColor,
            ],
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Resend ",
              style: TextStyle(color: Colors.black),
            ),
            Text(
              "OTP",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      onTap: () async {
        try {
          await Provider.of<Auth>(context, listen: false).requestOtp(_phone);
          _startCountdown();
          Toast.show('OTP sent', context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        } on HttpException catch (error) {
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => showInfoDialog(
              context,
              'Error Occured',
              [error.getErrorMessage],
            ),
          );
        } catch (e) {
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => showInfoDialog(
              context,
              'Error Occured',
              ['Please Try Again in sometime!!!'],
            ),
          );
        }
      },
    );
  }

  // Returns "Otp" keyboard
  get _getOtpKeyboard {
    return Container(
      height: _screenSize.width - 80,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _otpKeyboardInputButton(
                    label: "1",
                    onPressed: () {
                      _setCurrentDigit(1);
                    }),
                _otpKeyboardInputButton(
                    label: "2",
                    onPressed: () {
                      _setCurrentDigit(2);
                    }),
                _otpKeyboardInputButton(
                    label: "3",
                    onPressed: () {
                      _setCurrentDigit(3);
                    }),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _otpKeyboardInputButton(
                    label: "4",
                    onPressed: () {
                      _setCurrentDigit(4);
                    }),
                _otpKeyboardInputButton(
                    label: "5",
                    onPressed: () {
                      _setCurrentDigit(5);
                    }),
                _otpKeyboardInputButton(
                    label: "6",
                    onPressed: () {
                      _setCurrentDigit(6);
                    }),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _otpKeyboardInputButton(
                    label: "7",
                    onPressed: () {
                      _setCurrentDigit(7);
                    }),
                _otpKeyboardInputButton(
                    label: "8",
                    onPressed: () {
                      _setCurrentDigit(8);
                    }),
                _otpKeyboardInputButton(
                    label: "9",
                    onPressed: () {
                      _setCurrentDigit(9);
                    }),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  width: 80.0,
                ),
                _otpKeyboardInputButton(
                    label: "0",
                    onPressed: () {
                      _setCurrentDigit(0);
                    }),
                _otpKeyboardActionButton(
                    label: Icon(
                      Icons.backspace,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_sixthDigit != null) {
                          _sixthDigit = null;
                        } else if (_fifthDigit != null) {
                          _fifthDigit = null;
                        } else if (_fourthDigit != null) {
                          _fourthDigit = null;
                        } else if (_thirdDigit != null) {
                          _thirdDigit = null;
                        } else if (_secondDigit != null) {
                          _secondDigit = null;
                        } else if (_firstDigit != null) {
                          _firstDigit = null;
                        }
                      });
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;

    final screenChild = Container(
      width: _screenSize.width,
      child: _getInputPart,
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : screenChild,
    );
  }

  // Returns "Otp custom text field"
  Widget _otpTextField(int digit) {
    return Container(
      width: 35.0,
      height: 45.0,
      alignment: Alignment.center,
      child: Text(
        digit != null ? digit.toString() : "",
        style: TextStyle(
          fontSize: 30.0,
          color: Theme.of(context).accentColor,
        ),
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 2.0,
            color: digit == null
                ? Theme.of(context).primaryColor
                : Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }

  // Returns "Otp keyboard input Button"
  Widget _otpKeyboardInputButton({String label, VoidCallback onPressed}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Theme.of(context).accentColor,
        onTap: onPressed,
        child: Container(
          margin: const EdgeInsets.all(7),
          height: 80.0,
          width: 80.0,
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 35.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Returns "Otp keyboard action Button"
  _otpKeyboardActionButton({Widget label, VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(40.0),
      child: Container(
        height: 80.0,
        width: 80.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).canvasColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Theme.of(context).accentColor,
            ),
          ],
        ),
        child: Center(
          child: label,
        ),
      ),
    );
  }

  // Current digit
  Future<void> _setCurrentDigit(int i) async {
    setState(
      () {
        _currentDigit = i;
        if (_firstDigit == null) {
          _firstDigit = _currentDigit;
        } else if (_secondDigit == null) {
          _secondDigit = _currentDigit;
        } else if (_thirdDigit == null) {
          _thirdDigit = _currentDigit;
        } else if (_fourthDigit == null) {
          _fourthDigit = _currentDigit;
        } else if (_fifthDigit == null) {
          _fifthDigit = _currentDigit;
        } else if (_sixthDigit == null) {
          _sixthDigit = _currentDigit;
        }
      },
    );
    var otp = _firstDigit.toString() +
        _secondDigit.toString() +
        _thirdDigit.toString() +
        _fourthDigit.toString() +
        _fifthDigit.toString() +
        _sixthDigit.toString();
    try {
      if (otp.length == 6) {
        setState(() {
          _isLoading = true;
        });
        await Provider.of<Auth>(context, listen: false)
            .validateOtp(otp, _deviceName);

        Toast.show('Log-In Successful!', context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } on HttpException catch (error) {
      setState(() {
        _isLoading = false;
      });
      clearOtp();
      _showErrorDialog(error.getErrorMessage, context);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('UnKnown error Occured!', context);
    }
  }

  void clearOtp() {
    _sixthDigit = null;
    _fifthDigit = null;
    _fourthDigit = null;
    _thirdDigit = null;
    _secondDigit = null;
    _firstDigit = null;
    setState(() {});
  }
}

class OtpTimer extends StatelessWidget {
  final AnimationController controller;
  double fontSize;
  Color timeColor = Colors.black;

  OtpTimer(this.controller, this.fontSize, this.timeColor);

  String get timerString {
    Duration duration = controller.duration * controller.value;
    if (duration.inHours > 0) {
      return '${duration.inHours}:${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    }
    return '${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  Duration get duration {
    Duration duration = controller.duration;
    return duration;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget child) {
          return new Text(
            timerString,
            style: new TextStyle(
                fontSize: fontSize,
                color: timeColor,
                fontWeight: FontWeight.w600),
          );
        });
  }
}
