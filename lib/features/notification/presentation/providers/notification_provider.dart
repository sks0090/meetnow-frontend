import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meetnow_frontend/features/notification/domain/entities/app_notification.dart';

// TODO: NotificationRepository와 데이터소스 Provider를 구현한 후 이 Provider에 연결하세요.

/// 알림 목록을 관리하는 AsyncNotifierProvider.
///
/// 현재는 데이터 레이어가 미구현 상태입니다.
/// [NotificationRepository] 구현 후 [build]에서 실제 데이터를 로드하도록 수정하세요.
final notificationsProvider =
    AsyncNotifierProvider<NotificationNotifier, List<AppNotification>>(
  NotificationNotifier.new,
);

/// 알림 목록 상태를 관리하는 AsyncNotifier (stub).
class NotificationNotifier extends AsyncNotifier<List<AppNotification>> {
  @override
  Future<List<AppNotification>> build() async {
    // TODO: Fetch notifications from repository
    return [];
  }
}
