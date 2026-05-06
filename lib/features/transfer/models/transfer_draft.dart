class TransferDraft {
  const TransferDraft({
    required this.destinationBank,
    required this.accountNumber,
    required this.amount,
    required this.message,
    this.transferMethod = 'BI-Fast',
    this.notes = 'From David',
  });

  final String destinationBank;
  final String accountNumber;
  final String amount;
  final String message;
  final String transferMethod;
  final String notes;

  factory TransferDraft.empty() {
    return const TransferDraft(
      destinationBank: 'CIMB NIAGA',
      accountNumber: '0123456789',
      amount: 'IDR 20.000',
      message: 'From yanto',
    );
  }

  TransferDraft copyWith({
    String? destinationBank,
    String? accountNumber,
    String? amount,
    String? message,
    String? transferMethod,
    String? notes,
  }) {
    return TransferDraft(
      destinationBank: destinationBank ?? this.destinationBank,
      accountNumber: accountNumber ?? this.accountNumber,
      amount: amount ?? this.amount,
      message: message ?? this.message,
      transferMethod: transferMethod ?? this.transferMethod,
      notes: notes ?? this.notes,
    );
  }
}
