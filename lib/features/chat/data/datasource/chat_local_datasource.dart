/// 채팅 로컬 캐시를 위한 로컬 데이터소스 (stub).
///
/// 현재는 구현체가 비어 있습니다.
/// 향후 오프라인 지원을 위한 메시지 캐싱 등을 하려면 이곳에 구현하세요.
abstract class ChatLocalDataSource {
  // Future implementations for local caching
  // e.g., cache recent messages for offline support
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  const ChatLocalDataSourceImpl();
}
