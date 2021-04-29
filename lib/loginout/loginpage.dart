import 'package:flutter/material.dart';
import 'package:nativestore/config.dart';
import 'package:nativestore/homepage.dart';
import 'package:nativestore/loginout/auth.dart';
import 'package:nativestore/loginout/dividerpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class loginPage extends StatefulWidget {
  @override
  loginPageState createState() => loginPageState();
}

class loginPageState extends State<loginPage> {
  final AuthService _auth = AuthService();
  var y;
  var user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white30, pc]),
        ),
        child: Column(
          children: [
            Container(
              child: Image.asset("assets/welcome.png"),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlineButton(
                      color: pc,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45)),
                      splashColor: dc,
                      borderSide: BorderSide(color: dc),
                      onPressed: () {
                        _auth.googleSignIn().then((value) {
                          // print(object)
                          _auth.logIn().then((value1) async {
                            user = value;
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString('_spemail', value.email);
                            prefs.setString('cust_name', value.displayName);
                            y = await Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => Role(
                                          usern: user,
                                        )));
                          });
                        });
                      },
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image(
                                  image: AssetImage('assets/search.png'),
                                  height: 35),
                              Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text('Sign in with Google',
                                      style:
                                          TextStyle(color: dc, fontSize: 25)))
                            ],
                          ))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
