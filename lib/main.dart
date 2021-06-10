import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apprev/layout/cubit/states.dart';
import 'package:flutter_apprev/shared/bloc_observer.dart';
import 'package:flutter_apprev/shared/components/components.dart';
import 'package:flutter_apprev/shared/components/constants.dart';
import 'package:flutter_apprev/shared/cubit/cubit.dart';
import 'package:flutter_apprev/shared/cubit/states.dart';
import 'package:flutter_apprev/shared/network/local/cache/cache_helper.dart';
import 'package:flutter_apprev/shared/network/remote/dio_helper.dart';
import 'package:flutter_apprev/shared/styles/themes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'layout/cubit/cubit.dart';
import 'layout/social_layout.dart';
import 'modules/social_login/social_login_screen.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async
{
  print('on background message');
  print(message.data.toString());

  showToast(text: 'on background message', state: ToastStates.SUCCESS,);
}

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  var token = await FirebaseMessaging.instance.getToken();

  print(token);


  // foreground fcm
  FirebaseMessaging.onMessage.listen((event)
  {
    print('on message');
    print(event.data.toString());

    showToast(text: 'on message', state: ToastStates.SUCCESS,);
  });

  // when click on notification to open app
  FirebaseMessaging.onMessageOpenedApp.listen((event)
  {
    print('on message opened app');
    print(event.data.toString());
    showToast(text: 'on message opened app', state: ToastStates.SUCCESS,);
  });

  // background fcm
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  bool isDark = CacheHelper.getData(key: 'isDark');

  Widget widget;
  uId = CacheHelper.getData(key: 'uId');

  if(uId != null)
  {
    widget = SocialLayout();
  } else
    {
      widget = SocialLoginScreen();
    }

  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));
}

// Stateless
// Stateful

// class MyApp

class MyApp extends StatelessWidget
{
  // constructor
  // build
  final bool isDark;
  final Widget startWidget;

  MyApp({
    this.isDark,
    this.startWidget,
  });

  @override
  Widget build(BuildContext context)
  {
    return MultiBlocProvider(
      providers: [

        BlocProvider(
          create: (BuildContext context) => AppCubit()
            ..changeAppMode(
              fromShared: isDark,
            ),
        ),
        BlocProvider(
          create: (BuildContext context) => SocialCubit()..getUserData()..getPosts(),
        ),
      ],
      child: BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );
  }
}

// ./gradlew signingReport