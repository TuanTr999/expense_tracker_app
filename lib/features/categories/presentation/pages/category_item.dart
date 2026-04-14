import 'package:expense_tracker_app/core/constants/app_icon.dart';
import 'package:expense_tracker_app/core/enums/app_type.dart';
import 'package:expense_tracker_app/features/categories/data/models/category_model.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({super.key, this.currentCategory, this.categoryType});

  final CategoryModel? currentCategory;
  final AppType? categoryType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: currentCategory?.id == null
                    ? Image.asset(
                        'assets/icons/ui/other.png',
                        width: 40,
                        height: 40,
                      )
                    : Image.asset(
                        'assets/icons/${currentCategory?.type.name}/${currentCategory?.icon}',
                        width: 40,
                        height: 40,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
