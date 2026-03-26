import 'package:meetnow_frontend/core/error/failures.dart';
import 'package:meetnow_frontend/features/notification/domain/entities/app_notification.dart';

/// 알림 관련 데이터 조작의 계약(Contract).
abstract class NotificationRepository {
  /// 전체 알림 목록을 가져옵니다.
  ResultFuture<List<AppNotification>> getNotifications();

  /// 특정 알림을 읽음 처리합니다.
  ResultFuture<void> markAsRead(String notificationId);

  /// FCM 디바이스 토큰을 서버에 등록합니다.
  /// 앱 시작 시 또는 토큰 갱신 시 호출합니다.
  ResultFuture<void> registerDevice(String deviceToken);
}
