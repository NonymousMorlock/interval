import 'package:device_preview/device_preview.dart';
import 'package:interval/app/app.dart';
import 'package:interval/bootstrap.dart';
import 'package:interval/core/singletons/current_platform.dart';

void main() {
  bootstrap(
    () => DevicePreview(
      enabled: CurrentPlatform.instance.isDesktop,
      builder: (_) => const App(),
    ),
  );
}
