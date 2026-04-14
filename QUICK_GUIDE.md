# 🎯 Quick Guide - Dùng Project Này Như Thế Nào

## 📦 Import Constants

```dart
// ✅ Cách đúng
import 'package:expense_tracker_app/core/constants/constants.dart';

// Sử dụng
Text('Trang chủ', style: TextStyle(color: AppColors.primary));
SizedBox(height: AppDimensions.paddingMd);
```

## 🔄 Sử Dụng FilterBloc

```dart
// ✅ Cách đúng (vị trí mới)
import 'package:expense_tracker_app/features/transactions/presentation/blocs/filter/filter_bloc.dart';
import 'package:expense_tracker_app/features/transactions/presentation/blocs/filter/filter_event.dart';
import 'package:expense_tracker_app/features/transactions/presentation/blocs/filter/filter_state.dart';

// Sử dụng
BlocBuilder<FilterBloc, FilterState>(
  builder: (context, state) {
    return ListView.builder(
      itemCount: state.filteredTransactions.length,
      itemBuilder: (context, index) => Text(state.filteredTransactions[index].name),
    );
  },
);
```

## 📂 Thêm Feature Mới

```bash
# Tạo cấu trúc
lib/features/your_feature/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── blocs/
    ├── pages/
    └── widgets/
```

## 🎨 Shared Widgets - QUAN TRỌNG

**Quy tắc**: Shared widgets chỉ chứa **UI**, không chứa **business logic**

```dart
// ❌ SAI
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<FilterBloc>();  // ❌ Business logic
    return Container();
  }
}

// ✅ ĐÚNG
class MyWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  
  const MyWidget({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(title),
    );
  }
}
```

## 📝 App Config (Main.dart)

```dart
import 'package:expense_tracker_app/app/app.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}
```

**App đã config:**
- ✅ MaterialApp
- ✅ Locale (Tiếng Việt)
- ✅ BLoC providers (NavigationBloc, FilterBloc)
- ✅ Localizations

---

**Tài Liệu Chi Tiết**: Xem `ARCHITECTURE.md`

