import 'package:dio/dio.dart';
import 'package:meetnow_frontend/core/constants/api_paths.dart';
import 'package:meetnow_frontend/features/chat/data/models/chat_model.dart';
import 'package:meetnow_frontend/features/chat/data/models/message_model.dart';

/// 채팅 API 데이터소스 계약.
///
/// 채팅방 목록 조회, 메시지 페이징 로드, 메시지 전송 기능을 정의합니다.
abstract class ChatRemoteDataSource {
  /// 내가 속한 전체 채팅방 목록을 서버에서 가져옵니다.
  Future<List<ChatModel>> getChatList();

  /// [chatId] 채팅방의 메시지를 [page] 단위로 가져옵니다.
  Future<List<MessageModel>> getMessages(String chatId, {int page = 1});

  /// [chatId] 채팅방에 메시지를 전송합니다. [type]은 메시지 유형 (기본: 'text').
  Future<MessageModel> sendMessage({
    required String chatId,
    required String content,
    String type = 'text',
  });
}

/// [ChatRemoteDataSource] Dio 기반 구현체.
///
/// 메시지 목록은 페이지 단위로 불러올 수 있습니다 (queryParameters page).
class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio _dio;

  const ChatRemoteDataSourceImpl(this._dio);

  @override
  Future<List<ChatModel>> getChatList() async {
    final response = await _dio.get(ApiPaths.chats);
    final data = response.data as List;
    return data
        .map((e) => ChatModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<MessageModel>> getMessages(
    String chatId, {
    int page = 1,
  }) async {
    final response = await _dio.get(
      ApiPaths.chatMessages(chatId),
      queryParameters: {'page': page},
    );
    final data = response.data as List;
    return data
        .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<MessageModel> sendMessage({
    required String chatId,
    required String content,
    String type = 'text',
  }) async {
    final response = await _dio.post(
      ApiPaths.chatMessages(chatId),
      data: {'content': content, 'type': type},
    );
    return MessageModel.fromJson(response.data as Map<String, dynamic>);
  }
}
