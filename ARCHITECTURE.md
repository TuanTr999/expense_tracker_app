# Project Structure - Clean Architecture + BLoC Pattern

Cấu trúc project sau đây tuân theo **Clean Architecture** kết hợp với **BLoC Pattern** để đảm bảo tính dễ bảo trì, mở rộng và kiểm tra.

## 📂 Cấu Trúc Thư Mục

```
lib/
├── main.dart                          # Entry point
│
├── app/                               # App-level (global)
│   ├── app.dart                       # MaterialApp, theme, providers
│   └── routes/                        # Định nghĩa routes (nếu dùng)
│
├── core/                              # Dùng chung toàn app (KHÔNG phụ thuộc feature)
│   ├── constants/
│   │   ├── app_colors.dart            # Màu sắc
│   │   ├── app_strings.dart           # Chuỗi văn bản
│   │   ├── app_dimens.dart            # Kích thước (padding, margin, font)
│   │   └── constants.dart             # Export tất cả
│   │
│   ├── theme/                         # app_theme.dart
│   │   └── app_theme.dart             # Theme, TextTheme
│   │
│   ├── utils/                         # Utility functions
│   │   ├── format_date.dart           # Hàm format ngày
│   │   ├── format.dart                # Hàm format tổng quát
│   │   ├── extensions.dart            # Extension methods
│   │   └── transaction_util.dart
│   │
│   └── errors/                        # Exception handling
│       └── exceptions.dart
│
├── features/                          # Mỗi feature = 1 module độc lập
│   │
│   ├── transactions/                  # Feature: Quản lý giao dịch
│   │   ├── data/
│   │   │   ├── models/                # TransactionModel (JSON/SQLite)
│   │   │   ├── datasources/           # local_db.dart, remote_datasource.dart
│   │   │   └── repositories/          # transaction_repo_impl.dart
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/              # Transaction (pure)
│   │   │   ├── repositories/          # abstract repo
│   │   │   └── usecases/              # Get transactions, Add, Delete...
│   │   │
│   │   └── presentation/
│   │       ├── blocs/
│   │       │   ├── transaction/       # BLoC chính
│   │       │   │   ├── transaction_bloc.dart
│   │       │   │   ├── transaction_event.dart
│   │       │   │   └── transaction_state.dart
│   │       │   │
│   │       │   └── filter/            # Filter BLoC (đặt ở feature, không shared)
│   │       │       ├── filter_bloc.dart
│   │       │       ├── filter_event.dart
│   │       │       └── filter_state.dart
│   │       │
│   │       ├── pages/
│   │       │   ├── transactions_page.dart
│   │       │   └── all_transactions_screen.dart
│   │       │
│   │       └── widgets/
│   │           ├── transaction_item.dart
│   │           └── (các widget nhỏ khác)
│   │
│   ├── home/                          # Feature: Trang chủ
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── blocs/
│   │       ├── pages/
│   │       │   └── home_tab.dart
│   │       └── widgets/
│   │
│   ├── budget/                        # Feature: Ngân sách
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── blocs/
│   │       ├── pages/
│   │       └── widgets/
│   │
│   ├── wallet/                        # Feature: Ví tiền
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── settings/                      # Feature: Cài đặt
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── navigation/                    # Feature: Navigation
│       ├── data/
│       ├── domain/
│       └── presentation/
│           ├── blocs/
│           │   └── navigation/
│           ├── pages/
│           │   └── main_screen.dart
│           └── widgets/
│
└── shared/                            # CHỈ chứa UI dùng chung (KHÔNG logic business)
    └── widgets/
        ├── app_bar/
        │   ├── custom_app_bar.dart
        │   └── custom_app_bar1.dart
        ├── transaction_item.dart      # Widget dùng chung nhưng không thay logic
        ├── budget_card.dart
        ├── summary_card.dart
        ├── app_layout.dart
        └── (các widget khác)
```

## 🎯 Nguyên Tắc Thiết Kế

### 1. **Core Layer**
- **Mục đích**: Chứa mã không phụ thuộc vào bất kỳ feature nào
- **Nội dung**:
  - Constants (màu, chuỗi, kích thước)
  - Theme và Styling
  - Utilities (format, extensions)
  - Error handling

### 2. **Features Layer**
- **Mục đích**: Mỗi feature là một module độc lập
- **Cấu trúc**:
  - **Data**: Xử lý dữ liệu (models, datasources, repositories)
  - **Domain**: Logic business (entities, repositories, usecases)
  - **Presentation**: UI + BLoCs

### 3. **Shared Layer**
- **Mục đích**: Chứa widgets được tái sử dụng (UI ONLY)
- **Quy tắc**:
  - ✅ Custom widgets (AppBar, Cards, etc.)
  - ❌ Business logic
  - ❌ BLoC chung (trừ những trường hợp đặc biệt)

### 4. **App Layer**
- **Mục đích**: Cấu hình ứng dụng toàn cục
- **Nội dung**:
  - MaterialApp
  - Theme
  - Routes
  - BLoC providers (global)

## 📋 Important Notes

### ⚠️ FilterBloc
- **Đặt tại**: `features/transactions/presentation/blocs/filter/`
- **Lý do**: FilterBloc là một tính năng của transactions, không phải global shared logic

### 🎨 Constants
- Sử dụng file `core/constants/constants.dart` để export tất cả
- Import: `import 'package:expense_tracker_app/core/constants/constants.dart';`

### 📦 Shared Widgets
- Chỉ chứa **UI components**, không chứa logic
- Nếu widget cần logic → tạo trong feature của nó

### 🔄 Imports
```dart
// ✅ Đúng
import 'package:expense_tracker_app/core/constants/constants.dart';
import 'package:expense_tracker_app/features/transactions/presentation/blocs/filter/filter_bloc.dart';

// ❌ Sai
import '../../../../../core/constants/app_colors.dart';  // Relative imports
```

## 🚀 Cách Thêm Feature Mới

1. Tạo folder: `features/feature_name/`
2. Tạo 3 layers: `data/`, `domain/`, `presentation/`
3. Trong presentation: `blocs/`, `pages/`, `widgets/`
4. Implement theo Clean Architecture

---

**Lợi ích của cấu trúc này:**
- ✅ Dễ mở rộng
- ✅ Dễ bảo trì
- ✅ Dễ test
- ✅ Tách biệt concern
- ✅ Tái sử dụng code

