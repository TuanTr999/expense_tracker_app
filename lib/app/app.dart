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

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final TransactionBloc _transactionBloc;
  late final CategoryBloc _categoryBloc;
  late final BudgetBloc _budgetBloc;

  @override
  void initState() {
    super.initState();
    final dio = DioClient().dio;

    _transactionBloc = TransactionBloc(
      TransactionRepositoryImpl(TransactionRemoteDataSource(dio)),
    );
    _categoryBloc = CategoryBloc(
      CategoryRepositoryImpl(CategoryRemoteDataSource(dio)),
    );
    _budgetBloc = BudgetBloc(
      BudgetRepositoryImpl(BudgetRemoteDatasource(dio)),
    );
  }

  @override
  void dispose() {
    _transactionBloc.close();
    _categoryBloc.close();
    _budgetBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('vi'),
      supportedLocales: const [Locale('en'), Locale('vi')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => NavigationBloc()),
          BlocProvider.value(value: _transactionBloc),
          BlocProvider.value(value: _categoryBloc),
          BlocProvider.value(value: _budgetBloc),
        ],
        child: const MainScreen(),
      ),
    );
  }
}