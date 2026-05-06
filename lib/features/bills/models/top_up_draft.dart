class TopUpDraft {
  const TopUpDraft({
    required this.walletName,
    required this.destinationNumber,
    required this.amount,
  });

  final String walletName;
  final String destinationNumber;
  final String amount;

  factory TopUpDraft.empty() {
    return const TopUpDraft(
      walletName: 'GoPay',
      destinationNumber: '081275432155',
      amount: 'IDR 20.000',
    );
  }
}
