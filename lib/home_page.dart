import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_mvvm/home_view_model.dart';

void main() {
  // 이 앱에서 ViewModel을 RiverPod이 관리하게 해주게 해줌
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      // ViewModel에 접근할 때 Consumer라는 위젯 사용
      body: Consumer(
        // 그 이유가 Consumer의 Builder 속성에서
        // WidgetRef를 전달해주는데
        // WidgetRef가 Notifier, 즉 ViewModel에 접근할 수 있게 해줌
        builder: (context, ref, child) {
          // ViewModel이 관리하는 상태에 접근 :
          //    ref.watch에 ViewModelProvider를 넣어주면 ViewModel의 상태를 반환해주고
          //    ViewModel이 업데이트 될 때마다 Consumer 위젯의 builder 가 재호출되어서 새로 그려짐
          HomeState homeState = ref.watch(homeViewModelProvider);
          // ref.read 함수도 있는데 read함수로 상태를 가지고 오면 업데이트 되어도 Consumer builder 재호출 안됨
          // HomeState homeState = ref.read(homeViewModelProvider);
          return Column(
            children: [
              Text('이름: ${homeState.user?.name ?? ""}'),
              Text('나이: ${homeState.user?.age ?? ""}'),
              Text('데이터 가져온 시간 : ${homeState.fetchTime ?? ""}'),
              GestureDetector(
                onTap: () {
                  // ViewModel에 직접 접근할 때는 homeViewModelProvider.notifier 를 넣어주어서 접근
                  // ViewModel 자체는 업데이트 되지 않기 때문에 read 사용
                  HomeViewModel homeViewModel =
                      ref.read(homeViewModelProvider.notifier);
                  homeViewModel.getUser();
                  print("클릭!");
                },
                child: Text('정보 가져오기'),
              ),
            ],
          );
        },
      ),
    );
  }
}
