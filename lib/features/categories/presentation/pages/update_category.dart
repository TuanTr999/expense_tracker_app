import 'package:expense_tracker_app/core/constants/app_icon.dart';
import 'package:expense_tracker_app/core/constants/app_icon_list.dart';
import 'package:expense_tracker_app/core/enums/app_type.dart';
import 'package:expense_tracker_app/features/categories/data/models/category_model.dart';
import 'package:expense_tracker_app/features/categories/presentation/blocs/category/category_bloc.dart';
import 'package:expense_tracker_app/features/categories/presentation/blocs/category/category_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateCategory extends StatefulWidget {
  const UpdateCategory({super.key, required this.currentCategory});

  final CategoryModel currentCategory;

  @override
  State<UpdateCategory> createState() => _UpdateCategoryState();
}

class _UpdateCategoryState extends State<UpdateCategory> {
  int selectedIndex = -1;
  late String selectedIcon;
  late List<String> icons;
  late AppType type;
  late TextEditingController nameCategoryController;
  String? errorText;

  @override
  void initState() {
    super.initState();

    type = widget.currentCategory.type;
    selectedIcon = widget.currentCategory.icon;

    icons = type == AppType.income
        ? AppIconList.incomeIcon
        : AppIconList.expenseIcon;

    selectedIndex = icons.indexOf(selectedIcon);

    nameCategoryController = TextEditingController(
      text: widget.currentCategory.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppCircleButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    size: 50,
                    child: Icon(Icons.close, size: 35),
                  ),
                  Text(
                    'Danh mục',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 50, height: 50),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => FractionallySizedBox(
                        heightFactor: 0.9,
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(30),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppCircleButton(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(Icons.close, size: 35),
                                  ),
                                  const Text(
                                    'Chọn biểu tượng',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 50),
                                ],
                              ),
                              SizedBox(height: 20),

                              Expanded(
                                child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                      ),
                                  itemCount: icons.length,
                                  itemBuilder: (context, index) {
                                    final isSelected = selectedIndex == index;
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedIndex = index;
                                          selectedIcon = icons[index];
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: isSelected
                                              ? Border.all(
                                                  color: Colors.blue,
                                                  width: 3,
                                                )
                                              : null,
                                        ),
                                        child: Center(
                                          child: Image.asset(
                                            'assets/icons/${type.name}/${icons[index]}',
                                            width: 30,
                                            height: 30,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/icons/${type.name}/$selectedIcon',
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Tên danh mục',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    SizedBox(width: 15),
                    Expanded(
                      child: TextField(
                        controller: nameCategoryController,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.start,
                        onChanged: (value) {
                          if (errorText != null) {
                            setState(() {
                              errorText = null;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Nhập tên danh mục',
                          border: InputBorder.none,
                          isCollapsed: true,
                          errorText: errorText,
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {

                  if (nameCategoryController.text.isEmpty) {
                    setState(() {
                      errorText = 'Vui lòng nhập tên danh mục';
                    });
                    return;
                  }

                  final category = CategoryModel(
                    id: widget.currentCategory.id,
                    name: nameCategoryController.text,
                    icon: selectedIcon,
                    type: type,
                  );

                  context.read<CategoryBloc>().add(
                    UpdateCategoryEvent(category),
                  );

                  Navigator.pop(context);
                },
                child: Text(
                  'Xác nhận',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
