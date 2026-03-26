import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 앱의 메인 화면 뼈대를 구성하는 위젯.
///
/// [StatefulNavigationShell]을 body로 사용해 탭 전환 시 각 브랜치의
/// 내비게이션 스택 상태를 유지합니다 (indexedStack 방식).
///
/// 하단 탭:
/// - 탐색(0): 상대방 프로필 카드 스와이프
/// - 채팅(1): 채팅방 목록
/// - 프로필(2): 내 프로필
class MainScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell, // 현재 활성화된 탭의 화면을 표시
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          // 이미 현재 탭이면 해당 브랜치의 초기 위치(루트)로 이동
          initialLocation: index == navigationShell.currentIndex,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: '탐색',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: '채팅',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: '프로필',
          ),
        ],
      ),
    );
  }
}
