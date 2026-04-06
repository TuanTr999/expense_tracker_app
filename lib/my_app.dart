import 'package:expense_tracker_app/screens/home/home_tab.dart';
import 'package:expense_tracker_app/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/filter/filter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => FilterBloc(),
        child: MainScreen(),
      ),
    );
  }
}
