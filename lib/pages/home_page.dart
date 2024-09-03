import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:risenger/services/alert_service.dart';
import 'package:risenger/services/auth_service.dart';
import 'package:risenger/services/navigation_service.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final GetIt getIt = GetIt.instance;

  late AuthService _authService;
  late NavigationService  _navigationService;
  late AlertService _alertService;

  @override
  void initState() {
    super.initState();
    _authService = getIt.get<AuthService>();
    _navigationService = getIt.get<NavigationService>();
    _alertService = getIt.get<AlertService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async{
              bool result = await _authService.logout();
              if(result){
                _alertService.showToast(text: "Logged out successfully");
                _navigationService.pushReplacementNamed("/login");
              }
            },
            color: Colors.red,
          )
        ]
      ),
    );
  }
}