import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

part 'counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  Timer? _timer;
  CounterCubit() : super(CounterState(counterValue: 1));

  void increment() => emit(CounterState(counterValue: state.counterValue + 10));
  void decrement() {
    if (state.counterValue > 10) {
      emit(CounterState(counterValue: state.counterValue - 10));
    } else
      emit(CounterState(counterValue: state.counterValue - 1));
  }

  void starttimer() {
    if (_timer == null) {
      _timer = new Timer.periodic(new Duration(seconds: 1), (t) {
        if (state.counterValue > 0) {
          emit(CounterState(counterValue: state.counterValue - 1));
        } else {
          _timer!.cancel();
          _timer = null;
          FlutterRingtonePlayer.playNotification();
        }
      });
    }
  }
}
