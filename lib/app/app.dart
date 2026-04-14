import 'package:expense_tracker_app/features/navigation/presentation/pages/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:expense_tracker_app/features/transactions/presentation/blocs/filter/filter_bloc.dart';
import 'package:expense_tracker_app/features/navigation/presentation/blocs/navigation/navigation_bloc.dart';

import '../features/categories/data/datasources/category_local_data_source.dart';
import '../features/categories/data/repositories/categoru_repository_impl.dart';
import '../features/categories/presentation/blocs/category/category_bloc.dart';
import '../features/transactions/data/datasources/transaction_local_datasource.dart';
import '../features/transactions/data/repositories/transaction_repository_impl.dart';
import '../features/transactions/presentation/blocs/transaction/transaction_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});



  @override
  Widget build(BuildContext context) {
    final dataSourceTransaction = TransactionLocalDataSource();
    final repositoryTransaction = TransactionRepositoryImpl(dataSourceTransaction);

    final dataSourceCategory = CategoryLocalDataSource();
    final repositoryCategory = CategoryRepositoryImpl(dataSourceCategory);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Locale('vi'),
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
          BlocProvider(create: (_) => TransactionBloc(repositoryTransaction)),
          BlocProvider(create: (_) => CategoryBloc(repositoryCategory))
        ],
        child: MainScreen(),
      ),
    );
  }
}

