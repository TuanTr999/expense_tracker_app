import 'package:expense_tracker_app/core/constants/app_icon.dart';
import 'package:expense_tracker_app/core/enums/app_type.dart';
import 'package:expense_tracker_app/features/categories/presentation/blocs/category/category_state.dart';
import 'package:expense_tracker_app/features/categories/presentation/pages/add_category.dart';
import 'package:expense_tracker_app/features/categories/presentation/pages/update_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    type = AppType.expense;
    context.read<CategoryBloc>().add(LoadCategoryByTypeEvent(AppType.expense));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F5F5),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppCircleButton(
              onTap: () {
                Navigator.pop(context);
              },
              padding: EdgeInsets.only(left: 8),
              child: Icon(Icons.arrow_back_ios),
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
              onTap: () {
                // context.read<CategoryBloc>().add(Reset)
              },
              child: Icon(Icons.refresh),
            ),
          ],
        ),
      ),
      body: Stack(
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
                      builder: (context, state) {
                        if (state.isLoading) {
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
                                SizedBox(width: 10),
                                Text(
                                  item.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (_) => BlocProvider.value(
                                        value: context.read<CategoryBloc>(),
                                        child: FractionallySizedBox(
                                          heightFactor: 0.93,
                                          child: UpdateCategory(
                                            currentCategory: item,
                                          ),
                                        )

                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                ),
                                Material(
                                  color: Colors.white,
                                  child: InkWell(
                                    onTap: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            title: Text(
                                              'Xác nhận',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            content: Text(
                                              'Bạn có chắc chắn muốn xoá danh mục này không?',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            actionsPadding:
                                                EdgeInsets.symmetric(
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
                                                      child: Text(
                                                        'Huỷ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
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
                                                      child: Text(
                                                        'Xoá',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                        context.read<CategoryBloc>().add(
                                          DeleteCategoryEvent(item.id!),
                                        );
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                  ),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
