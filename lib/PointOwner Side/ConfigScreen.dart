import 'dart:convert';

import 'package:PointOwner/Entities/Point.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flex_color_picker/flex_color_picker.dart';

class ColorPickerPage extends StatefulWidget {
  Point point;

  @override
  _ColorPickerPageState createState() => _ColorPickerPageState(point);

  ColorPickerPage(this.point);
}

class _ColorPickerPageState extends State<ColorPickerPage> {
  Point point;

  Color screenPickerColor;
  bool isDark;

  _ColorPickerPageState(this.point);

  final storage = FlutterSecureStorage();

  // Define some custom colors for the custom picker segment.
  // The 'guide' color values are from
  // https://material.io/design/color/the-color-system.html#color-theme-creation
  static const Color guidePrimary = Color(0xFF6200EE);
  static const Color guidePrimaryVariant = Color(0xFF3700B3);
  static const Color guideSecondary = Color(0xFF03DAC6);
  static const Color guideSecondaryVariant = Color(0xFF018786);
  static const Color guideError = Color(0xFFB00020);
  static const Color guideErrorDark = Color(0xFFCF6679);
  static const Color blueBlues = Color(0xFF174378);

  // Make a custom ColorSwatch to name map from the above custom colors.
  final Map<ColorSwatch<Object>, String> colorsNameMap =
  <ColorSwatch<Object>, String>{
    ColorTools.createPrimarySwatch(guidePrimary): 'Guide Purple',
    ColorTools.createPrimarySwatch(guidePrimaryVariant): 'Guide Purple Variant',
    ColorTools.createAccentSwatch(guideSecondary): 'Guide Teal',
    ColorTools.createAccentSwatch(guideSecondaryVariant): 'Guide Teal Variant',
    ColorTools.createPrimarySwatch(guideError): 'Guide Error',
    ColorTools.createPrimarySwatch(guideErrorDark): 'Guide Error Dark',
    ColorTools.createPrimarySwatch(blueBlues): 'Blue blues',
  };

  @override
  void initState() {
    screenPickerColor = Colors.blue;
    isDark = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('ColorPicker Demo'),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Column(

            children: <Widget>[
              SizedBox(height: 25,),
              SizedBox(
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onPressed: () {
                    var hexColor = '#${screenPickerColor.value.toRadixString(16).padLeft(6, '0').toUpperCase()}';
                    storage.write(key: "color", value: hexColor.toString());
                    _ConfigScreenState(this.point).sendColorChange();
                  },
                  child: Text("SAVE"),
                  color: screenPickerColor,
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  splashColor: Colors.white,
                ),
                width: 200,
                height: 70,
              ),

              // Show the color picker in sized box in a raised card.
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Card(
                    elevation: 2,
                    child: ColorPicker(
                      color: screenPickerColor,
                      onColorChanged: (Color color) =>
                          setState(() => screenPickerColor = color),
                      width: 44,
                      height: 44,
                      borderRadius: 22,
                      heading: Text(
                        'Select Color',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      subheading: Text(
                        'Select Color Shade',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                  ),
                ),
              ),

              // Theme mode toggle
              SwitchListTile.adaptive(
                title: const Text('Turn ON for dark mode'),
                subtitle: const Text('Turn OFF for light mode'),
                value: isDark,
                onChanged: (bool value) {
                  setState(() {
                    isDark = value;
                    //widget.themeMode(isDark ? ThemeMode.dark : ThemeMode.light);
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////

class ConfigScreen extends StatefulWidget {
  Point point;

  @override
  _ConfigScreenState createState() => _ConfigScreenState(point);

  ConfigScreen(this.point);
}

class _ConfigScreenState extends State<ConfigScreen> {
  Point point;
  ThemeMode themeMode;

  final storage = FlutterSecureStorage();

  _ConfigScreenState(this.point);

   sendColorChange() async {
    String colorEnd = await storage.read(key: "color");

    print("1por" + " " + colorEnd);

    var jsonBody = jsonEncode(<String, dynamic>{
      "colour": colorEnd,
    });
     var response =  await http.patch('http://10.0.2.2:8080/point/${this.point.pointID}', headers: <String, String>{
      "Content-Type": "application/json"
    }, body: jsonBody);
     if(response == 201) {
       setState(() => this.point.color = Point.convertHtmlColorIntoInt(colorEnd));
     }
  }

  @override
  void initState() {
    themeMode = ThemeMode.light;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ColorPicker',
      theme: ThemeData.from(colorScheme: const ColorScheme.highContrastLight())
          .copyWith(scaffoldBackgroundColor: Colors.grey[50]),
      darkTheme:
      ThemeData.from(colorScheme: const ColorScheme.highContrastDark()),
      themeMode: themeMode,
      home: ColorPickerPage(this.point
        // themeMode: (ThemeMode mode) {
        //   setState(() {
        //     themeMode = mode;
        //   });
        // },
      ),
    );
  }
}

