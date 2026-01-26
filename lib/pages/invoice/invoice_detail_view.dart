import 'package:flutter/material.dart';
import 'package:worksync/pages/invoice/model/invoice_item_model.dart';
import 'package:worksync/pages/invoice/invoice_widgets/add_line_item.dart';
import 'package:worksync/pages/invoice/invoice_widgets/edit_line_item.dart';
import 'package:worksync/pages/invoice/invoice_widgets/invoice_table.dart';
import 'package:worksync/pages/invoice/invoice_widgets/add_line_item_button.dart';

class InvoiceDetailView extends StatefulWidget {
  final Map<String, dynamic>? invoiceData;

  const InvoiceDetailView({super.key, this.invoiceData});

  @override
  State<InvoiceDetailView> createState() => _InvoiceDetailViewState();
}

class _InvoiceDetailViewState extends State<InvoiceDetailView> {
  late List<InvoiceLineItem> items;
  late String invoiceId;
  late String customerName;
  late String invoiceDate;
  late String dueDate;
  late double invoiceAmount;
  late String status = 'Submitted';

  final double rowHeight = 50.0;
  final int maxVisibleRows = 7;

  double _discount = 0.0;
  double _shippingCharges = 0.0;
  double _advancePayment = 0.0;
  double _sgstRate = 9.0;
  double _cgstRate = 9.0;

  late TextEditingController _discountController;
  late TextEditingController _shippingController;
  late TextEditingController _advanceController;

  double get subtotal {
    return items.fold(0.0, (sum, item) => sum + item.lineTotal);
  }

  double get totalTax {
    return items.fold(0.0, (sum, item) => sum + item.taxAmount);
  }

  @override
  void initState() {
    super.initState();

    // Initialize from passed data or use defaults
    if (widget.invoiceData != null) {
      invoiceId = widget.invoiceData!['id'] ?? 'INV-001';
      customerName = widget.invoiceData!['customer'] ?? 'ABC Company Ltd.';
      invoiceDate = widget.invoiceData!['invoiceDate'] ?? 'Jan 26, 2026';
      dueDate = widget.invoiceData!['dueDate'] ?? 'Feb 25, 2026';
      invoiceAmount = (widget.invoiceData!['amount'] ?? 0).toDouble();
    } else {
      invoiceId = 'INV-001';
      customerName = 'ABC Company Ltd.';
      invoiceDate = 'Jan 26, 2026';
      dueDate = 'Feb 25, 2026';
      invoiceAmount = 5000.0;
    }

    // Initialize items with sample data
    items = [
      InvoiceLineItem(
        id: '1',
        description: 'Consulting Services',
        quantity: 10,
        unitPrice: 1000.0,
        hsn: '998314',
        taxRate: 18,
        notes: 'Professional consultation',
      ),
    ];

    _discountController = TextEditingController(
      text: _discount.toStringAsFixed(2),
    );
    _shippingController = TextEditingController(
      text: _shippingCharges.toStringAsFixed(2),
    );
    _advanceController = TextEditingController(
      text: _advancePayment.toStringAsFixed(2),
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
      builder: (context) => AddInvoiceLineItemSheet(
        onSave: (newItem) {
          setState(() {
            items.add(newItem);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✓ Line item added!'),
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
      builder: (context) => EditInvoiceLineItemSheet(
        item: items[index],
        onSave: (updatedItem) {
          setState(() {
            items[index] = updatedItem;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✓ Line item updated!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        },
        onDelete: () {
          final description = items[index].description;
          setState(() {
            items.removeAt(index);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$description deleted'),
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
        title: Row(
          children: [
            Text(
              'Sales Invoice #$invoiceId',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
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
            // Invoice Info
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Source info with Next Steps button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Source: Sales Order #SO-001',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _showCreateModal,
                        icon: Icon(Icons.add, color: Colors.white, size: 20),
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
                  SizedBox(height: 16),
                  // Customer name
                  Text(
                    'CUSTOMER NAME',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    customerName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Posting and Due date
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'POSTING DATE',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              invoiceDate,
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
                              'DUE DATE',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              dueDate,
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
            // Line Items Table
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
                  AddLineItemButton(onPressed: _showAddSheet, isPhone: false),
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
                      Icon(
                        Icons.more_vert,
                        color: Colors.grey.shade400,
                        size: 20,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildEditableRow('Discount', _discountController, (v) {
                    setState(() {
                      _discount = double.tryParse(v) ?? 0.0;
                    });
                  }),
                  SizedBox(height: 12),
                  _buildRowLabelValue(
                    'Subtotal Amount',
                    '₹${subtotal.toStringAsFixed(2)}',
                  ),
                  SizedBox(height: 12),
                  _buildRowLabelValue(
                    'Total Quantity',
                    items
                        .fold<int>(0, (sum, item) => sum + item.quantity)
                        .toString(),
                  ),
                  SizedBox(height: 12),
                  _buildRowLabelValue(
                    'SGST (${_sgstRate.toStringAsFixed(0)}%)',
                    '₹${(subtotal * (_sgstRate / 100)).toStringAsFixed(2)}',
                  ),
                  SizedBox(height: 12),
                  _buildRowLabelValue(
                    'CGST (${_cgstRate.toStringAsFixed(0)}%)',
                    '₹${(subtotal * (_cgstRate / 100)).toStringAsFixed(2)}',
                  ),
                  SizedBox(height: 12),
                  _buildEditableRow('Shipping Fee', _shippingController, (v) {
                    setState(() {
                      _shippingCharges = double.tryParse(v) ?? 0.0;
                    });
                  }),
                  SizedBox(height: 12),
                  _buildEditableRow('Advance Paid', _advanceController, (v) {
                    setState(() {
                      _advancePayment = double.tryParse(v) ?? 0.0;
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
                        '₹${(subtotal + (subtotal * (_sgstRate / 100)) + (subtotal * (_cgstRate / 100)) + _shippingCharges - _discount - _advancePayment).toStringAsFixed(2)}',
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
                      onPressed: () => Navigator.pop(context),
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
                        'Submit',
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

  Widget _buildRowLabelValue(String label, String value) {
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
