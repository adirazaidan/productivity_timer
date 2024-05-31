import 'package:cupertino_setting_control/cupertino_setting_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const CupertinoSettings());

class CupertinoSettings extends StatelessWidget {
  const CupertinoSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  late TextEditingController txtWork;
  late TextEditingController txtShort;
  late TextEditingController txtLong;

  static const String WORKTIME = "workTime";
  static const String SHORTBREAK = "shortBreak";
  static const String LONGBREAK = "longBreak";

  final int workTime = 25;
  final int shortBreak = 5;
  final int longBreak = 20;

  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    txtWork = TextEditingController();
    txtShort = TextEditingController();
    txtLong = TextEditingController();
    readSettings();
  }

  void readSettings() async {
    prefs = await SharedPreferences.getInstance();
    int myWorkTime = prefs.getInt(WORKTIME) ?? workTime;
    int myShortBreak = prefs.getInt(SHORTBREAK) ?? shortBreak;
    int myLongBreak = prefs.getInt(LONGBREAK) ?? longBreak;
    setState(() {
      txtWork.text = myWorkTime.toString();
      txtShort.text = myShortBreak.toString();
      txtLong.text = myLongBreak.toString();
    });
  }

  void updateSettings(String key, int value) {
    switch (key) {
      case WORKTIME:
        int myWorkTime = prefs.getInt(WORKTIME) ?? workTime;
        myWorkTime += value;
        if (myWorkTime >= 1 && myWorkTime <= 180) {
          prefs.setInt(WORKTIME, myWorkTime);
          setState(() {
            txtWork.text = myWorkTime.toString();
          });
        }
        break;
      case SHORTBREAK:
        int myShort = prefs.getInt(SHORTBREAK) ?? shortBreak;
        myShort += value;
        if (myShort >= 1 && myShort <= 180) {
          prefs.setInt(SHORTBREAK, myShort);
          setState(() {
            txtShort.text = myShort.toString();
          });
        }
        break;
      case LONGBREAK:
        int myLong = prefs.getInt(LONGBREAK) ?? longBreak;
        myLong += value;
        if (myLong >= 1 && myLong <= 180) {
          prefs.setInt(LONGBREAK, myLong);
          setState(() {
            txtLong.text = myLong.toString();
          });
        }
        break;
      default:
    }
  }

  void resetSettings() {
    prefs.setInt(WORKTIME, workTime);
    prefs.setInt(SHORTBREAK, shortBreak);
    prefs.setInt(LONGBREAK, longBreak);
    setState(() {
      txtWork.text = workTime.toString();
      txtShort.text = shortBreak.toString();
      txtLong.text = longBreak.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileSettingsTile = Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
            child: Text(
              'Settings',
              style: TextStyle(
                color: CupertinoColors.systemBlue,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SettingRow(
            key: Key(txtWork.text), 
            rowData: SettingsSliderConfig(
              title: 'Work',
              from: 1,
              to: 180,
              initialValue: double.tryParse(txtWork.text) ?? workTime.toDouble(),
              justIntValues: true,
              unit: ' Minutes',
            ),
            onSettingDataRowChange: (double resultVal) {
              updateSettings(WORKTIME, resultVal.toInt() - (int.tryParse(txtWork.text) ?? workTime));
            },
            config: const SettingsRowConfiguration(
              showAsTextField: false,
              showAsSingleSetting: false,
            ),
          ),
          SettingRow(
            key: Key(txtShort.text), 
            rowData: SettingsSliderConfig(
              title: 'Short Break',
              from: 1,
              to: 180,
              initialValue: double.tryParse(txtShort.text) ?? shortBreak.toDouble(),
              justIntValues: true,
              unit: ' Minutes',
            ),
            onSettingDataRowChange: (double resultVal) {
              updateSettings(SHORTBREAK, resultVal.toInt() - (int.tryParse(txtShort.text) ?? shortBreak));
            },
            config: const SettingsRowConfiguration(
              showAsTextField: false,
              showAsSingleSetting: false,
            ),
          ),
          SettingRow(
            key: Key(txtLong.text), 
            rowData: SettingsSliderConfig(
              title: 'Long Break',
              from: 1,
              to: 180,
              initialValue: double.tryParse(txtLong.text) ?? longBreak.toDouble(),
              justIntValues: true,
              unit: ' Minutes',
            ),
            onSettingDataRowChange: (double resultVal) {
              updateSettings(LONGBREAK, resultVal.toInt() - (int.tryParse(txtLong.text) ?? longBreak));
            },
            config: const SettingsRowConfiguration(
              showAsTextField: false,
              showAsSingleSetting: false,
            ),
          ),
        ],
      ),
    );

    final resetButton = Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
            child: Text(
              'Reset Settings',
              style: TextStyle(
                color: CupertinoColors.systemBlue,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SettingRow(
            rowData: SettingsButtonConfig(
              title: 'Reset Settings',
              tick: true,
              functionToCall: resetSettings,
            ),
            style: const SettingsRowStyle(
              backgroundColor: CupertinoColors.lightBackgroundGray,
            ),
            config: const SettingsRowConfiguration(
              showTitleLeft: true,
            ),
            onSettingDataRowChange: () {},
          ),
        ],
      ),
    );

    const modifyProfileTile = Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[],
      ),
    );

    final List<Widget> widgetList = [
      profileSettingsTile,
      const SizedBox(height: 15.0),
      const Row(children: [Expanded(child: modifyProfileTile)]),
      resetButton,
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: widgetList,
        ),
      ),
    );
  }
}
