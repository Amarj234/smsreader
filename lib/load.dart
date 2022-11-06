import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';

import 'checkinternet.dart';
import 'login.dart';
import 'menu.dart';
import 'webview.dart';

class loadPage extends StatefulWidget {
  const loadPage({Key? key}) : super(key: key);

  @override
  State<loadPage> createState() => _loadPageState();
}

class _loadPageState extends State<loadPage> {
  final telephony = Telephony.instance;

  checksesiion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.clear();
    if (prefs.getInt('token') == null) {
      Navigator.push(
        context, MaterialPageRoute(builder: (context) => loginpage()),
      );
    } else {
      Navigator.push(
        context, MaterialPageRoute(builder: (context) => Singlecustomer()),
      );
    }
  }

    @override
    void initState() {
      // TODO: implement initState
      super.initState();

      Timer(Duration(seconds: 1), () => checkconn());

    }

    permison() async{




      final androidConfig = FlutterBackgroundAndroidConfig(
        notificationTitle: "flutter_background example app",
        notificationText: "Background notification for keeping the example app running in the background",
        notificationImportance: AndroidNotificationImportance.Default,
        notificationIcon: AndroidResource(name: 'background_icon', defType: 'drawable'), // Default is ic_launcher from folder mipmap
      );
      bool success = await FlutterBackground.initialize(androidConfig: androidConfig);
      final bool? result = await telephony.requestPhoneAndSmsPermissions;
      if (result != null && result  && success) {
        Navigator.pop(context);
        checksesiion();
      }

    }


    void checkconn() async{
      _showMyDialog();
        try {
          final result = await InternetAddress.lookup('example.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            print('connected');
            SharedPreferences prefs = await SharedPreferences.getInstance();
          //  prefs.clear();
            if (prefs.getInt('token') == null) {
              _showMyDialog();
            }else {
              Navigator.push(
                context, MaterialPageRoute(builder: (context) => Singlecustomer()),
              );
            }
           // permison();
          }
        } on SocketException catch (_) {
          print('not connected');
          Navigator.push(
            context, MaterialPageRoute(builder: (context) => checkin()),
          );
        }

    }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/game.png"),
          fit: BoxFit.cover,
        ),
      ),

    );
  }
  Future<void> _showMyDialog() async {
    return showDialog<void>(

        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Card(
                child: AlertDialog(
                  title: const Text('Free Chats needs the following  permission',
                    style: TextStyle(fontWeight: FontWeight.w400),),
                  // content: SingleChildScrollView(
                  // //   child: ListBody(
                  // //     children: const <Widget>[
                  // //
                  // //     ],
                  // //   ),
                  // // ),
                  actions: <Widget>[






                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,

                      children: [
                        SizedBox(width: 5,),
Icon(Icons.sms),
                        SizedBox(width: 5,),
                        Text('SMS')



                      ],
                    ),
                    SizedBox(height: 5,),



                    SizedBox(height: 10,),
                    // Text('Your Sms, Contant and Phone Number need to auto sms sync to other device'),
                    // SizedBox(height: 20,),

                 ElevatedButton(onPressed: (){ permison();}, child: Text('ok')),

                    SizedBox(height: 20,),


                  ],
                ),
              );
            },
          );
        }
    );
  }

}
