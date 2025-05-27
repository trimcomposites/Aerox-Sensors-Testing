import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocPeriodicEventDispatcher<TBloc extends Bloc<TEvent, dynamic>, TEvent>
    extends StatefulWidget {
  final Duration interval;
  final TBloc bloc;
  final List<TEvent> Function() eventsBuilder;

  const BlocPeriodicEventDispatcher({
    super.key,
    required this.interval,
    required this.bloc,
    required this.eventsBuilder,
  });

  @override
  State<BlocPeriodicEventDispatcher<TBloc, TEvent>> createState() =>
      _BlocPeriodicEventDispatcherState<TBloc, TEvent>();
}

class _BlocPeriodicEventDispatcherState<TBloc extends Bloc<TEvent, dynamic>, TEvent>
    extends State<BlocPeriodicEventDispatcher<TBloc, TEvent>> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(widget.interval, (_) {
      final events = widget.eventsBuilder();
      for (final event in events) {
        widget.bloc.add(event);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
