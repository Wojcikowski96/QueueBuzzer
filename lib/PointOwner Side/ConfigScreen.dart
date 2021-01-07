import 'dart:convert';

import 'package:PointOwner/Entities/Point.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flex_color_picker/flex_color_picker.dart';

Color screenColor;

class ConfigScreen extends StatefulWidget {
  Point point;

  @override
  _ConfigScreenState createState() => _ConfigScreenState(point);

  ConfigScreen(this.point);
}

class _ConfigScreenState extends State<ConfigScreen> {
  Point point;
  ThemeMode themeMode;

  /*RegExp regExp = new RegExp(
    r"^#[0-9a-f]{3}([0-9a-f]{3})?$",
    caseSensitive: false,
    multiLine: false,
  );*/
  _ConfigScreenState(this.point);

  final _color = new TextEditingController();

  Future<void> sendColorChange() async {
    print("1por" + " " + screenColor.toString());
    var jsonBody = jsonEncode(<String, dynamic>{
      "colour": screenColor,//_color.text,
    });
     var response =  await http.patch('http://10.0.2.2:8080/point/${this.point.pointID}', headers: <String, String>{
      "Content-Type": "application/json"
    }, body: jsonBody);
     if(response == 201) {
       setState(() => this.point.color = Point.convertHtmlColorIntoInt(screenColor.toString()));
     }
  }

  @override
  void initState() {
    themeMode = ThemeMode.light;

    sendColorChange();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {sendColorChange();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ColorPicker',
      theme: ThemeData.from(colorScheme: const ColorScheme.highContrastLight())
          .copyWith(scaffoldBackgroundColor: Colors.grey[50]),
      darkTheme:
      ThemeData.from(colorScheme: const ColorScheme.highContrastDark()),
      themeMode: themeMode,
      home: ColorPickerPage(
        themeMode: (ThemeMode mode) {
          setState(() {sendColorChange();
            themeMode = mode;
          });
        },
      ),
    );
  }
}

class ColorPickerPage extends StatefulWidget {
  const ColorPickerPage({Key key, this.themeMode}) : super(key: key);
  final ValueChanged<ThemeMode> themeMode;

  @override
  _ColorPickerPageState createState() => _ColorPickerPageState();
}

class _ColorPickerPageState extends State<ColorPickerPage> {
  Color screenPickerColor;
  bool isDark;

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
                  onPressed: (){screenColor = screenPickerColor;},
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
                    widget.themeMode(isDark ? ThemeMode.dark : ThemeMode.light);
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