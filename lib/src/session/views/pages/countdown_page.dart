import 'package:flutter/material.dart';
import 'package:interval/core/common/models/interval_session.dart';

class CountdownPage extends StatelessWidget {
  const CountdownPage(this.session, {super.key});

  static const path = '/countdown';

  final IntervalSession session;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(session.title),
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Placeholder(
              color: Colors.red,
              child: Center(
                child: Text('Countdown', style: TextStyle(fontSize: 32)),
              ),
            ),
          ),
          Expanded(
            child: Placeholder(
              color: Colors.blue,
              child: Center(
                child: Text('Animation', style: TextStyle(fontSize: 32)),
              ),
            ),
          ),
          Expanded(
            child: Placeholder(
              color: Colors.green,
              child: Center(
                child: Text('Controls', style: TextStyle(fontSize: 32)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
