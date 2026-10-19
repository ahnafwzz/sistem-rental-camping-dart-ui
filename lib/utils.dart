String formatRupiah(double amount) {
  final str = amount.toStringAsFixed(0);
  return str.replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+$)'),
    (m) => '${m[0]!}.',
  );
}