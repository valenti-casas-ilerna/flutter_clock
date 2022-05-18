import 'package:flutter/material.dart';

// Timer
import 'dart:async';

// Flutter Picker
import 'package:flutter_material_pickers/flutter_material_pickers.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chronos',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer? countdownTimer;
  Duration myDuration = const Duration(seconds: 0);
  bool isActive = false;

  int currHours = 0;
  int currMinutes = 0;
  int currSeconds = 0;

  void startStopTimer() {
    if (isActive) {
      stopTimer();
    } else {
      countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
      isActive = true;
    }
  }

  void stopTimer() {
    setState(() {
      countdownTimer!.cancel();
      isActive = false;
    });
  }

  void resetTimer() {
    if (isActive) {
      stopTimer();
    }
    setState(() => myDuration = Duration(hours: currHours, minutes: currMinutes, seconds: currSeconds));
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;

      if (seconds < 0) {
        countdownTimer!.cancel();
        isActive = false;
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  Text crearTimerText({required String text}) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontSize: 75,
        fontFamily: 'Pacifico',
      ),
    );
  }

  void seleccionarTiempo(String tiempo, int currentNum) {
    showMaterialNumberPicker(
      context: context,
      title: 'Seleccione $tiempo',
      maxNumber: 59,
      minNumber: 0,
      selectedNumber: currentNum,
      onChanged: (value) {
        setState(() {
          if (tiempo == 'Horas') {
            currHours = value;
          } else if (tiempo == 'Minutos') {
            currMinutes = value;
          } else if (tiempo == 'Segundos') {
            currSeconds = value;
          }

          myDuration = Duration(hours: currHours, minutes: currMinutes, seconds: currSeconds);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final hours = strDigits(myDuration.inHours.remainder(24));
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuenta atrás'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () => seleccionarTiempo('Horas', myDuration.inHours),
                    child: crearTimerText(text: hours),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  crearTimerText(text: ':'),
                  InkWell(
                    onTap: () => seleccionarTiempo('Minutos', myDuration.inMinutes),
                    child: crearTimerText(text: minutes),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  crearTimerText(text: ':'),
                  InkWell(
                    onTap: () => seleccionarTiempo('Segundos', myDuration.inSeconds),
                    child: crearTimerText(text: seconds),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => startStopTimer(),
                  child: Icon(isActive ? Icons.pause : Icons.play_arrow, size: 65.0),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(const CircleBorder()),
                    padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => resetTimer(),
                  child: const Icon(Icons.replay, size: 65.0),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(const CircleBorder()),
                    padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                    /*
                    backgroundColor: MaterialStateProperty.all(Colors.blue), // <-- Button color
                    overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
                      if (states.contains(MaterialState.pressed)) return Colors.red; // <-- Splash color
                    }),
                    */
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
