import 'package:flutter/material.dart';
import 'package:worksync/pages/invoice/model/invoice_item_model.dart';

class InvoiceTableRow extends StatelessWidget {
  final InvoiceLineItem item;
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
    double descriptionWidth = isPhone ? 150 : 200;
    double qtyWidth = isPhone ? 70 : 80;
    double unitPriceWidth = isPhone ? 100 : 120;
    double hsnWidth = isPhone ? 80 : 100;
    double taxRateWidth = isPhone ? 70 : 80;
    double lineTotalWidth = isPhone ? 100 : 120;

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
            _buildDataCell(item.description, descriptionWidth),
            _buildDataCell('${item.quantity}', qtyWidth),
            _buildDataCell(
              '₹${item.unitPrice.toStringAsFixed(2)}',
              unitPriceWidth,
            ),
            _buildDataCell(item.hsn, hsnWidth),
            _buildDataCell('${item.taxRate.toStringAsFixed(0)}%', taxRateWidth),
            _buildDataCell(
              '₹${item.lineTotal.toStringAsFixed(2)}',
              lineTotalWidth,
            ),
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
