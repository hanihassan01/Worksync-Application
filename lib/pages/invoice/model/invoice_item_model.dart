class InvoiceLineItem {
  final String id;
  String description;
  int quantity;
  double unitPrice;
  String hsn;
  double taxRate;
  String notes;

  InvoiceLineItem({
    required this.id,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.hsn,
    required this.taxRate,
    required this.notes,
  });

  double get lineTotal => quantity * unitPrice;
  double get taxAmount => lineTotal * (taxRate / 100);
  double get totalWithTax => lineTotal + taxAmount;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'quantity': quantity,
      'unit_price': unitPrice,
      'hsn': hsn,
      'tax_rate': taxRate,
      'notes': notes,
      'line_total': lineTotal,
      'tax_amount': taxAmount,
      'total_with_tax': totalWithTax,
    };
  }

  factory InvoiceLineItem.fromJson(Map<String, dynamic> json) {
    return InvoiceLineItem(
      id: json['id'],
      description: json['description'],
      quantity: json['quantity'],
      unitPrice: json['unit_price'],
      hsn: json['hsn'],
      taxRate: json['tax_rate'],
      notes: json['notes'],
    );
  }
}
