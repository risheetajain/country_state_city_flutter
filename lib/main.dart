import 'package:flutter/material.dart';

import 'api_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final FocusNode _countryNode = FocusNode();
  final FocusNode _stateNode = FocusNode();
  final FocusNode _cityNode = FocusNode();

  List countryList = [];
  List stateList = [];
  List cityList = [];
  String country = "";
  String state = "";
  String oldCountry = "";
  String oldState = "";
  String city = "";
  bool showStateList = false;
  bool showCityList = true;

  @override
  void dispose() {
    super.dispose();

    _countryNode.dispose();
    _cityNode.dispose();
    _stateNode.dispose();
  }

  @override
  void initState() {
    super.initState();
    ApiUtils.getCountryName().then((value) {
      setState(() {
        countryList = value;
      });
    });
    // ApiServices.getCustomerData(
    //         customerId: widget.customerId, token: widget.apiToken)
    //     .then((value) {
    //   print(value);
    //   if (mounted) {
    //     setState(() {
    //       customer = value;
    //       isLoading = true;
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          DropdownButtonFormField(
            focusNode: _countryNode,
            isExpanded: true,
            style: Theme.of(context).textTheme.headline2,
            hint: Text("Select Your Country"),
            icon: Icon(Icons.keyboard_arrow_down),
            items: countryList
                .map((e) => DropdownMenuItem(
                      child: Text(e["name"]),
                      value: e["iso2"],
                      onTap: () {
                        setState(() {
                          stateList.clear();
                        });
                      },
                    ))
                .toList(),
            onTap: () {
              setState(() {
                showStateList = false;
                showCityList = false;
                stateList.clear();
              });
            },
            onChanged: (val) {
              ApiUtils.getStateName(val.toString()).then((data) {
                if (data != []) {
                  setState(() {
                    stateList.addAll(data);
                    showStateList = true;
                    country = val.toString();
                  });
                  _stateNode.requestFocus();
                }
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          if (showStateList && stateList.isNotEmpty)
            DropdownButtonFormField(
                isExpanded: true,
                focusNode: _stateNode,
                style: Theme.of(context).textTheme.headline2,
                hint: Text("Select Your State"),
                icon: Icon(Icons.keyboard_arrow_down),
                items: stateList
                    .map((e) => DropdownMenuItem(
                          child: Text(e["name"]),
                          value: e["iso2"],
                          onTap: () {},
                        ))
                    .toList(),
                onTap: () {
                  setState(() {
                    showCityList = false;
                  });
                },
                onChanged: (val) {
                  ApiUtils.getCityName(
                          countryCode: country, stateName: val.toString())
                      .then((data) {
                    if (data != []) {
                      setState(() {
                        cityList.addAll(data);
                        showCityList = true;
                        country = val.toString();
                      });
                    }
                  });
                  _cityNode.requestFocus();
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                )),
          SizedBox(
            height: 20,
          ),
          if (showCityList && cityList.isNotEmpty)
            DropdownButtonFormField(
                focusNode: _cityNode,
                isExpanded: true,
                style: Theme.of(context).textTheme.headline2,
                hint: Text("Select Your City"),
                icon: Icon(Icons.keyboard_arrow_down),
                items: cityList
                    .map((e) => DropdownMenuItem(
                          child: Text(e["name"]),
                          value: e["id"],
                          onTap: () {},
                        ))
                    .toList(),
                onChanged: (val) {},
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                )),
        ],
      )),
    );
  }
}
