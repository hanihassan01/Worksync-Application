class InvoiceItem {
  final String id;
  String itemName;
  int quantity;
  double rate;
  String uom;
  String remarks;

  InvoiceItem({
    required this.id,
    required this.itemName,
    required this.quantity,
    required this.rate,
    required this.uom,
    required this.remarks,
  });

  double get amount => quantity * rate;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item_name': itemName,
      'quantity': quantity,
      'rate': rate,
      'uom': uom,
      'remarks': remarks,
      'amount': amount,
    };
  }

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      id: json['id'],
      itemName: json['item_name'],
      quantity: json['quantity'],
      rate: json['rate'],
      uom: json['uom'],
      remarks: json['remarks'],
    );
  }
}
