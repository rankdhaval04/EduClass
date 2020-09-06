import 'dart:convert';

import 'package:education/streamPage.dart';
import 'package:education/urlconfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getflutter/components/loader/gf_loader.dart';
import 'package:getflutter/components/toast/gf_toast.dart';
import 'package:getflutter/types/gf_loader_type.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp]
  )
      .then((_) {
    runApp(new MyApp());
  });
}



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
//  Future<void> checklist(BuildContext context) async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    prefs.setBool("logged_in", true);
//    if(prefs.getBool("logged_in") == true){
//      Navigator.pushReplacement(
//        context,
//        MaterialPageRoute(builder: (context) => streamPage()),
//      );
//    }
//  }
  @override
  Widget build(BuildContext context) {
   // checklist(context);
    // font size accodding to device resolution
//    MediaQueryData queryData;
//    queryData = MediaQuery.of(context);
//    final fontsize = queryData.textScaleFactor;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        brightness: Brightness.dark,
          primarySwatch: Colors.green,
          primaryColorDark: Colors.green,
          accentColor: Colors.black54,
          cursorColor: Colors.green,
          textTheme: TextTheme(
            title: TextStyle(color: Colors.black54 ),
            subtitle: TextStyle(color: Colors.black54 ),
            display1: TextStyle(color: Colors.black54 ),
          )
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool calling = true;
  bool process = false;

  logincall(String user_id, String password) async {
    // set up POST request arguments

    Map<String, String> headers = {"Content-type": "application/json"};
    Map<String, Object> json = { "function":"verify_credential",
      "json":{
        "user_id":-1,
        "user_type":1,
        "password":password,
        "mob_no":user_id,
        "lat":"21.2495164",
        "long":"72.8886319",
        "":"",
        "imei":"11151535151",
        "and_id":"000000000000"
      }
    };
    print(jsonEncode(json));
    final response = await http.post(urlconfig.LOGINURL, headers: headers, body: jsonEncode(json));  // check the status code for the result
    int statusCode = response.statusCode;  // this API passes back the id of the new item added to the body
    print(response.body);
    String body = response.body;
    if(jsonDecode(body)["success"] == 1){
      return true;
    }else{
      return false;
    }
  }


  final mob_controller = new TextEditingController();
  final pass_controller = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    checklist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final email = TextFormField(
      obscureText: false,
      controller: mob_controller,
      validator: (String value){
//        Pattern pattern =
//            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
//        RegExp regex = new RegExp(pattern);
        if (value.length != 10)
          return 'Enter Valid Mobile';
        else
          return null;
      },
      style: Theme.of(context).textTheme.body1,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Mobile no",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passsword = TextFormField(
      obscureText: true,
      controller: pass_controller,
      validator: (String value){
        if (value.length < 6)
          return 'password must be more then 6 digit';
        else
          return null;
      },
      style: Theme.of(context).textTheme.body1,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.green,
      child: MaterialButton(
        minWidth: MediaQuery
            .of(context)
            .size
            .width / 1.1 ,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if(_formKey.currentState.validate()){
            setState(() {
              calling = true;
            });
            bool loginrsponse = await logincall(mob_controller.text, pass_controller.text);
            setState(() {
              calling = false;
            });

            if(loginrsponse == true){
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool("logged_in", true);
              getdata();
            }else{
              GFToast(
                text: 'Please Enter Valid Detail',
                autoDismiss: true,
              );
            }
          }

        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: Theme
                .of(context)
                .textTheme
                .title.copyWith(color: Colors.white)
        ),
      ),
    );

    final forgotpassword = GestureDetector(
      onTap: (){
        print("forgot password is clicked");
      },
      child: Text(
        "Forgot Password?",
        style: Theme.of(context).textTheme.button,
        textAlign: TextAlign.end,
      ),
    );

//    final createone = GestureDetector(
//      onTap: (){
//        Navigator.push(
//          context,
//          MaterialPageRoute(builder: (context) => SignupPage()),
//        );
//      },
//      child: Text(
//        "Create One",
//        style: Theme.of(context).textTheme.button,
//        textAlign: TextAlign.end,
//      ),
//    );

    final notaccountyet = Text(
      "Not Account yet ? ",
      style: Theme.of(context).textTheme.button.copyWith(color: Colors.black54),
    );

    return Scaffold(

      body: process == true ? Container(child:GFLoader(type:GFLoaderType.circle),) : Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                    //  Container(child: Image.network("https://images.app.goo.gl/LzGVe8ExyFwbdDdw9",)),
                      SizedBox(height: 20.0,),
                      email,
                      SizedBox(height: 10.0,),
                      passsword,
//                        SizedBox(height: 10.0,),
//                        forgotpassword,
                      SizedBox(height: 10.0,),
                      loginButon,
                      SizedBox(height: 10.0,),
//                        Row(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            notaccountyet,
//                            createone,
//                          ],
//                        )
                    ],
                  ),
                ),
              ),
              calling == true ? GFLoader(type:GFLoaderType.circle) : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checklist() async {
    setState(() {
      process = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("logged_in", true);
//    setState(() {
//      calling = false;
//    });
    if(prefs.getBool("logged_in") == true){
      getdata();
    }else{
      setState(() {
        calling = false;
        process = false;
      });
    }
  }

  String videoid = "";
  bool islive = true;

  getdata() async {
    // set up POST request arguments

    Map<String, String> headers = {"Content-type": "application/json"};
    Map<String, Object> json = {
      "function":"get_data",
      "json":{
        "id":1
      }
    };
    setState(() {
      calling = true;
    });
    print(jsonEncode(json));
    final response = await http.post(urlconfig.GETDATAURL, headers: headers, body: jsonEncode(json));  // check the status code for the result
    int statusCode = response.statusCode;  // this API passes back the id of the new item added to the body
    print(response.body);
    String body = response.body;
    Map<String, dynamic> data = jsonDecode(body);
    setState(() {
      if(data["success"] == 1){
        setState(() {
          data = data['data'];
          videoid = data['video_id'];
          if(data['is_live'] == 1){
            islive = true;
          }else{
            islive = false;
          }
          calling = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => streamPage(this.videoid, this.islive)),
        );
      }
      calling = false;
    });

  }
}
