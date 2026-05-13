import 'package:expense_tracker_app/core/constants/app_icon.dart';
import 'package:expense_tracker_app/core/enums/app_status.dart';
import 'package:expense_tracker_app/core/enums/app_type.dart';
import 'package:expense_tracker_app/features/categories/presentation/blocs/category/category_state.dart';
import 'package:expense_tracker_app/features/categories/presentation/pages/add_category.dart';
import 'package:expense_tracker_app/features/categories/presentation/pages/update_category.dart';
import 'package:expense_tracker_app/features/transactions/presentation/blocs/transaction/transaction_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../transactions/presentation/blocs/transaction/transaction_bloc.dart';
import '../blocs/category/category_bloc.dart';
import '../blocs/category/category_event.dart';

class AllCategory extends StatefulWidget {
  const AllCategory({super.key});

  @override
  State<AllCategory> createState() => _AllCategoryState();
}

class _AllCategoryState extends State<AllCategory> {
  AppType? type;

  @override
  void initState() {
    super.initState();
    type = context.read<CategoryBloc>().state.selectedType;
    context.read<CategoryBloc>().add(LoadCategoryByTypeEvent(type ?? AppType.expense));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Color(0xFFF5F5F5),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppCircleButton(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.close, size: 30),
            ),
            Text(
              'Danh mục',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            AppCircleButton(
              onTap: () async {
                final bloc = context.read<CategoryBloc>();

                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),

                      title: const Text(
                        'Xác nhận',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Bạn có chắc chắn muốn trở về mặc định?',
                            style: TextStyle(fontSize: 16),
                          ),

                          SizedBox(height: 10),

                          Text(
                            '⚠️ Tất cả giao dịch thuộc danh mục khác sẽ bị xoá.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      actionsPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),

                      actions: [
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(context, false),

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),

                                child: const Text(
                                  'Huỷ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),

                                child: const Text(
                                  'Xác nhận',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );

                if (confirm == true) {
                  bloc.add(ResetCategoryEvent());
                }
              },
              child: Icon(Icons.refresh),
            ),
          ],
        ),
      ),
      body: BlocListener<CategoryBloc, CategoryState>(
        listenWhen: (pre, cur) => cur.status == AppStatus.deleted,
        listener: (context, state) {
          context.read<TransactionBloc>().add(LoadTransactions());
        },
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          type = AppType.expense;
                        });

                        context.read<CategoryBloc>().add(
                          LoadCategoryByTypeEvent(AppType.expense),
                        );
                      },
                      child: Container(
                        width: 80,
                        height: 30,
                        decoration: BoxDecoration(
                          color: type == AppType.expense
                              ? Colors.red
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Tiền chi',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: () {
                        setState(() {
                          type = AppType.income;
                        });
                        context.read<CategoryBloc>().add(
                          LoadCategoryByTypeEvent(AppType.income),
                        );
                      },
                      child: Container(
                        width: 80,
                        height: 30,
                        decoration: BoxDecoration(
                          color: type == AppType.income
                              ? Colors.green
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Tiền thu',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: BlocBuilder<CategoryBloc, CategoryState>(
                        buildWhen: (pre, cur) => pre.categories.length != cur.categories.length,
                        builder: (context, state) {
                          if (state.status == AppStatus.loading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final categories = state.categories;
                          if (categories.isEmpty) {
                            return SizedBox();
                          }
                          return ListView.separated(
                            itemBuilder: (context, index) {
                              final item = categories[index];
                              return Row(
                                children: [
                                  Image.asset(
                                    'assets/icons/${item.type.name}/${item.icon}',
                                    width: 40,
                                    height: 40,
                                  ),

                                  const SizedBox(width: 10),

                                  Expanded(
                                    child: Text(
                                      item.name,
                                      style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  Row(
                                    children: [
                                      InkWell(
                                        borderRadius: BorderRadius.circular(12),
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (_) => BlocProvider.value(
                                              value: context
                                                  .read<CategoryBloc>(),
                                              child: FractionallySizedBox(
                                                heightFactor: 0.93,
                                                child: UpdateCategory(
                                                  currentCategory: item,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.edit_rounded,
                                            color: Colors.blue,
                                            size: 22,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 8),

                                      InkWell(
                                        borderRadius: BorderRadius.circular(12),
                                        onTap: () async {
                                          final bloc = context
                                              .read<CategoryBloc>();

                                          final confirm = await showDialog<bool>(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),

                                                title: const Text(
                                                  'Xác nhận',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),

                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: const [
                                                    Text(
                                                      'Bạn có chắc chắn muốn xoá danh mục này?',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),

                                                    SizedBox(height: 10),

                                                    Text(
                                                      '⚠️ Tất cả giao dịch thuộc danh mục này sẽ bị xoá.',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                actionsPadding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 10,
                                                    ),

                                                actions: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                context,
                                                                false,
                                                              ),

                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                Colors.green,
                                                            foregroundColor:
                                                                Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    10,
                                                                  ),
                                                            ),
                                                          ),

                                                          child: const Text(
                                                            'Huỷ',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ),
                                                      ),

                                                      const SizedBox(width: 10),

                                                      Expanded(
                                                        child: ElevatedButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                context,
                                                                true,
                                                              ),

                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                Colors.red,
                                                            foregroundColor:
                                                                Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    10,
                                                                  ),
                                                            ),
                                                          ),

                                                          child: const Text(
                                                            'Xoá',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                          if (confirm == true) {
                                            bloc.add(
                                              DeleteCategoryEvent(item.id!),
                                            );
                                          }
                                        },

                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.red.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),

                                          child: const Icon(
                                            Icons.delete_rounded,
                                            color: Colors.red,
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 15,
                                child: Divider(height: 2),
                              );
                            },
                            itemCount: categories.length,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 1,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => BlocProvider.value(
                          value: context.read<CategoryBloc>(),
                          child: FractionallySizedBox(
                            heightFactor: 0.93,
                            child: AddCategory(type: type!),
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Thêm',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
