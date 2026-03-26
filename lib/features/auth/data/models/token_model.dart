/// 서버가 반환하는 인증 토큰 데이터 모델.
///
/// 로그인/회원가입 응답에서 받은 토큰을 담을 때 사용합니다.
/// 토큰은 [AuthLocalDataSource]를 통해 [FlutterSecureStorage]에 저장됩니다.
class TokenModel {
  /// 단기 유효 액세스 토큰. API 요청 시 Authorization 헤더에 사용합니다.
  final String accessToken;

  /// 장기 유효 리프레시 토큰. 액세스 토큰 만료 시 업데이트에 사용합니다.
  final String refreshToken;

  /// 액세스 토큰의 유효 시간(초 단위).
  final int expiresIn;

  const TokenModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  /// 서버 JSON 응답으로 [TokenModel]을 생성합니다.
  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresIn: json['expires_in'] as int,
    );
  }
}
