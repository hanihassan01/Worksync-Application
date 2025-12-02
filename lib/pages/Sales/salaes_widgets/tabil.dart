// ============================================================
// FILE: lib/components/edit_invoice_item_sheet.dart
// PURPOSE: Bottom sheet form for editing existing invoice items
// ============================================================

import 'package:flutter/material.dart';
import 'package:worksync/pages/Sales/model/sales_table_model_class.dart';

class EditInvoiceItemSheet extends StatefulWidget {
  final InvoiceItem item;               // The item to edit
  final Function(InvoiceItem) onSave;   // Callback when saved
  final VoidCallback onDelete;          // Callback when deleted

  const EditInvoiceItemSheet({
    super.key,
    required this.item,
    required this.onSave,
    required this.onDelete,
  });

  @override
  State<EditInvoiceItemSheet> createState() => _EditInvoiceItemSheetState();
}

class _EditInvoiceItemSheetState extends State<EditInvoiceItemSheet> {
  late TextEditingController itemNameController;
  late TextEditingController quantityController;
  late TextEditingController rateController;
  late TextEditingController uomController;
  late TextEditingController remarksController;

  @override
  void initState() {
    super.initState();
    // Pre-fill with existing data
    itemNameController = TextEditingController(text: widget.item.itemName);
    quantityController = TextEditingController(text: widget.item.quantity.toString());
    rateController = TextEditingController(text: widget.item.rate.toStringAsFixed(2));
    uomController = TextEditingController(text: widget.item.uom);
    remarksController = TextEditingController(text: widget.item.remarks);
  }

  @override
  void dispose() {
    itemNameController.dispose();
    quantityController.dispose();
    rateController.dispose();
    uomController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (itemNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Please enter item name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Update existing item
    widget.item.itemName = itemNameController.text.trim();
    widget.item.quantity = int.tryParse(quantityController.text) ?? 1;
    widget.item.rate = double.tryParse(rateController.text) ?? 0.0;
    widget.item.uom = uomController.text.trim();
    widget.item.remarks = remarksController.text.trim();

    widget.onSave(widget.item);
    Navigator.pop(context);
  }

  void _handleDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "${widget.item.itemName}"?'),
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
                  'Edit Item',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            _buildTextField(
              label: 'Item Name',
              controller: itemNameController,
              icon: Icons.inventory,
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
                    label: 'UOM',
                    controller: uomController,
                    icon: Icons.scale,
                  ),
                ),
              ],
            ),
            
            _buildTextField(
              label: 'Rate (₹)',
              controller: rateController,
              icon: Icons.currency_rupee,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            
            _buildTextField(
              label: 'Remarks (Optional)',
              controller: remarksController,
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
                      child: const Text('Cancel', style: TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _handleSave,
                      icon: const Icon(Icons.save),
                      label: const Text('Update', style: TextStyle(fontSize: 16)),
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