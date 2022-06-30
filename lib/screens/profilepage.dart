import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:colombo_rocco/utils/strings.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:colombo_rocco/database/TypeConverters/datetimeconverter.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? username = 'FETCH YOUR DATA';
  DateTime? birth = DateTime(0, 0, 0);
  String? gender = 'FETCH YOUR DATA';
  double? height = 0;
  double? weight = 0;

  @override
  void initState() {
    super.initState();
    username = 'FETCH YOUR DATA';
    birth = DateTime(0, 0, 0);
    gender = 'FETCH YOUR DATA';
    height = 0;
    weight = 0;
  }

  @override
  Widget build(BuildContext context) {
    _shPr(); //If data are fetched yet they are stored using shared preferences persistence

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 167, 192, 3),
          title: Text(
            'Profile',
            style: TextStyle(color: Color.fromARGB(255, 6, 6, 6)),
          ),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.add_to_home_screen_outlined,
                    color: Color.fromARGB(255, 6, 6, 6)),
                tooltip: 'Logout',
                onPressed: () async {
                  // Authorize the app
                  String? userId = await FitbitConnector.authorize(
                      context: context,
                      clientID: Strings.fitbitClientID,
                      clientSecret: Strings.fitbitClientSecret,
                      redirectUri: Strings.fitbitRedirectUri,
                      callbackUrlScheme: Strings.fitbitCallbackScheme);

                  //Instantiate a proper data manager
                  FitbitAccountDataManager fitbitAccountDataManager =
                      FitbitAccountDataManager(
                          clientID: Strings.fitbitClientID,
                          clientSecret: Strings.fitbitClientSecret);

                  //Fetch data
                  FitbitUserAPIURL fitbitUserApiUrl =
                      FitbitUserAPIURL.withUserID(userID: userId);
                  final fitbitAccountDatas =
                      await fitbitAccountDataManager.fetch(fitbitUserApiUrl);
                  FitbitAccountData fitbitAccountData =
                      fitbitAccountDatas[0] as FitbitAccountData;
                  setdata(
                      fitbitAccountData.fullName,
                      fitbitAccountData.dateOfBirth,
                      fitbitAccountData.gender,
                      fitbitAccountData.height,
                      fitbitAccountData.weight);
                }),
          ]),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new FloatingActionButton(
                elevation: 0.0,
                mini: true,
                child: new Icon(Icons.home, color: Colors.white),
                backgroundColor: Color.fromARGB(255, 6, 6, 6),
                onPressed: () {
                  Navigator.pop(context);
                }),
            ElevatedButton(
              child: const Text('Tap to unauthorize'),
              style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  fixedSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35))),
              onPressed: () async {
                await FitbitConnector.unauthorize(
                  clientID: Strings.fitbitClientID,
                  clientSecret: Strings.fitbitClientSecret,
                );
              },
            ),
          ],
        ),
      ),
      body: _body(context),
    );
  }

  //Create the UI
  _body(BuildContext context) =>
      ListView(physics: BouncingScrollPhysics(), children: <Widget>[
        Container(
            padding: EdgeInsets.all(15),
            child: Column(children: <Widget>[_headerSignUp(), _formUI()]))
      ]);
  //_______________________________________________________________________________________
  //Body's functions
  _headerSignUp() => Column(children: <Widget>[
        Container(
            height: 80, child: Icon(Icons.account_circle, size: 110)),
        SizedBox(height: 23.0),
        Text('Your Account',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 25.0,
                fontStyle: FontStyle.italic,
                color: Color.fromARGB(255, 6, 6, 6))),
      ]);

  _formUI() {
    return new Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 45.0),
          _name(),
          SizedBox(height: 25.0),
          _birthDate(),
          SizedBox(height: 25.0),
          _gender(),
          SizedBox(height: 25.0),
          _height(),
          SizedBox(height: 25.0),
          _weight(),
          SizedBox(height: 25.0),
        ],
      ),
    );
  }

  //___________________________________________________________________
  // formUI's functions
  _name() {
    return Row(children: <Widget>[
      _prefixIcon(Icons.account_box),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('_____________ User Name _______________',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 17.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.white.withOpacity(0.5))),
          SizedBox(height: 5),
          Text('                                ' + username!)
        ],
      )
    ]);
  }

  _birthDate() {
    return Row(children: <Widget>[
      _prefixIcon(Icons.date_range),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('_____________ Birth date ________________',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 17.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.white.withOpacity(0.5))),
          SizedBox(height: 10),
          Text('                          ' + _date(birth!)),
        ],
      )
    ]);
  }

  _gender() {
    return Row(children: <Widget>[
      _prefixIcon(Icons.male),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('______________ Gender __________________',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 17.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.white.withOpacity(0.5))),
          SizedBox(height: 10),
          Text('                                 ' + gender!)
        ],
      )
    ]);
  }

  _height() {
    return Row(children: <Widget>[
      _prefixIcon(Icons.height),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('______________ Height __________________',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 17.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.white.withOpacity(0.5))),
          SizedBox(height: 10),
          Text('                               ' + height.toString() + ' cm')
        ],
      )
    ]);
  }

  _weight() {
    return Row(children: <Widget>[
      _prefixIcon(Icons.line_weight),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('______________ Weight __________________',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 17.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.white.withOpacity(0.5))),
          SizedBox(height: 10),
          Text('                                ' + weight.toString() + ' Kg')
        ],
      )
    ]);
  }

  _prefixIcon(IconData iconData) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 48.0, minHeight: 48.0),
      child: Container(
          padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
          margin: const EdgeInsets.only(right: 8.0),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                  bottomRight: Radius.circular(10.0))),
          child: Icon(
            iconData,
            size: 20,
            color: Color.fromARGB(255, 94, 93, 93),
          )),
    );
  }
//____________________________________________________________________________________

  @override
  void dispose() {
    super.dispose();
  }

//Functions for persisting data with shared preferences
  void _shPr() async {
    String? name = await getName();
    if (name != null) {
      setState(() {
        username = name;
      });
    }
    int? bd = await getBirth();
    if (bd != null) {
      setState(() {
        birth = DateTimeConverter().decode(bd);
      });
    }
    String? gd = await getGender();
    if (gd != null) {
      setState(() {
        gender = gd;
      });
    }
    double? h = await getHeight();
    if (h != null) {
      setState(() {
        height = h;
      });
    }
    double? w = await getWeight();
    if (w != null) {
      setState(() {
        weight = w;
      });
    }
  }

  void setdata(String? name, DateTime? date, String? gender, double? height,
      double? weight) async {
    setState(() {
      username = name;
      birth = date;
      gender = gender;
      height = height;
      weight = weight;
    });
    int? data = DateTimeConverter().encode(birth!);
    final sp = await SharedPreferences.getInstance();
    sp.setString('fullname', username!);
    sp.setInt('birthdate', data);
    sp.setString('sex', gender!);
    sp.setDouble('heighdata', height!);
    sp.setDouble('weightdata', weight!);
  }

  Future<String?> getName() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString('fullname');
  }

  Future<int?> getBirth() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getInt('birthdate');
  }

  Future<String?> getGender() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString('sex');
  }

  Future<double?> getHeight() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getDouble('heighdata');
  }

  Future<double?> getWeight() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getDouble('weightdata');
  }
}

String _date(DateTime birth) {
  if (birth == DateTime(0, 0, 0)) {
    return 'FETCH YOUR DATA';
  } else {
    return DateFormat.yMMMMd().format(birth);
  }
}
