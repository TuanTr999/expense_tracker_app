import 'package:expense_tracker_app/screens/home/home_tab.dart';
import 'package:expense_tracker_app/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'blocs/filter/filter_bloc.dart';
import 'blocs/navigation/navigation_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Locale('vi'), //

      supportedLocales: [
        Locale('en'),
        Locale('vi'),
      ],

      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => NavigationBloc()),
          BlocProvider(create: (_) => FilterBloc()),
        ],
        child: MainScreen(),
      )
    );
  }
}
