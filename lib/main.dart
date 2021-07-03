import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

import 'cubit/counter_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterCubit(),
      child: MaterialApp(
        title: 'Bloc counter',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: MyHomePage(title: 'Bloc counter'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        decoration: BoxDecoration(
          // Box decoration takes a gradient
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            // Add one stop for each color. Stops should increase from 0 to 1
            stops: [0.1, 0.5, 0.7, 0.9],
            colors: [
              // Colors are easy thanks to Flutter's Colors class.
              Color(0xFF42A5F5),
              Color(0xFFBBDEFB),
              Color(0xFF9FA8DA),
              Color(0xFF00ACC1),
            ],
          ),
        ),
        child: BlocListener<CounterCubit, CounterState>(
          listener: (context, state) {
            if (state.counterValue == 0) {
              FlutterRingtonePlayer.playNotification();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Finished!'),
                duration: Duration(seconds: 5),
              ));
            }
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Set time then press play to count down',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingActionButton(
                        onPressed: () {
                          BlocProvider.of<CounterCubit>(context).decrement();
                        },
                        tooltip: 'Decrease',
                        child: Icon(Icons.remove)),
                    BlocBuilder<CounterCubit, CounterState>(
                      builder: (context, state) {
                        return Text(
                          state.counterValue.toString(),
                          style: Theme.of(context).textTheme.headline4,
                        );
                      },
                    ),
                    FloatingActionButton(
                        onPressed: () {
                          BlocProvider.of<CounterCubit>(context).increment();
                        },
                        tooltip: 'Increase',
                        child: Icon(Icons.add)),
                  ],
                ),
                FloatingActionButton(
                    onPressed: () {
                      BlocProvider.of<CounterCubit>(context).starttimer();
                    },
                    tooltip: 'Start',
                    child: Icon(Icons.arrow_back_rounded)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
