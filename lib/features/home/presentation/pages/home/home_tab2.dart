// import 'package:expense_tracker_app/features/categories/presentation/blocs/category/category_bloc.dart';
// import 'package:expense_tracker_app/features/transactions/presentation/blocs/filter/filter_state.dart';
// import 'package:expense_tracker_app/features/transactions/presentation/blocs/transaction/transaction_bloc.dart';
// import 'package:expense_tracker_app/features/transactions/presentation/blocs/transaction/transaction_event.dart';
// import 'package:expense_tracker_app/features/transactions/presentation/pages/all_transactions_page.dart';
// import 'package:expense_tracker_app/shared/widgets/app_bar/custom_app_bar.dart';
// import 'package:expense_tracker_app/shared/widgets/budget_card.dart';
// import 'package:expense_tracker_app/shared/widgets/summary_card.dart';
// import 'package:expense_tracker_app/shared/widgets/transaction_item.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import 'package:expense_tracker_app/features/transactions/presentation/blocs/filter/filter_bloc.dart';
// import 'package:expense_tracker_app/features/transactions/presentation/blocs/filter/filter_event.dart';
// import 'package:expense_tracker_app/core/utils/current_date.dart';
// import 'package:expense_tracker_app/core/utils/transaction_util.dart';
// import 'package:expense_tracker_app/core/utils/format.dart';
//
// import '../../../../categories/presentation/blocs/category/category_state.dart';
// import '../../../../transactions/presentation/blocs/transaction/transaction_state.dart';
// import '../../../../transactions/presentation/pages/add_transaction_page.dart';
//
// class HomeTab extends StatefulWidget {
//   const HomeTab({super.key});
//
//   @override
//   State<HomeTab> createState() => _HomeTabState();
// }
//
// class _HomeTabState extends State<HomeTab> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<TransactionBloc>().add(LoadTransactionEvent());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFF5F5F5),
//       appBar: CustomAppBar(),
//       body: Stack(
//         children: [
//           MultiBlocListener(
//             listeners: [
//               BlocListener<TransactionBloc, TransactionState>(
//                 listener: (context, state) {
//                   context.read<FilterBloc>().add(
//                     SetTransactions(state.transactions),
//                   );
//                 },
//               ),
//               BlocListener<CategoryBloc, CategoryState>(
//                 listener: (context, state) {
//                   if (state.isDeleted) {
//                     context.read<TransactionBloc>().add(LoadTransactionEvent());
//                   }
//                 },
//               ),
//             ],
//             child: Padding(
//               padding: EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   Container(
//                     height: 50,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.only(left: 20, right: 20),
//                       child: BlocBuilder<FilterBloc, FilterState>(
//                         builder: (context, state) {
//                           return Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               filterItem('Ngày', FilterType.day, state),
//                               filterItem('Tháng', FilterType.month, state),
//                               filterItem('Năm', FilterType.year, state),
//                               filterItem('Tất cả', FilterType.all, state),
//                               filterItem('Tùy chỉnh', FilterType.custom, state),
//                             ],
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   BlocBuilder<FilterBloc, FilterState>(
//                     builder: (context, state) {
//                       if (state.filterType != FilterType.custom) {
//                         return Container();
//                       }
//                       return Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               InkWell(
//                                 onTap: () async {
//                                   final fromDate = await showDatePicker(
//                                     context: context,
//                                     initialDate: DateTime.now(),
//                                     firstDate: DateTime(2020),
//                                     lastDate: DateTime(2100),
//                                   );
//                                   if (fromDate != null) {
//                                     context.read<FilterBloc>().add(
//                                       ChangeFilterType(
//                                         FilterType.custom,
//                                         fromDate: fromDate,
//                                       ),
//                                     );
//                                   }
//                                 },
//                                 child: Container(
//                                   width: 110,
//                                   height: 40,
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       formatDate(
//                                         state.filterType,
//                                         state.fromDate,
//                                       ),
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.blue,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: 15),
//                               Text(
//                                 '-',
//                                 style: TextStyle(
//                                   fontSize: 30,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               SizedBox(width: 15),
//                               InkWell(
//                                 onTap: () async {
//                                   final toDate = await showDatePicker(
//                                     context: context,
//                                     initialDate: DateTime.now(),
//                                     firstDate: DateTime(2020),
//                                     lastDate: DateTime(2100),
//                                   );
//
//                                   if (toDate != null) {
//                                     context.read<FilterBloc>().add(
//                                       ChangeFilterType(
//                                         FilterType.custom,
//                                         toDate: toDate,
//                                       ),
//                                     );
//                                   }
//                                 },
//                                 child: Container(
//                                   width: 110,
//                                   height: 40,
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       formatDate(
//                                         state.filterType,
//                                         state.toDate,
//                                       ),
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.blue,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 20),
//                         ],
//                       );
//                     },
//                   ),
//                   BudgetCard(),
//                   SizedBox(height: 20),
//                   Row(
//                     children: [
//                       BlocBuilder<FilterBloc, FilterState>(
//                         builder: (context, state) {
//                           return Expanded(
//                             child: SummaryCard(
//                               title: 'Chi tiêu',
//                               amount: AppFormat.currency(
//                                 calculateTotalExpense(
//                                   state.filteredTransactions,
//                                 ),
//                               ),
//                               color: Colors.red,
//                             ),
//                           );
//                         },
//                       ),
//                       SizedBox(width: 20),
//                       BlocBuilder<FilterBloc, FilterState>(
//                         builder: (context, state) {
//                           return Expanded(
//                             child: SummaryCard(
//                               title: 'Thu nhập',
//                               amount: AppFormat.currency(
//                                 calculateTotalIncome(
//                                   state.filteredTransactions,
//                                 ),
//                               ),
//                               color: Colors.green,
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Danh sách giao dịch',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       BlocBuilder<FilterBloc, FilterState>(
//                         builder: (context, state) {
//                           return GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => MultiBlocProvider(
//                                     providers: [
//                                       BlocProvider.value(
//                                         value: context.read<FilterBloc>(),
//                                       ),
//                                       BlocProvider.value(
//                                         value: context.read<TransactionBloc>(),
//                                       ),
//                                       BlocProvider.value(
//                                         value: context.read<CategoryBloc>(),
//                                       ),
//                                     ],
//                                     child: AllTransactionsScreen(
//                                       transactions: state.groupedTransactions,
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                             child: Text(
//                               'Xem tất cả',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.blue,
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                   BlocBuilder<FilterBloc, FilterState>(
//                     builder: (context, state) {
//                       return Expanded(
//                         child: ListView.builder(
//                           itemCount: state.groupedTransactions.length,
//                           itemBuilder: (context, index) {
//                             final group = state.groupedTransactions[index];
//                             return Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                     vertical: 8,
//                                   ),
//                                   child: Text(
//                                     formatDate(FilterType.day, group.date),
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                                 ...group.items.map((item) {
//                                   return Padding(
//                                     padding: const EdgeInsets.only(bottom: 10),
//                                     child: TransactionItem(transaction: item),
//                                   );
//                                 }).toList(),
//                               ],
//                             );
//                           },
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 10,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: SizedBox(
//                 width: 150,
//                 height: 50,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     foregroundColor: Colors.black,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     elevation: 1,
//                   ),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => MultiBlocProvider(
//                           providers: [
//                             BlocProvider.value(
//                               value: context.read<TransactionBloc>(),
//                             ),
//                             BlocProvider.value(
//                               value: context.read<FilterBloc>(),
//                             ),
//                             BlocProvider.value(
//                               value: context.read<CategoryBloc>(),
//                             ),
//                           ],
//                           child: AddTransactionPage(),
//                         ),
//                       ),
//                     );
//                   },
//                   child: const Text(
//                     'Thêm',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget filterItem(String title, FilterType type, FilterState state) {
//     return InkWell(
//       onTap: () {
//         context.read<FilterBloc>().add(ChangeFilterType(type));
//       },
//       child: Text(
//         title,
//         style: TextStyle(
//           color: state.filterType == type ? Colors.black : Colors.grey,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }
