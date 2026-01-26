import 'package:flutter/material.dart';
import 'package:worksync/pages/invoice/model/invoice_item_model.dart';

class EditInvoiceLineItemSheet extends StatefulWidget {
  final InvoiceLineItem item;
  final Function(InvoiceLineItem) onSave;
  final VoidCallback onDelete;

  const EditInvoiceLineItemSheet({
    super.key,
    required this.item,
    required this.onSave,
    required this.onDelete,
  });

  @override
  State<EditInvoiceLineItemSheet> createState() =>
      _EditInvoiceLineItemSheetState();
}

class _EditInvoiceLineItemSheetState extends State<EditInvoiceLineItemSheet> {
  late TextEditingController descriptionController;
  late TextEditingController quantityController;
  late TextEditingController unitPriceController;
  late TextEditingController hsnController;
  late TextEditingController taxRateController;
  late TextEditingController notesController;

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController(
      text: widget.item.description,
    );
    quantityController = TextEditingController(
      text: widget.item.quantity.toString(),
    );
    unitPriceController = TextEditingController(
      text: widget.item.unitPrice.toStringAsFixed(2),
    );
    hsnController = TextEditingController(text: widget.item.hsn);
    taxRateController = TextEditingController(
      text: widget.item.taxRate.toStringAsFixed(0),
    );
    notesController = TextEditingController(text: widget.item.notes);
  }

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
        ),
      );
      return;
    }

    widget.item.description = descriptionController.text.trim();
    widget.item.quantity = int.tryParse(quantityController.text) ?? 1;
    widget.item.unitPrice = double.tryParse(unitPriceController.text) ?? 0.0;
    widget.item.hsn = hsnController.text.trim();
    widget.item.taxRate = double.tryParse(taxRateController.text) ?? 18;
    widget.item.notes = notesController.text.trim();

    widget.onSave(widget.item);
    Navigator.pop(context);
  }

  void _handleDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text(
          'Are you sure you want to delete "${widget.item.description}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onDelete();
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
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
                const Icon(Icons.edit, color: Colors.orange, size: 28),
                const SizedBox(width: 8),
                const Text(
                  'Edit Line Item',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Description',
              controller: descriptionController,
              icon: Icons.description,
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
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: _handleDelete,
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _handleSave,
                      icon: const Icon(Icons.save),
                      label: const Text(
                        'Update',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
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
