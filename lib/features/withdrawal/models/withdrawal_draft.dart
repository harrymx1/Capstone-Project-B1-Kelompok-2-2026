class WithdrawalDraft {
  const WithdrawalDraft({required this.location, required this.amount});

  final String location;
  final String amount;

  factory WithdrawalDraft.empty() {
    return const WithdrawalDraft(
      location: 'CIMB NIAGA ATM',
      amount: 'Rp 150.000',
    );
  }

  WithdrawalDraft copyWith({String? location, String? amount}) {
    return WithdrawalDraft(
      location: location ?? this.location,
      amount: amount ?? this.amount,
    );
  }
}
