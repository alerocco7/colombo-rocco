import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  late TextEditingController username;
  late TextEditingController password;

  @override
  void initState() {
    super.initState();
    username = TextEditingController();
    password = TextEditingController();
    _checkLogin();
  }

  void _checkLogin() async {
    //Get the SharedPreference instance and check if the value of the 'username' filed is set or not
    final sp = await SharedPreferences.getInstance();
    if (sp.getString('username') != null) {
      //If 'username is set, push the HomePage
      _toHomePage(context);
    } //if
  } //_checkLogin

  void _toHomePage(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/homepage/');
  } //_toHomePage

  void _login() async {
    final sp = await SharedPreferences.getInstance();
    sp.setString('username', username.text);
    Navigator.pushNamed(context, '/homepage/');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/login.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(),
            Container(
              padding: const EdgeInsets.only(left: 10, top: 60),
              child: const Text(
    "AppredicT",
    style: TextStyle(
        fontSize: 53,
        color: Color.fromARGB(255, 249, 248, 248),
        shadows: [
          Shadow(color: Color.fromARGB(255, 6, 6, 6), offset: Offset(3, 13), blurRadius: 1),
          Shadow(color: Color.fromARGB(255, 164, 162, 162), offset: Offset(2, 2), blurRadius: 2)
        ]
    ),
  ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          Text(
                            'Welcome',
                            style: TextStyle(color: Color.fromARGB(255, 7, 7, 7), fontSize: 33,fontStyle: FontStyle.italic),
                          ),
                          SizedBox( height: 30),
                          TextField(
                            controller: username,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Username",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: password,
                            style: const TextStyle(),
                            obscureText: true,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Sign in',
                                style: TextStyle(
                                    fontSize: 27, fontWeight: FontWeight.w700,fontStyle: FontStyle.italic),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: const Color(0xff4c505b),
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      if (username.text == 'user' &&
                                          password.text == 'strong') {
                                        _login();
                                      } else {
                                        ScaffoldMessenger.of(context)
                                          ..removeCurrentSnackBar()
                                          ..showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Username o password errate')));
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward,
                                    )),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
  
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
