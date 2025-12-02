import 'package:flutter/material.dart';
import 'package:worksync/pages/Sales/model/sales_table_model_class.dart';
import 'package:worksync/pages/Sales/salaes_widgets/add_items.dart';
import 'package:worksync/pages/Sales/salaes_widgets/edit_item_tabil.dart';
import 'package:worksync/pages/Sales/salaes_widgets/tabil.dart';
import 'package:worksync/pages/Sales/salaes_widgets/tabil_vew.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  List<InvoiceItem> items = [];

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
    final screenWidth = MediaQuery.of(context).size.width;

    bool isPhone = screenWidth < 600;
    bool isTablet = screenWidth >= 600 && screenWidth < 1200;
    bool isDesktop = screenWidth >= 1200;

    String deviceType = isPhone
        ? ' Phone'
        : (isTablet ? ' Tablet' : ' Desktop');

    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Order '),
        backgroundColor: Colors.blue,
        elevation: 2,
      ),
      body: Padding(
        padding: EdgeInsets.all(isPhone ? 8.0 : 16.0),
        child: isDesktop
            ? _buildDesktopLayout(isPhone)
            : _buildMobileLayout(isPhone),
      ),
    );
  }

  Widget _buildDesktopLayout(bool isPhone) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 7, child: _buildTableSection(isPhone)),
        const SizedBox(width: 20),
        Expanded(flex: 3, child: _buildInfoPanel(isPhone)),
      ],
    );
  }

  Widget _buildMobileLayout(bool isPhone) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildTableSection(isPhone),
          const SizedBox(height: 20),
          _buildInfoPanel(isPhone),
        ],
      ),
    );
  }

  Widget _buildTableSection(bool isPhone) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Invoice Items',
          style: TextStyle(
            fontSize: isPhone ? 18 : 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),

        InvoiceTable(
          items: items,
          onRowTap: _showEditSheet,
          rowHeight: rowHeight,
          maxVisibleRows: maxVisibleRows,
          isPhone: isPhone,
        ),

        const SizedBox(height: 10),

        AddItemButton(onPressed: _showAddSheet, isPhone: isPhone),
      ],
    );
  }

  Widget _buildInfoPanel(bool isPhone) {
    // calculate values based on current state
    double sgst = subtotal * 0.09; // 9% of subtotal
    double cgst = subtotal * 0.09; // 9% of subtotal
    double grandTotal =
        subtotal + sgst + cgst + _shippingFee - _discount - _advancePaid;
    int totalItems = items.fold<int>(0, (sum, item) => sum + (item.quantity));

    return Container(
      padding: EdgeInsets.all(isPhone ? 12 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header row with three dots menu
          Row(
            children: [
              Expanded(
                child: Text(
                  'Summary',
                  style: TextStyle(
                    fontSize: isPhone ? 14 : 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert),
                onSelected: (value) async {
                  if (value == 'advance') {
                    // show dialog to input advance amount
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Advance Amount'),
                          content: TextField(
                            controller: _advanceController,
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Enter advance paid',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                final v =
                                    double.tryParse(_advanceController.text) ??
                                    0.0;
                                setState(() {
                                  _advancePaid = v;
                                });
                                Navigator.of(context).pop();
                              },
                              child: const Text('Save'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'advance',
                    child: Text('Advance Amount'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Discount input
          Text(
            'Discount',
            style: TextStyle(
              fontSize: isPhone ? 13 : 14,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _discountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: 'Enter discount',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            onChanged: (value) {
              setState(() {
                _discount = double.tryParse(value) ?? 0.0;
              });
            },
          ),
          const SizedBox(height: 14),

          // Subtotal and details
          _buildRowLabelValue(
            'Subtotal Amount',
            '₹${subtotal.toStringAsFixed(2)}',
            isPhone,
          ),
          const SizedBox(height: 8),
          _buildRowLabelValue('Total Quantity', '$totalItems', isPhone),
          const SizedBox(height: 8),
          _buildRowLabelValue(
            'SGST (9%)',
            '₹${sgst.toStringAsFixed(2)}',
            isPhone,
          ),
          const SizedBox(height: 8),
          _buildRowLabelValue(
            'CGST (9%)',
            '₹${cgst.toStringAsFixed(2)}',
            isPhone,
          ),
          const SizedBox(height: 8),

          // Shipping fee editable field
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shipping Fee',
                style: TextStyle(
                  fontSize: isPhone ? 12 : 14,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(
                width: isPhone ? 100 : 120,
                child: TextField(
                  controller: _shippingController,
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  onChanged: (v) {
                    setState(() {
                      _shippingFee = double.tryParse(v) ?? 0.0;
                    });
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(color: Colors.grey, thickness: 1),
          const SizedBox(height: 12),

          // Advance paid row (also editable)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Advance Paid',
                style: TextStyle(
                  fontSize: isPhone ? 12 : 14,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(
                width: isPhone ? 100 : 120,
                child: TextField(
                  controller: _advanceController,
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  onChanged: (v) {
                    setState(() {
                      _advancePaid = double.tryParse(v) ?? 0.0;
                    });
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Grand total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Grand Total',
                style: TextStyle(
                  fontSize: isPhone ? 14 : 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '₹${grandTotal.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: isPhone ? 16 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: Colors.grey.shade400),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: isPhone ? 12 : 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Save Order',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: isPhone ? 12 : 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRowLabelValue(String label, String value, bool isPhone) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isPhone ? 12 : 14,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isPhone ? 12 : 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
