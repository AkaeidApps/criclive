import '../../core/constants/demo_config.dart';
import 'repository_exception.dart';

/// Shared async simulation for bundled demo repositories.
Future<T> loadDemo<T>(T Function() builder) async {
  if (DemoConfig.networkDelay > Duration.zero) {
    await Future<void>.delayed(DemoConfig.networkDelay);
  }
  if (DemoConfig.simulateErrors) {
    throw const RepositoryException(
      'Demo refresh failed. Check the connection and try again.',
    );
  }
  return builder();
}
