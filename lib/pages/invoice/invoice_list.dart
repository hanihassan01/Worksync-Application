import 'package:flutter/material.dart';
import 'package:worksync/pages/invoice/invoice_detail_view.dart';

class InvoiceListPage extends StatefulWidget {
  const InvoiceListPage({super.key});

  @override
  State<InvoiceListPage> createState() => _InvoiceListPageState();
}

class _InvoiceListPageState extends State<InvoiceListPage> {
  // Demo invoice data
  final List<Map<String, dynamic>> _demoInvoices = [
    {
      'id': 'INV-001',
      'customer': 'ABC Company Ltd.',
      'amount': 5000,
      'status': 'paid',
      'invoiceDate': 'Jan 26, 2026',
      'dueDate': 'Feb 25, 2026',
    },
    {
      'id': 'INV-002',
      'customer': 'XYZ Industries',
      'amount': 7500,
      'status': 'pending',
      'invoiceDate': 'Jan 20, 2026',
      'dueDate': 'Feb 19, 2026',
    },
    {
      'id': 'INV-003',
      'customer': 'Global Solutions',
      'amount': 3200,
      'status': 'overdue',
      'invoiceDate': 'Dec 26, 2025',
      'dueDate': 'Jan 25, 2026',
    },
    {
      'id': 'INV-004',
      'customer': 'Tech Innovations',
      'amount': 12000,
      'status': 'paid',
      'invoiceDate': 'Jan 15, 2026',
      'dueDate': 'Feb 14, 2026',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: SafeArea(
        top: false,
        bottom: false,
        child: ListView.separated(
          padding: const EdgeInsets.all(12.0),
          itemCount: _demoInvoices.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final invoice = _demoInvoices[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          InvoiceDetailView(invoiceData: invoice),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.description,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Invoice #${invoice['id']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              invoice['customer'],
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Due: ${invoice['dueDate']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '₹${invoice['amount']}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(invoice['status']),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getStatusLabel(invoice['status']),
                              style: TextStyle(
                                color: _getStatusTextColor(invoice['status']),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'paid':
        return Colors.green.shade100;
      case 'pending':
        return Colors.orange.shade100;
      case 'overdue':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'paid':
        return Colors.green.shade800;
      case 'pending':
        return Colors.orange.shade800;
      case 'overdue':
        return Colors.red.shade800;
      default:
        return Colors.grey.shade800;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'paid':
        return 'Paid';
      case 'pending':
        return 'Pending';
      case 'overdue':
        return 'Overdue';
      default:
        return status;
    }
  }
}
