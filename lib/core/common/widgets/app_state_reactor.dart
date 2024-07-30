import 'package:flutter/material.dart';
import 'package:interval/core/common/app/app_state.dart';

class AppStateReactor extends StatefulWidget {
  const AppStateReactor({required this.child, super.key});

  final Widget child;

  @override
  State<AppStateReactor> createState() => _AppStateReactorState();
}

class _AppStateReactorState extends State<AppStateReactor> {
  @override
  void initState() {
    super.initState();
    AppState.instance.current.addListener(_onAppStateChange);
  }

  void _onAppStateChange() {
    final current = AppState.instance.current.value;
    final previous = AppState.instance.previous.value;
    switch (current) {
      case $State.IDLE:
        if (previous == $State.LOADING) Navigator.of(context).pop();
      case $State.LOADING:
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
