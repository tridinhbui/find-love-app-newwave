import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_bloc/blocs/app_cubit.dart';
import 'package:flutter_base_bloc/commons/export_commons.dart';
import 'package:flutter_base_bloc/generated/l10n.dart';
import 'package:flutter_base_bloc/network/api_client.dart';
import 'package:flutter_base_bloc/network/api_util.dart';
import 'package:flutter_base_bloc/repositories/export_repositories.dart';
import 'package:flutter_base_bloc/router/application.dart';
import 'package:flutter_base_bloc/router/routers.dart';
import 'package:flutter_base_bloc/sign_in/sign_in_page.dart';
import 'package:flutter_base_bloc/ui/test.dart';
import 'package:flutter_base_bloc/ui/uis/sign_in/sign_in_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  //black
 // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
}

class MyApp extends StatefulWidget {
  MyApp() {
    final router = new FluroRouter();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  ApiClient? _apiClient;
  Color color = Colors.white;

  String _dropdownValue = "Dash";
  List<String> dropDownOptions = [
    "Dash",
    "Sparky",
    "Snoo",
    "Clippy",
  ];

  void dropdownCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _dropdownValue = selectedValue;
      });
    }
  }

  @override
  void initState() {
    _apiClient = ApiUtil.getApiClient();
    super.initState();
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(create: (context) {
          return AuthRepositoryImpl(_apiClient);
        }),
        RepositoryProvider<MovieRepository>(create: (context) {
          return MovieRepositoryImpl(_apiClient);
        }),
        RepositoryProvider<UserRepository>(create: (context) {
          return UserRepositoryImpl(_apiClient);
        }),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppCubit>(create: (context) {
            final userRepository = RepositoryProvider.of<UserRepository>(context);
            return AppCubit(
              userRepository: userRepository,
            );
          })
        ],
        child: materialApp(),
      ),
    );
  }

  MaterialApp materialApp() {
    //Setup PortraitUp only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      theme: AppThemes.theme,
      onGenerateRoute: Application.router?.generator,
      initialRoute: Routes.root,
      navigatorObservers: [
        // NavigationObserver(context.bloc<NavigationCubit>()),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        S.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home:  LogInPage(),
      // builder: (context, child) {
      //   return LogInPage();
      // },
    );
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
