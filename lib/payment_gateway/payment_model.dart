enum PaymentMethod { card, netbanking, upi, wallet }

class Payment {
  String id;
  double amount;
  PaymentMethod paymentMethod;
  String description;
  DateTime createdOn;

  Payment({
    required this.id,
    required this.amount,
    required this.paymentMethod,
    required this.description,
    required this.createdOn,
  });

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'],
      amount: map['amount'] / 100,
      paymentMethod: _parseMethod(map['method']),
      description: map['description'],
      createdOn: DateTime.fromMillisecondsSinceEpoch(map['created_at'] * 1000),
    );
  }

  static _parseMethod(String method) {
    switch (method) {
      case 'card':
        return PaymentMethod.card;
      case 'netbanking':
        return PaymentMethod.netbanking;
      case 'upi':
        return PaymentMethod.upi;
      case 'wallet':
        return PaymentMethod.wallet;
    }
  }

  String get humanReadablePaymentMethod {
    switch (paymentMethod) {
      case PaymentMethod.card:
        return 'Card ending XXXX';
      case PaymentMethod.netbanking:
        return 'Netbanking';
      case PaymentMethod.upi:
        return 'UPI';
      case PaymentMethod.wallet:
        return 'Wallet';
    }
  }
}
