import 'package:flutter/material.dart';

class InvoiceTableHeader extends StatelessWidget {
  final double rowHeight;
  final bool isPhone;
  final ScrollController? controller;
  final bool wrapInScroll;

  const InvoiceTableHeader({
    super.key,
    required this.rowHeight,
    required this.isPhone,
    this.controller,
    this.wrapInScroll = true,
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

    final headerRow = Container(
      height: rowHeight,
      decoration: BoxDecoration(
        color: const Color(0xFF1E5D7E),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          _buildHeaderCell('No', noWidth),
          _buildHeaderCell('Item Name', itemNameWidth),
          _buildHeaderCell('Qty', qtyWidth),
          _buildHeaderCell('Rate', rateWidth),
          _buildHeaderCell('Amount', amountWidth),
          _buildHeaderCell('UOM', uomWidth),
          _buildHeaderCell('Remarks', remarksWidth),
        ],
      ),
    );

    if (wrapInScroll) {
      return SingleChildScrollView(
        controller: controller,
        scrollDirection: Axis.horizontal,
        child: headerRow,
      );
    }

    return headerRow;
  }

  Widget _buildHeaderCell(String text, double width) {
    return Container(
      width: width,
      height: rowHeight,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
