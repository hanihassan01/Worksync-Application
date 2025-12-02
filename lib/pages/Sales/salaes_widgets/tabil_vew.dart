// ============================================================
// FILE: lib/components/invoice_table.dart
// PURPOSE: Main table container with fixed height and scrolling
// ============================================================

import 'package:flutter/material.dart';
import 'package:worksync/pages/Sales/model/sales_table_model_class.dart';
import 'package:worksync/pages/Sales/salaes_widgets/tabilrows.dart';
import 'package:worksync/pages/Sales/salaes_widgets/tablehead.dart';

class InvoiceTable extends StatefulWidget {
  final List<InvoiceItem> items;
  final Function(int) onRowTap;
  final double rowHeight;
  final int maxVisibleRows;
  final bool isPhone;

  const InvoiceTable({
    super.key,
    required this.items,
    required this.onRowTap,
    required this.rowHeight,
    required this.maxVisibleRows,
    required this.isPhone,
  });

  @override
  State<InvoiceTable> createState() => _InvoiceTableState();
}

class _InvoiceTableState extends State<InvoiceTable> {
  late final ScrollController _horizontalController;

  double get tableHeight =>
      widget.rowHeight + (widget.maxVisibleRows * widget.rowHeight);

  @override
  void initState() {
    super.initState();
    _horizontalController = ScrollController();
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // compute column widths (must match header and rows)
    final noWidth = widget.isPhone ? 50.0 : 60.0;
    final itemNameWidth = widget.isPhone ? 150.0 : 200.0;
    final qtyWidth = widget.isPhone ? 70.0 : 80.0;
    final rateWidth = widget.isPhone ? 100.0 : 120.0;
    final amountWidth = widget.isPhone ? 100.0 : 120.0;
    final uomWidth = widget.isPhone ? 80.0 : 100.0;
    final remarksWidth = widget.isPhone ? 150.0 : 180.0;

    final totalWidth =
        noWidth +
        itemNameWidth +
        qtyWidth +
        rateWidth +
        amountWidth +
        uomWidth +
        remarksWidth;

    return Container(
      height: tableHeight,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 2),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        controller: _horizontalController,
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: totalWidth,
          child: Column(
            children: [
              // Header (not wrapped) so it's inside the same horizontal scroll area
              InvoiceTableHeader(
                rowHeight: widget.rowHeight,
                isPhone: widget.isPhone,
                wrapInScroll: false,
              ),
              // Body: vertical scroll only
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: List.generate(widget.items.length, (index) {
                      final item = widget.items[index];
                      return InvoiceTableRow(
                        item: item,
                        index: index,
                        rowHeight: widget.rowHeight,
                        isPhone: widget.isPhone,
                        onTap: () => widget.onRowTap(index),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
