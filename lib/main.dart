import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:productivity_timer_adira/cupertino.dart';
// import 'package:productivity_timer_adira/settings.dart';
import 'package:productivity_timer_adira/timer.dart';
import 'package:productivity_timer_adira/timermodel.dart';
import 'package:productivity_timer_adira/widget.dart';
import 'package:adaptive_theme/adaptive_theme.dart';


void main() {
  runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      dark: ThemeData(
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      initial: AdaptiveThemeMode.light,  
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Productivity Timer',
        theme: theme,
        darkTheme: darkTheme,
        home: const TimerHomepage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
  
}

class TimerHomepage extends StatefulWidget {
  const TimerHomepage({super.key});

  @override
  State<TimerHomepage> createState() => _TimerHomepageState();
  
}
  //Mendeklarasikan String SETTINGS dan SWITCHTHEME diluar Class
 final String SETTINGS = 'Settings';
 final String SWITCHTHEME = 'Switch Theme';

class _TimerHomepageState extends State<TimerHomepage> {

  final double defaultPadding = 5.0;

  //Menderklrasikan menuItems sebagai List PopMenuItem
  final List<PopupMenuItem<String>> menuItems = <PopupMenuItem<String>>[
    //Menambahkan Value dan Child kedalam PopMenuItem 
      PopupMenuItem(
        value: SETTINGS,
        child:  Text(SETTINGS)
        ),
      const PopupMenuItem(
        value: 'About',
        child: Text('About')
        ),
       PopupMenuItem(
      value: SWITCHTHEME,
      child: Text(SWITCHTHEME)
      ),
    ];

  //Memanggil Class CountDownTimer dideklarasikan menjadi timer
  final CountDownTimer timer = CountDownTimer();

   String buttonText = 'Resume';

  @override
  Widget build(BuildContext context) {
    TimerModel timerModel = TimerModel(
      time: '00:00',
      percent: 1.0,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productivity Timer'),
        actions: [
           Switch(
            value: AdaptiveTheme.of(context).mode.isDark,
            onChanged: (value) {
              if (value) {
                AdaptiveTheme.of(context).setDark();
              } else {
                AdaptiveTheme.of(context).setLight();
              }
            },
          ),
            PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return menuItems.toList();
            },
            onSelected: (s) {
              if (s == SETTINGS) {
                goToSettings(context);
              } else if (s == SWITCHTHEME) {
                // Toggle the theme when Switch Theme is selected
                if (AdaptiveTheme.of(context).mode.isDark) {
                  AdaptiveTheme.of(context).setLight();
                } else {
                  AdaptiveTheme.of(context).setDark();
                }
              }
              
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double availableWidth = constraints.maxWidth;
          return Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(defaultPadding),
                  ),
                  Expanded(
                    child: ProductivityButton(
                      color: Colors.indigo.shade900,
                      text: 'Work',
                      onPressed: () {
                        setState(() {
                          buttonText = 'Pause';
                        });
                        //Memanggil Method startWork 
                        timer.startWork();
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(defaultPadding),
                  ),
                  Expanded(
                    child: ProductivityButton(
                      color: Colors.indigo.shade600,
                      text: 'Short Break',
                      onPressed: () {
                        setState(() {
                          buttonText = 'Pause';
                        });
                        //Memanggil Method starBreak (Short Break)
                        timer.startBreak(true);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(defaultPadding),
                  ),
                  Expanded(
                    child: ProductivityButton(
                      color: Colors.indigo.shade300,
                      text: 'Long Break',
                      onPressed: () {                       
                        setState(() {
                          buttonText = 'Pause';
                        });
                        //Memanggil Method starBreak (Long Break)
                        timer.startBreak(false);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(defaultPadding),
                  ),
                ],
              ),
              StreamBuilder(
                  initialData: '00:00',
                  stream: timer.stream(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    timerModel =
                        snapshot.data == '00:00' ? timerModel : snapshot.data;

                    return Expanded(
                      child: CircularPercentIndicator(
                        radius: availableWidth / 2.5,
                        lineWidth: 20,
                        percent: timerModel.percent,
                        progressColor: Colors.indigo.shade500,
                        circularStrokeCap: CircularStrokeCap.round,
                        reverse: true,
                        center: Text(
                          timerModel.time,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ),
                    );
                  }),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(defaultPadding),
                  ),
                  Expanded(
                    child: ProductivityButton(
                      color: Colors.blue.shade800,
                      text: buttonText,
                      onPressed: () {
                        //Mengganti CountDownTimer menjadi timer
                        if (timer.isActive) {
                          timer.stopTimer();
                          setState(() {
                            buttonText = 'Resume';
                          });
                        } else {
                          timer.startTimer();
                          setState(() {
                            buttonText = 'Pause';
                          });
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(defaultPadding),
                  ),
                  Expanded(
                    child: ProductivityButton(
                      color: Colors.blue.shade900,
                      text: 'Reset',
                      //Mengubah Jenis onPressed
                      onPressed: () {
                        setState(() {
                          buttonText = 'Resume';
                        });
                        //Memanggil Method reset
                        timer.reset();
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(defaultPadding),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void goToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CupertinoSettings(),
      ),
    );
  }

  void emptyMethod() {}
}
