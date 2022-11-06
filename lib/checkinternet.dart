import 'package:flutter/material.dart';

import 'load.dart';



class checkin extends StatefulWidget {
  const checkin({Key? key}) : super(key: key);

  @override
  State<checkin> createState() => _checkinState();
}

class _checkinState extends State<checkin> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
      child: SafeArea(child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text('Please Check ',style: TextStyle(fontSize: 20,),),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text('Your Internet Connection',style: TextStyle(fontSize: 20,),),
            ),
SizedBox(height: 20,),
            ElevatedButton(onPressed: (){
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => loadPage()),
  );
}, child: Text('Reload')),

          ],
        ),
      )),
    );
  }
}
