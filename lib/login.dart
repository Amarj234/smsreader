import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'menu.dart';
import 'servise.dart';
import 'webview.dart';


class loginpage extends StatefulWidget {
  const loginpage({Key? key}) : super(key: key);

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {



  Future sendotpf() async{
    setState((){
      logcheck=false;
    });
    if(mobile.text.length==10) {
      var url4 = Uri.parse(serves.url+"sendotp.php");
      var response = await http.post(url4, body: {
        'mobile': mobile.text,

      });
      print(response.body);
      if (response.statusCode == 200) {
setState((){
  ischeck = true;
});

        // Navigator.push(
        //   context,MaterialPageRoute(builder: (context)=> autoOtp()),
        // );
      }
    }
  }

  Serves serves=Serves();

  Future checkOtp() async{


    var url2 = Uri.parse(serves.url+"checkotp.php");
    var response = await http.post(url2, body: {
      'mobile': mobile.text,
      'otp':otp.text,
    });
    print(response.body);
    if (response.statusCode == 200) {

      var check =jsonDecode(response.body);

      if(check==1){

        Savedata();

      }else{

      }
      // Navigator.push(
      //   context,MaterialPageRoute(builder: (context)=> autoOtp()),
      // );
    }
  }



  Savedata() async{
    if(mobile.text.length==10) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('mobile', mobile.text.toString());
      prefs.setString('name', name.text.toString());


      Navigator.push(
        context, MaterialPageRoute(builder: (context) => Singlecustomer()),
      );


    }
  }
bool ischeck=false;
  bool logcheck=true;
  final otp = TextEditingController();
  final mobile = TextEditingController();
  final  name  =  TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:  SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Center(
              child:Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height/3,),
                    TextFormField(
                      controller: name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Mobile';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border:  OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.blue)),
                        labelText: "Name",
                        hoverColor: Colors.black12,
                        hintText: "Enter Name",

                      ),

                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType:TextInputType.number ,

                      controller: mobile,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Mobile';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border:  OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.blue)),
                        labelText: "Mobile No.",
                        hoverColor: Colors.black12,
                        hintText: "Enter Mobile",


                      ),

                      maxLength: 10,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      visible: logcheck,
                      child: ElevatedButton(onPressed: (){
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          Savedata();
                        }
                      },
                          child: Text('Login')),
                    ),

                    SizedBox(
                      height: 20,
                    ),


                    Visibility(
                      visible: ischeck,
                      child: Column(
                        children: [
                          SizedBox(
                            width: 150,
                            height: 60,
                            child: TextFormField(
                              keyboardType:TextInputType.number ,

                              controller: otp,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Mobile';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border:  OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: Colors.blue)),
                                labelText: "OTP Code.",
                                hoverColor: Colors.black12,
                                hintText: "Enter OTP Mobile",


                              ),

                              maxLength: 6,
                            ),
                          ),
                          ElevatedButton(onPressed: (){

                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                            checkOtp();

                          },
                              child: Text('Submit')),

                        ],
                      ),
                    ),

                  ],
                ),
              ) ,
            ),
          ),
        ),
      ),
    );
  }
}
