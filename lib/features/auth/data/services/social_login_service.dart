import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// 소셜 로그인 결과.
///
/// [provider]는 서버에 전달할 공급자 식별자,
/// [token]은 각 SDK에서 발급받은 인증 토큰입니다.
class SocialLoginResult {
  final String provider;
  final String token;

  const SocialLoginResult({required this.provider, required this.token});
}

/// 각 소셜 플랫폼 SDK를 래핑하여 인증 토큰을 획득하는 서비스.
///
/// 프레젠테이션 레이어에서 직접 SDK를 호출하지 않고
/// 이 서비스를 통해 일관된 [SocialLoginResult]를 반환받습니다.
class SocialLoginService {
  // ── 카카오 ──────────────────────────────────────────────────────────────

  /// 카카오톡 앱이 설치되어 있으면 앱 로그인, 아니면 웹 로그인을 시도합니다.
  Future<SocialLoginResult> loginWithKakao() async {
    kakao.OAuthToken token;

    if (await kakao.isKakaoTalkInstalled()) {
      token = await kakao.UserApi.instance.loginWithKakaoTalk();
    } else {
      token = await kakao.UserApi.instance.loginWithKakaoAccount();
    }

    return SocialLoginResult(
      provider: 'kakao',
      token: token.accessToken,
    );
  }

  // ── Apple ───────────────────────────────────────────────────────────────

  /// Apple 로그인을 시도하고 identityToken을 반환합니다.
  Future<SocialLoginResult> loginWithApple() async {
    final rawNonce = _generateNonce();
    final nonce = _sha256ofString(rawNonce);

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final identityToken = credential.identityToken;
    if (identityToken == null) {
      throw Exception('Apple 로그인 실패: identityToken이 null입니다.');
    }

    return SocialLoginResult(
      provider: 'apple',
      token: identityToken,
    );
  }

  // ── Google ──────────────────────────────────────────────────────────────

  /// Google 로그인을 시도하고 idToken을 반환합니다.
  Future<SocialLoginResult> loginWithGoogle() async {
    final googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize();

    final account = await googleSignIn.authenticate();
    final auth = await account.authorizationClient
        .authorizationForScopes(<String>['email']);

    final idToken = auth?.accessToken;
    if (idToken == null) {
      throw Exception('Google 로그인 실패: accessToken이 null입니다.');
    }

    return SocialLoginResult(
      provider: 'google',
      token: idToken,
    );
  }

  // ── 유틸 ────────────────────────────────────────────────────────────────

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
