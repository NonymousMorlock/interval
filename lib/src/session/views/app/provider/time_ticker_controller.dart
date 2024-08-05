import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:interval/core/extensions/duration_extensions.dart';

class TimeTickerController extends ChangeNotifier {
  TimeTickerController(this.durationMilliseconds) {
    _endTime = DateTime.now().add(totalDuration);
    if (totalDuration.millisecondsPart > 0) {
      renderMilliseconds = true;
      rate = const Duration(milliseconds: 16);
    }
  }

  final int durationMilliseconds;
  Duration get totalDuration => Duration(milliseconds: durationMilliseconds);

  late DateTime _endTime;
  bool renderMilliseconds = false;
  Duration rate = const Duration(seconds: 1);

  late TickerProvider _tickerProvider;
  Ticker? _ticker;

  /// The time remaining when the ticker is paused
  int? _pauseTime;

  /// The time remaining in milliseconds or seconds
  int get remainingTime {
    final currentTime = DateTime.now();
    final difference = _endTime.difference(currentTime);
    if (difference.isNegative) return 0;
    return renderMilliseconds
        ? difference.inMilliseconds
        : difference.inSeconds;
  }

  /// Return true if the ticker is running
  ///
  /// Uses [Ticker.isActive] instead of [Ticker.isTicking]
  bool get isRunning => _ticker?.isActive ?? false;

  /// Return true if the ticker is paused
  bool get isPaused => _pauseTime != null;

  /// Initialize the ticker
  ///
  /// This method should be called in the [initState] method of the State
  /// object. The [tickerProvider] is the [State] object itself if it uses
  /// the [TickerProviderStateMixin], and the [dispose] method should be
  /// called in the [dispose] method of the State object.
  ///
  /// Alternatively, you could create a [TickerProvider] manually.
  ///
  /// **Example using the [State] Object:**
  ///
  /// ```dart
  /// class FooState extends State<Foo> with SingleTickerProviderStateMixin {
  ///
  ///   late TimeTickerController _controller;
  ///
  ///   @override
  ///   void initState() {
  ///     super.initState();
  ///     _controller = TimeTickerController(1000)..init(this);
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {...}
  ///
  /// }
  /// ```
  ///
  /// **Example using a custom [TickerProvider]:**
  ///
  /// ```dart
  /// class MyTickerProvider implements TickerProvider {
  ///   @override
  ///   Ticker createTicker(TickerCallback onTick) {
  ///     return Ticker(onTick);
  ///     // or return Ticker(onTick, debugLabel: 'MyTicker');
  ///     // or return Ticker(onTick, debugLabel: 'MyTicker', muted: true);
  ///     // or return Ticker(onTick, debugLabel: 'MyTicker', desiredFrameRate: 60);
  ///   }
  /// }
  /// ```
  ///
  /// **Usage:** `TimeTickerController(1000).init(MyTickerProvider());`
  ///
  void init(TickerProvider tickerProvider) {
    stopTicker();
    _tickerProvider = tickerProvider;
    _ticker = _tickerProvider.createTicker((elapsed) {
      if (remainingTime <= 0) {
        stopTicker();
      } else {
        notifyListeners();
      }
    });
  }

  /// Start the ticker
  void startTicker() {
    if (isRunning) return;
    if (isPaused) {
      _endTime = DateTime.now().add(Duration(milliseconds: _pauseTime!));
      _pauseTime = null;
    } else {
      _endTime = DateTime.now().add(totalDuration);
    }
    _ticker?.start();
    notifyListeners();
  }

  /// Pause the ticker
  void pauseTicker() {
    if (!isRunning) return;
    _pauseTime = remainingTime;
    stopTicker();
  }

  /// Resume the ticker
  void resumeTicker() {
    startTicker();
  }

  /// Stop the ticker
  void stopTicker() {
    _ticker?.stop();
    notifyListeners();
  }

  @override
  void dispose() {
    stopTicker();
    _ticker?.dispose();
    super.dispose();
  }
}
