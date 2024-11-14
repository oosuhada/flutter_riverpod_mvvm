import 'package:flutter_riverpod_mvvm/user.dart';
import 'package:flutter_riverpod_mvvm/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. HomePage에서 사용하는 상태 클래스 정의
class HomeState {
  HomeState({
    required this.user,
    required this.fetchTime,
  });
  // 유저 정보를 가지고 오지 않았을 때에는 User가 null!
  User? user;
  // 데이터를 가지고 온 시간. 마찬가치로 초기에는 null
  DateTime? fetchTime;
}

// 2. ViewModel 구현 Notifier를 상속
// Notifier : 상태를 관리(저장, 업데이트)하고
//            업데이트 시 구독하고 있는 위젯에 변경이 되었다고 알려주는 역할
// Notifier 상속 시 이 ViewModel 이 어떤 상태를 관리할 지 제너릭으로 명시
class HomeViewModel extends Notifier<HomeState> {
  // 3. build 함수 : ViewModel의 최초 상태를 초기화
  @override
  HomeState build() {
    return HomeState(
      user: null, // 초기 상태 null
      fetchTime: null,
    );
  }

  // 4. 유저 정보 UserRepository에서 가져와서 상태 업데이트 하는 로직 구현
  void getUser() async {
    UserRepository userRepository = UserRepository();
    User user = await userRepository.getUser();
    // 이렇게 사용하면 안됨. Notifier 클래스는 새로운 상태 객체를 사용해야 위젯에게 알려줌
    // state.user = user;
    // state.fetchTime = DateTime.now();
    // 이렇게 새로운 객체를 상테에 할당!
    state = HomeState(
      user: user,
      fetchTime: DateTime.now(),
    );
  }
}

// 5. RiverPod은 ViewModel을 위젯에서 직접 생성자 호출(HomeViewModel())해서 사용하는게 아니라
//    자체적으로 관리를해줌.
//    HomeViewModel 을 A라는 위젯에서 처음 사용하면 새로운 HomeViewModel 생성
//    => 여기서 B라는 위젯에서 HomeViewModel 을 사용할 때 riverpod Provider가 기존에 생성된 HomeViewModel을 돌려줌
//    사용법 : NotifierProvider 클래스를 이용해 HomeVideModel 제공
//           NotifierProvider 상속받을 때 ViewModel 클래스 타입, ViewModel에서 관리하는 상태의 클래스 타입 명시
final homeViewModelProvider = NotifierProvider<HomeViewModel, HomeState>(() {
  return HomeViewModel();
});
