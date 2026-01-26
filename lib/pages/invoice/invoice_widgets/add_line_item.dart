import 'package:flutter/material.dart';
import 'package:worksync/pages/invoice/model/invoice_item_model.dart';

class AddInvoiceLineItemSheet extends StatefulWidget {
  final Function(InvoiceLineItem) onSave;

  const AddInvoiceLineItemSheet({super.key, required this.onSave});

  @override
  State<AddInvoiceLineItemSheet> createState() =>
      _AddInvoiceLineItemSheetState();
}

class _AddInvoiceLineItemSheetState extends State<AddInvoiceLineItemSheet> {
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController(text: '1');
  final unitPriceController = TextEditingController(text: '0.00');
  final hsnController = TextEditingController();
  final taxRateController = TextEditingController(text: '18');
  final notesController = TextEditingController();

  @override
  void dispose() {
    descriptionController.dispose();
    quantityController.dispose();
    unitPriceController.dispose();
    hsnController.dispose();
    taxRateController.dispose();
    notesController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Please enter item description'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final newItem = InvoiceLineItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      description: descriptionController.text.trim(),
      quantity: int.tryParse(quantityController.text) ?? 1,
      unitPrice: double.tryParse(unitPriceController.text) ?? 0.0,
      hsn: hsnController.text.trim(),
      taxRate: double.tryParse(taxRateController.text) ?? 18,
      notes: notesController.text.trim(),
    );

    widget.onSave(newItem);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.add_circle, color: Colors.blue, size: 28),
                const SizedBox(width: 8),
                const Text(
                  'Add New Line Item',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Description',
              controller: descriptionController,
              icon: Icons.description,
              hint: 'e.g., Consulting Services',
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'Quantity',
                    controller: quantityController,
                    icon: Icons.numbers,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTextField(
                    label: 'HSN Code',
                    controller: hsnController,
                    icon: Icons.code,
                  ),
                ),
              ],
            ),
            _buildTextField(
              label: 'Unit Price (₹)',
              controller: unitPriceController,
              icon: Icons.currency_rupee,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            _buildTextField(
              label: 'Tax Rate (%)',
              controller: taxRateController,
              icon: Icons.percent,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            _buildTextField(
              label: 'Notes (Optional)',
              controller: notesController,
              icon: Icons.note,
              hint: 'Any additional notes',
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _handleSave,
                  icon: const Icon(Icons.save),
                  label: const Text('Add Item', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? hint,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, size: 20),
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
