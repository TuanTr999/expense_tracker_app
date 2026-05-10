import 'package:expense_tracker_app/core/network/dio_client.dart';
import 'package:expense_tracker_app/features/budget/data/datasources/budget_remote_datasource.dart';
import 'package:expense_tracker_app/features/budget/data/repositories/budget_repository_impl.dart';
import 'package:expense_tracker_app/features/budget/presentation/blocs/budget_bloc.dart';
import 'package:expense_tracker_app/features/categories/data/datasources/category_remote_datasource.dart';
import 'package:expense_tracker_app/features/navigation/presentation/pages/main/main_screen.dart';
import 'package:expense_tracker_app/features/transactions/data/datasources/transaction_remote_datasource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:expense_tracker_app/features/navigation/presentation/blocs/navigation/navigation_bloc.dart';

import '../features/categories/data/repositories/categoru_repository_impl.dart';
import '../features/categories/presentation/blocs/category/category_bloc.dart';
import '../features/transactions/data/repositories/transaction_repository_impl.dart';
import '../features/transactions/presentation/blocs/transaction/transaction_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});



  @override
  Widget build(BuildContext context) {
    final dio = DioClient().dio;
    final remoteSourceTransaction = TransactionRemoteDataSource(dio);
    final repositoryTransaction = TransactionRepositoryImpl(remoteSourceTransaction);

    final remoteSourceCategory = CategoryRemoteDataSource(dio);
    final repositoryCategory = CategoryRepositoryImpl(remoteSourceCategory);

    final remoteSourceBudget = BudgetRemoteDatasource(dio);
    final repositoryBudget = BudgetRepositoryImpl(remoteSourceBudget);

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
          BlocProvider(create: (_) => TransactionBloc(repositoryTransaction)),
          BlocProvider(create: (_) => CategoryBloc(repositoryCategory)),
          BlocProvider(create: (_) => BudgetBloc(repositoryBudget))
        ],
        child: MainScreen(),
      ),
    );
  }
}

