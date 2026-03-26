import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [FlutterSecureStorage] 인스턴스를 제공하는 Provider.
///
/// 토큰 등의 민감한 데이터를 저장할 때 사용합니다.
/// iOS 키체인, Android Keystore를 통해 암호화됩니다.
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

/// [SharedPreferences] 인스턴스를 제공하는 Provider.
///
/// 비민감 앱 설정 데이터를 저장할 때 사용합니다.
/// 비동기로 초기화해야 하므로 [main.dart]에서 미리 인스턴스를 생성한 후
/// `ProviderScope(overrides: [sharedPreferencesProvider.overrideWithValue(...)])`
/// 로 주입합니다. override 없이 사용하면 [UnimplementedError]가 발생합니다.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});
