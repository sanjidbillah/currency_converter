import 'package:currency_converter/screen/user.dart';
import 'package:flutter/material.dart';
import 'animation.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_admob/firebase_admob.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

const String testDevice = 'MobileId';

class _HomePageState extends State<HomePage> {
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    nonPersonalizedAds: true,
    keywords: <String>['Game', 'Mario'],
  );

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;

  BannerAd createBannerAd() {
    return BannerAd(
//        "ca-app-pub-6975533553106709/5456660793"
        adUnitId: "ca-app-pub-6975533553106709/5456660793",
        //Change BannerAd adUnitId with Admob ID
        size: AdSize.smartBanner,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {});
  }

//

  bool anmLoad = false;
  AutoCompleteTextField searchTextField;

  AutoCompleteTextField searchTextField2;
  static List<User> users = new List<User>();
  GlobalKey<AutoCompleteTextFieldState<User>> key = new GlobalKey();

  GlobalKey<AutoCompleteTextFieldState<User>> key2 = new GlobalKey();

  Widget row(User user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          user.name,
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(
          width: 35,
          height: 35,
          child: FadeInImage.assetNetwork(
              placeholder: "assets/flag.png",
              image: "https://www.countryflags.io/${user.flag}/shiny/64.png"),
        ),
      ],
    );
  }

  bool _rememberMe = false;
  bool loading = true;

  String From = "BDT";
  String To = "ARS";
  String astring = "";

  String bString = "";

  static List<User> loadUsers(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  Widget aimag(data, wid, hei) {
    return SizedBox(
        width: wid,
        height: hei,
        child: FadeInImage.assetNetwork(
            placeholder: "assets/flag.png",
            image: "https://www.countryflags.io/${data}/shiny/64.png"));
  }

  Widget _buildFrom() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'From',
                style: kLabelStyle,
              ),
            ),
            astring == ""
                ? Align(
                    alignment: Alignment.topRight,
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: Image.asset("assets/flag.png"),
                    ))
                : Align(
                    alignment: Alignment.topRight,
                    child: aimag(astring, 22.0, 22.0)),
          ],
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 50.0,
          child: searchTextField2 = AutoCompleteTextField<User>(
            controller: from,
            key: key2,
            clearOnSubmit: false,
            suggestions: users,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
//            disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 05.0, left: 10),
              hintText: "Search Country Name",

              hintStyle: kHintTextStyle,
            ),
            itemFilter: (item, query) {
              return item.name.toLowerCase().startsWith(query.toLowerCase());
            },
            itemSorter: (a, b) {
              return a.name.compareTo(b.name);
            },
            itemSubmitted: (item) {
              setState(() {
                searchTextField2.textField.controller.text = item.name;

                astring = item.flag;
                From = item.short;
              });
            },
            itemBuilder: (context, item) {
              // ui for the autocompelete row
              return row(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'To',
                style: kLabelStyle,
              ),
            ),
            IconButton(icon: Icon(Icons.unfold_less), onPressed: () {}),
            bString == ""
                ? Align(
                    alignment: Alignment.topRight,
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: Image.asset("assets/flag.png"),
                    ))
                : Align(
                    alignment: Alignment.topRight,
                    child: aimag(bString, 22.0, 22.0)),
          ],
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 50.0,
          child: searchTextField = AutoCompleteTextField<User>(
            controller: to,
            key: key,
            clearOnSubmit: false,
            suggestions: users,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
//            disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 05.0, left: 10),
              hintText: "Search Country Name",

              hintStyle: kHintTextStyle,
            ),
            itemFilter: (item, query) {
              return item.name.toLowerCase().startsWith(query.toLowerCase());
            },
            itemSorter: (a, b) {
              return a.name.compareTo(b.name);
            },
            itemSubmitted: (item) {
              setState(() {
                searchTextField.textField.controller.text = item.name;

                bString = item.flag;

                To = item.short;
              });
            },
            itemBuilder: (context, item) {
              // ui for the autocompelete row
              return row(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAmount(data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Text(
            '$data',
            style: kLabelStyle,
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 50.0,
          child: TextField(
            keyboardType: TextInputType.number,
            controller: amount,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 05.0, left: 10),
              hintText: 'Enter Your Amount',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  void getUsers() async {
    try {
      final response = await rootBundle.loadString("assets/data.json");

      if (response != null) {
        users = loadUsers(response);

        setState(() {
          loading = false;
        });
      }
    } catch (e) {}
  }

  Widget _converButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          setState(() {
            anmLoad = true;
            getData(amount.text, To, From);
          });
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Convert',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers();
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-6975533553106709/5456660793");
    //Change appId With Admob Id
    _bannerAd = createBannerAd()
      ..load()
      ..show();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    _interstitialAd.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 50.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        DateFormat.yMMMd().format(DateTime.now()).toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      loading ? CircularProgressIndicator() : _buildFrom(),
                      SizedBox(
                        height: 20.0,
                      ),
                      loading ? CircularProgressIndicator() : _buildTo(),
                      SizedBox(
                        height: 20.0,
                      ),
                      _buildAmount("Amount"),
//                      _buildForgotPasswordBtn(),
//                      _buildRememberMeCheckbox(),
                      _converButton(),

                      anmLoad
                          ? Center(
                              child: SpinKitCubeGrid(
                                color: Colors.white,
                              ),
                            )
                          : convert == null
                              ? SizedBox()
                              : RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            '${convert['from_quantity']} ${convert['from_symbol']}  =  ${double.parse(convert['to_quantity'].toString()).toStringAsFixed(2)} ${convert['to_symbol']}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          astring == ""
                              ? SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Image.asset("assets/flag.png"),
                                )
                              : aimag(astring, 40.0, 40.0),
                          Text(
                            "To",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          bString == ""
                              ? SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Image.asset("assets/flag.png"),
                                )
                              : aimag(bString, 40.0, 40.0),
                        ],
                      ),
                      convert == null
                          ? SizedBox()
                          : RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        'Last Update : ${convert['request_date']}',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  TextEditingController to = TextEditingController();
  TextEditingController from = TextEditingController();
  TextEditingController amount = TextEditingController(text: "1");

  Map convert;

  Map<String, String> get headers => {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-RapidAPI-Host": "bravenewcoin-v1.p.rapidapi.com",
        "X-RapidAPI-Key": "9c25f4adf0msh79701ae94c39c12p160c8bjsn0efea00057a0"
      };

  Future getData(data, to, from) async {
    var url =
        "https://bravenewcoin-v1.p.rapidapi.com/convert?qty=${int.parse(data)}&to=${to == "" ? "bdt" : to}&from=${from == "" ? "usd" : from}";

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      setState(() {
        convert = json.decode(response.body);

        anmLoad = false;
      });
    } else {
      setState(() {
        anmLoad = false;
      });
    }
  }
}
