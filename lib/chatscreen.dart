import 'dart:convert';
import 'dart:io';
import 'package:flutter_background/flutter_background.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../servise.dart';
import 'package:image_picker/image_picker.dart';

class chatscreen extends StatefulWidget {
  const chatscreen({Key? key, required this.mobile, required this.username, required this.id}) : super(key: key);

  final mobile;
  final username;
  final id;

  @override
  _chatscreenState createState() => _chatscreenState();
}

class _chatscreenState extends State<chatscreen> {

  TextEditingController _inputMessageController = new TextEditingController();

  ScrollController _scrollController = new ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );


  final androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: "flutter_background example app",
    notificationText: "Background notification for keeping the example app running in the background",
    notificationImportance: AndroidNotificationImportance.Default,
    notificationIcon: AndroidResource(name: 'background_icon', defType: 'drawable'), // Default is ic_launcher from folder mipmap
  );


  @override
  void initState() {
    super.initState();
    allPerson();
    Future.delayed(Duration.zero, () async {

    });
  }

final Message =TextEditingController();


  bool imageshow=false;

  Savedata() async{

    SharedPreferences prefs =await SharedPreferences.getInstance();

    final uri = Uri.parse(serves.url+"chatapp.php");
    var request = http.MultipartRequest('POST',uri);

    request.fields['message'] = Message.text;
    request.fields['mobile'] = prefs.getString('mobile').toString();
    request.fields['name'] = prefs.getString('name').toString();
    request.fields['uid'] = widget.mobile.toString();
    if(image==null) {}else{
      var images = await http.MultipartFile.fromPath("image", image!.path.toString());

      request.files.add(images);
    }

    var response = await request.send();
    var response1 = await http.Response.fromStream(response);
    if (response.statusCode == 200) {
      print('Image Uploded ${response1.body}');

      Message.text="";
      allPerson();
      setState(() {
image;
      });


      // Navigator.pop(context, 'OK');
    }else{

    }
  }



  List<Container> state2=[];
  Serves serves=Serves();

  Future allPerson() async {

    SharedPreferences prefs =await SharedPreferences.getInstance();
    state2=[];
    print(prefs.getString('mobile'));
    final uri = Uri.parse(serves.url+"chatapp.php");
    var response = await http.post(uri,body: {
      'showdata':prefs.getString('mobile'),
      'incoming':widget.mobile,
    });

    var state= json.decode(response.body);
    print(state);
    setState(() {
      state.forEach((item) {
        state2.add(
            Container(
              padding: EdgeInsets.only(
                  left: 14, right: 14, top: 10, bottom: 10),
              child: Align(
                alignment: (item['outgoingid']==prefs.getString('mobile')
                    ? Alignment.topRight
                    : Alignment.topLeft),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: (item['mobile']==prefs.getString('vid')
                        ? Colors.grey.shade200
                        : Colors.blue[200]),
                  ),
                  padding: EdgeInsets.all( item['mobile']==prefs.getString('mobile') ? 16:10 ),
                  child:item['outgoingid']==prefs.getString('mobile') ? Expanded(
                    child:item['status1']=='1' ?  Text(
                      item['massege'].toString(),
                      style: TextStyle(fontSize: 15),
                    ): Image.network(serves.url+item['image'],width: 200,),
                  )  : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'].toString(),
                        style: TextStyle(fontSize: 12,color: Colors.red),
                      ),
                      Container(
                        child: item['status1']=='1' ? Text(
                          item['massege'].toString(),
                          style: TextStyle(fontSize: 15),
                        ):Image.network(serves.url+item['image'],width: 200,),
                      )
                    ],
                  ),
                ),
              ),
            )

        );
      }
      );
    });
  }



  String? image1;
  File? image;
  final picker = ImagePicker();

  Future choiceImage()async{

    var pickedImage = await picker.getImage(
      source: ImageSource.gallery,
      maxHeight: 1800,
      maxWidth: 1800,
      imageQuality: 20,
    );
    setState(() {
      image = File(pickedImage!.path);
      _showMyDialog();
    });
  }



  @override
  Widget build(BuildContext context) {
    _scrollToBottom();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        //automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.username.toString(),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        widget.mobile.toString(),
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            chatSpaceWidget(),
            Container(
              height: 1.0,
              width: double.infinity,
              color: Colors.blueGrey,
            ),
            bottomChatView()
          ],
        ),
      ),
    );
  }

  Widget chatSpaceWidget() {
    return Flexible(
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: state2,
        ),
      ),
    );
  }

  Widget bottomChatView() {
    return Container(
      padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
      height: 60,
      width: double.infinity,
      child: Row(
        children: <Widget>[
          IconButton(onPressed: (){
            choiceImage();
          }, icon: Icon(Icons.attach_file)),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: TextField(
              controller: Message,
              onSubmitted: (String str) {
                Savedata();
              },
              decoration: InputDecoration(
                  hintText: "Write message...",
                  hintStyle: TextStyle(color: Colors.black54),
                  border: InputBorder.none),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          FloatingActionButton(
            onPressed: () {
              Savedata();
            },
            child: Icon(
              Icons.send,
              color: Colors.white,
              size: 18,
            ),
            backgroundColor: Colors.blue,
            elevation: 0,
          ),
        ],
      ),
    );
  }

  _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
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
                      title: const Text('Send Photo',
                        style: TextStyle(fontWeight: FontWeight.w800),),

                      actions: <Widget>[
Center(child: Image.file(image!,width: 200,)),


                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Center(
                                child: ElevatedButton(onPressed: (){
                                  Savedata();
                                  Navigator.pop(context);
                                },child: Text('Send File'),),
                              ),
SizedBox(width: 20,),
                              Center(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:  MaterialStateProperty.all(Colors.greenAccent),
                                  ),
                                  onPressed: (){

                                  Navigator.pop(context);
                                },child: Text('Cencel'),),
                              ),
                            ],
                          ),
                        ),
                      ]
                  )

              );
            },
          );
        }
    );
  }

}
