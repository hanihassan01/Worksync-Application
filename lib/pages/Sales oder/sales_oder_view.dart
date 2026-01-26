import 'package:flutter/material.dart';
import 'package:worksync/pages/Sales%20oder/model/sales_table_model_class.dart';
import 'package:worksync/pages/Sales%20oder/salaes_widgets/add_items.dart';
import 'package:worksync/pages/Sales%20oder/salaes_widgets/edit_item_tabil.dart';
import 'package:worksync/pages/Sales%20oder/salaes_widgets/tabil.dart';
import 'package:worksync/pages/Sales%20oder/salaes_widgets/tabil_vew.dart';

class SalesOderVew extends StatefulWidget {
  const SalesOderVew({super.key});

  @override
  State<SalesOderVew> createState() => _SalesOderVewState();
}

class _SalesOderVewState extends State<SalesOderVew> {
  List<InvoiceItem> items = [
    InvoiceItem(
      id: '1',
      itemName: 'Premium Cotton T-Shirt',
      quantity: 200,
      rate: 500.0,
      uom: 'Pcs',
      remarks: '',
    ),
  ];

  final double rowHeight = 50.0;
  final int maxVisibleRows = 7;

  // Payment / summary state
  double _discount = 0.0;
  double _shippingFee = 5.0;
  double _advancePaid = 0.0;

  late TextEditingController _discountController;
  late TextEditingController _shippingController;
  late TextEditingController _advanceController;

  double get subtotal {
    return items.fold(0.0, (sum, item) => sum + item.amount);
  }

  @override
  void initState() {
    super.initState();
    _discountController = TextEditingController(
      text: _discount.toStringAsFixed(2),
    );
    _shippingController = TextEditingController(
      text: _shippingFee.toStringAsFixed(2),
    );
    _advanceController = TextEditingController(
      text: _advancePaid.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _discountController.dispose();
    _shippingController.dispose();
    _advanceController.dispose();
    super.dispose();
  }

  void _showAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddInvoiceItemSheet(
        onSave: (newItem) {
          setState(() {
            items.add(newItem);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✓ ${newItem.itemName} added successfully!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  void _showEditSheet(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => EditInvoiceItemSheet(
        item: items[index],
        onSave: (updatedItem) {
          setState(() {
            items[index] = updatedItem;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✓ ${updatedItem.itemName} updated!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        },
        onDelete: () {
          final deletedName = items[index].itemName;
          setState(() {
            items.removeAt(index);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$deletedName deleted'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F9FA),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Sales Order #SO-001',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Status and Next Steps
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'SUBMITTED',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _showCreateModal,
                    icon: Icon(Icons.add, color: Colors.white, size: 18),
                    label: Text(
                      'Create',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),

            // Customer and Dates Card
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Customer Name',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Rajesh Kumar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Posting Date',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Oct 26, 2023',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Delivery Date',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Oct 30, 2023',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),

            // Invoice Items
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Invoice Items',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16),
                  InvoiceTable(
                    items: items,
                    onRowTap: _showEditSheet,
                    rowHeight: rowHeight,
                    maxVisibleRows: maxVisibleRows,
                    isPhone: false,
                  ),
                  SizedBox(height: 16),
                  AddItemButton(onPressed: _showAddSheet, isPhone: false),
                ],
              ),
            ),
            SizedBox(height: 8),

            // Summary
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Summary',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Icon(Icons.more_vert, color: Colors.grey, size: 20),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildEditableRow('Discount', _discountController, (v) {
                    setState(() {
                      _discount = double.tryParse(v) ?? 0.0;
                    });
                  }),
                  SizedBox(height: 12),
                  _buildSummaryRow(
                    'Subtotal Amount',
                    '₹${subtotal.toStringAsFixed(2)}',
                  ),
                  SizedBox(height: 12),
                  _buildSummaryRow(
                    'Total Quantity',
                    '${items.fold<int>(0, (sum, item) => sum + item.quantity)}',
                  ),
                  SizedBox(height: 12),
                  _buildSummaryRow(
                    'SGST (9%)',
                    '₹${(subtotal * 0.09).toStringAsFixed(2)}',
                  ),
                  SizedBox(height: 12),
                  _buildSummaryRow(
                    'CGST (9%)',
                    '₹${(subtotal * 0.09).toStringAsFixed(2)}',
                  ),
                  SizedBox(height: 12),
                  _buildEditableRow('Shipping Fee', _shippingController, (v) {
                    setState(() {
                      _shippingFee = double.tryParse(v) ?? 0.0;
                    });
                  }),
                  SizedBox(height: 12),
                  _buildEditableRow('Advance Paid', _advanceController, (v) {
                    setState(() {
                      _advancePaid = double.tryParse(v) ?? 0.0;
                    });
                  }),
                  SizedBox(height: 16),
                  Divider(color: Colors.grey.shade300, thickness: 1),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Grand Total',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '₹${(subtotal + (subtotal * 0.09) + (subtotal * 0.09) + _shippingFee - _discount - _advancePaid).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Save Order',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildEditableRow(
    String label,
    TextEditingController controller,
    Function(String) onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
        SizedBox(
          width: 100,
          child: TextField(
            controller: controller,
            textAlign: TextAlign.right,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  void _showCreateModal() {
    final List<Map<String, dynamic>> createOptions = [
      {'label': 'Payment', 'icon': Icons.payments},
      {'label': 'Delivery', 'icon': Icons.local_shipping},
      {'label': 'Return Note', 'icon': Icons.undo},
      {'label': 'Sale Invoice', 'icon': Icons.receipt},
    ];

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                'Create',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: createOptions
                    .map(
                      (option) => InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${option['label']} selected'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade200,
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                option['icon'],
                                color: Colors.teal,
                                size: 20,
                              ),
                              SizedBox(width: 12),
                              Text(
                                option['label'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
