import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  static const route = '/login/';
  static const routename = 'Login';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController _controller;
  late TextEditingController _controller2;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller2 = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print('${Login.routename} built');

    return Scaffold(
      appBar: AppBar(
        title: Text(Login.routename),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Login',
              ),
              controller: _controller,
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
              controller: _controller2,
            ),
            ElevatedButton(
              child: Text('Login'),
              onPressed: () {
                //This allows to go to the HomePage
                if (_controller.text == 'user' &&
                    _controller2.text == 'strong') {
                  Navigator.pushNamed(context, '/homepage/');
                } else {
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                        SnackBar(content: Text('Username o password errate')));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
} //ProfilePage
