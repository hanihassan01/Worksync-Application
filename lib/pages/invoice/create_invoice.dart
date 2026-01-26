import 'package:flutter/material.dart';
import 'package:worksync/pages/invoice/model/invoice_item_model.dart';
import 'package:worksync/pages/invoice/invoice_widgets/add_line_item.dart';
import 'package:worksync/pages/invoice/invoice_widgets/edit_line_item.dart';
import 'package:worksync/pages/invoice/invoice_widgets/invoice_table.dart';
import 'package:worksync/pages/invoice/invoice_widgets/add_line_item_button.dart';

class CreateInvoiceScreen extends StatefulWidget {
  const CreateInvoiceScreen({super.key});

  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  List<InvoiceLineItem> items = [];

  final double rowHeight = 50.0;
  final int maxVisibleRows = 7;

  // Invoice payment state
  double _discount = 0.0;
  double _shippingCharges = 0.0;
  double _advancePayment = 0.0;

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
    final screenWidth = MediaQuery.of(context).size.width;
    bool isPhone = screenWidth < 600;
    bool isDesktop = screenWidth >= 1200;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Invoice'),
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
        Expanded(flex: 3, child: _buildSummaryPanel(isPhone)),
      ],
    );
  }

  Widget _buildMobileLayout(bool isPhone) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildTableSection(isPhone),
          const SizedBox(height: 20),
          _buildSummaryPanel(isPhone),
        ],
      ),
    );
  }

  Widget _buildTableSection(bool isPhone) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Invoice Line Items',
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
        AddLineItemButton(onPressed: _showAddSheet, isPhone: isPhone),
      ],
    );
  }

  Widget _buildSummaryPanel(bool isPhone) {
    double balanceDue =
        subtotal + totalTax + _shippingCharges - _discount - _advancePayment;

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
          Text(
            'Invoice Summary',
            style: TextStyle(
              fontSize: isPhone ? 14 : 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          _buildRowLabelValue(
            'Subtotal',
            '₹${subtotal.toStringAsFixed(2)}',
            isPhone,
          ),
          const SizedBox(height: 8),
          _buildRowLabelValue(
            'Total Tax',
            '₹${totalTax.toStringAsFixed(2)}',
            isPhone,
          ),
          const SizedBox(height: 8),
          _buildEditableRow('Discount', _discountController, (v) {
            setState(() {
              _discount = double.tryParse(v) ?? 0.0;
            });
          }, isPhone),
          const SizedBox(height: 8),
          _buildEditableRow('Shipping Charges', _shippingController, (v) {
            setState(() {
              _shippingCharges = double.tryParse(v) ?? 0.0;
            });
          }, isPhone),
          const SizedBox(height: 8),
          _buildEditableRow('Advance Payment', _advanceController, (v) {
            setState(() {
              _advancePayment = double.tryParse(v) ?? 0.0;
            });
          }, isPhone),
          const SizedBox(height: 12),
          Divider(color: Colors.grey.shade300, thickness: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Balance Due',
                style: TextStyle(
                  fontSize: isPhone ? 14 : 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '₹${balanceDue.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: isPhone ? 16 : 18,
                  fontWeight: FontWeight.bold,
                  color: balanceDue > 0 ? Colors.orange : Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
                    'Save Invoice',
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

  Widget _buildEditableRow(
    String label,
    TextEditingController controller,
    Function(String) onChanged,
    bool isPhone,
  ) {
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
        SizedBox(
          width: isPhone ? 100 : 120,
          child: TextField(
            controller: controller,
            textAlign: TextAlign.right,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
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
}
