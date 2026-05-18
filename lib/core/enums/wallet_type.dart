enum WalletType {
  cash,
  bank,
  ewallet,
}

extension WalletTypeName on WalletType {
  String get title {
    switch (this) {
      case WalletType.cash:
        return 'Tiền mặt';
      case WalletType.bank:
        return 'Thẻ ngân hàng';
      case WalletType.ewallet:
        return 'Ví điện tử';
    }
  }
}

WalletType walletTypeFromString(String value) {
  return WalletType.values.firstWhere(
        (e) => e.name == value,
    orElse: () => WalletType.cash,
  );
}