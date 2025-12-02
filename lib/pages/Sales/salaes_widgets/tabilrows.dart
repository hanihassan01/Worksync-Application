
import 'package:flutter/material.dart';
import 'package:worksync/pages/Sales/model/sales_table_model_class.dart';

class InvoiceTableRow extends StatelessWidget {
  final InvoiceItem item;       
  final int index;              
  final double rowHeight;       
  final bool isPhone;           
  final VoidCallback onTap;     


  const InvoiceTableRow({
    super.key,
    required this.item,        
    required this.index,
    required this.rowHeight,
    required this.isPhone,
    required this.onTap,
  });
  


  @override
  Widget build(BuildContext context) {
  
    double noWidth = isPhone ? 50 : 60;
    double itemNameWidth = isPhone ? 150 : 200;
    double qtyWidth = isPhone ? 70 : 80;
    double rateWidth = isPhone ? 100 : 120;
    double amountWidth = isPhone ? 100 : 120;
    double uomWidth = isPhone ? 80 : 100;
    double remarksWidth = isPhone ? 150 : 180;
    

    
    return InkWell(
      onTap: onTap,  
      
      child: Container(
        height: rowHeight,
        decoration: BoxDecoration(

          color: index.isEven ? Colors.white : Colors.grey.shade50,
      
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
        child: Row(
          children: [
            _buildDataCell('${index + 1}', noWidth),

            
            _buildDataCell(item.itemName, itemNameWidth),
            _buildDataCell('${item.quantity}', qtyWidth),
            _buildDataCell('₹${item.rate.toStringAsFixed(2)}', rateWidth),
            _buildDataCell('₹${item.amount.toStringAsFixed(2)}', amountWidth),
            _buildDataCell(item.uom, uomWidth),
            _buildDataCell(item.remarks.isEmpty ? '-' : item.remarks, remarksWidth),

          ],
        ),
      ),
    );
  }


  Widget _buildDataCell(String text, double width) {
    return Container(
      width: width,               
      height: rowHeight,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
   
      ),
    );
  }
}