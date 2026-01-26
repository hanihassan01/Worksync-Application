import 'package:flutter/material.dart';
import 'package:worksync/pages/invoice/model/invoice_item_model.dart';
import 'package:worksync/pages/invoice/invoice_widgets/invoice_table_row.dart';
import 'package:worksync/pages/invoice/invoice_widgets/invoice_table_header.dart';

class InvoiceTable extends StatefulWidget {
  final List<InvoiceLineItem> items;
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
    final noWidth = widget.isPhone ? 50.0 : 60.0;
    final descriptionWidth = widget.isPhone ? 150.0 : 200.0;
    final qtyWidth = widget.isPhone ? 70.0 : 80.0;
    final unitPriceWidth = widget.isPhone ? 100.0 : 120.0;
    final hsnWidth = widget.isPhone ? 80.0 : 100.0;
    final taxRateWidth = widget.isPhone ? 70.0 : 80.0;
    final lineTotalWidth = widget.isPhone ? 100.0 : 120.0;

    final totalWidth =
        noWidth +
        descriptionWidth +
        qtyWidth +
        unitPriceWidth +
        hsnWidth +
        taxRateWidth +
        lineTotalWidth;

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
              InvoiceTableHeader(
                rowHeight: widget.rowHeight,
                isPhone: widget.isPhone,
                wrapInScroll: false,
              ),
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
