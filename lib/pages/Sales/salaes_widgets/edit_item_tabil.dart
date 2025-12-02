

import 'package:flutter/material.dart';
import 'package:worksync/pages/Sales/model/sales_table_model_class.dart';

class AddInvoiceItemSheet extends StatefulWidget {
  final Function(InvoiceItem) onSave;  

  const AddInvoiceItemSheet({
    super.key,
    required this.onSave,             
  });
  
 
  @override
  State<AddInvoiceItemSheet> createState() => _AddInvoiceItemSheetState();
}

class _AddInvoiceItemSheetState extends State<AddInvoiceItemSheet> {

  final itemNameController = TextEditingController();
  final quantityController = TextEditingController(text: '1');
  final rateController = TextEditingController(text: '0.00');
  final uomController = TextEditingController(text: 'pcs');
  final remarksController = TextEditingController();
  
  
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
          duration: Duration(seconds: 2),
        ),
      );
      return; 
    }
    
    
    final newItem = InvoiceItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
   
      
      itemName: itemNameController.text.trim(),
     
      
      quantity: int.tryParse(quantityController.text) ?? 1,
     
      
      rate: double.tryParse(rateController.text) ?? 0.0,
     
      
      uom: uomController.text.trim(),
      remarks: remarksController.text.trim(),
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
                  'Add New Item',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
        
            _buildTextField(
              label: 'Item Name',
              controller: itemNameController,
              icon: Icons.inventory,
              hint: 'e.g., Laptop, Mouse, Keyboard',
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
                    hint: 'pcs, kg, liters',
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
              hint: 'Any additional notes',
              maxLines: 3,
            ),
            
            const SizedBox(height: 24),
            
           
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Cancel Button
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(width: 8),
                
                // Save Button
                ElevatedButton.icon(
                  onPressed: _handleSave,
                  icon: const Icon(Icons.save),
                  label: const Text(
                    'Save',
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