import 'package:flutter/foundation.dart';
import 'package:rive/rive.dart';

class TimerAnimationController extends ChangeNotifier {
  SMITrigger? _startTrigger;
  SMITrigger? _pauseTrigger;
  SMITrigger? _resetTrigger;
  StateMachineController? _stateController;

  String _state = 'Idle';

  SMITrigger? get startTrigger => _startTrigger;

  SMITrigger? get pauseTrigger => _pauseTrigger;

  SMITrigger? get resetTrigger => _resetTrigger;

  void setState(String state) {
    if (_state != state) _state = state;
  }

  void start() {
    _startTrigger?.fire();
  }

  void pause() {
    _pauseTrigger?.fire();
  }

  void reset() {
    if (_state != 'Stop') return;
    _resetTrigger?.fire();
  }

  void onInit(Artboard artboard) {
    _stateController = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
      onStateChange: (stateMachineName, stateName) {
        setState(stateName);
      },
    );
    artboard.addController(_stateController!);
    _startTrigger = _stateController!.findInput<bool>('Start')! as SMITrigger;
    _pauseTrigger = _stateController!.findInput<bool>('Stop')! as SMITrigger;
    _resetTrigger = _stateController!.findInput<bool>('Reset')! as SMITrigger;
  }
}
