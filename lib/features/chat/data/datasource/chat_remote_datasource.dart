import 'package:dio/dio.dart';
import 'package:meetnow_frontend/core/constants/api_paths.dart';
import 'package:meetnow_frontend/features/chat/data/models/chat_model.dart';
import 'package:meetnow_frontend/features/chat/data/models/message_model.dart';

/// 채팅 API 데이터소스 계약.
abstract class ChatRemoteDataSource {
  Future<List<ChatModel>> getChatList();
  Future<List<MessageModel>> getMessages(String chatId, {int page = 1});
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
