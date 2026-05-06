class ElectricityDraft {
  const ElectricityDraft({
    required this.type,
    required this.meterNumber,
    required this.amount,
  });

  final String type;
  final String meterNumber;
  final String amount;

  factory ElectricityDraft.empty() {
    return const ElectricityDraft(
      type: 'Electricity Bill',
      meterNumber: '081275432155',
      amount: 'Rp 100.000',
    );
  }
}
