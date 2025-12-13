import 'package:flutter/material.dart';
// Sales order view page removed dependency; no DB interactions

class SalesListPage extends StatefulWidget {
  const SalesListPage({super.key});

  @override
  State<SalesListPage> createState() => _SalesListPageState();
}

class _SalesListPageState extends State<SalesListPage>
    with SingleTickerProviderStateMixin {
  // No persistent orders (database removed). Show empty lists.
  late TabController _tabController;

  // Demo data used to show tappable list items that navigate to the
  // order view page. Each entry has an id, customer, amount and status.
  final List<Map<String, dynamic>> _demoOrders = [
    {'id': 'SO-001', 'customer': 'Customer A', 'amount': 500, 'status': 'paid'},
    {
      'id': 'SO-002',
      'customer': 'Customer B',
      'amount': 750,
      'status': 'pending',
    },
    {
      'id': 'SO-003',
      'customer': 'Customer C',
      'amount': 250,
      'status': 'pending',
    },
    {
      'id': 'SO-004',
      'customer': 'Customer D',
      'amount': 1000,
      'status': 'paid',
    },
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
   
    return Container(
      color: Colors.grey.shade100,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            Material(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: Colors.black, width: 6.0),

                  insets: EdgeInsets.symmetric(horizontal: 152.0),
                ),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey.shade600,
                tabs: const [
                  Tab(text: 'Sales Orders'),
                  Tab(text: 'Sales Invoices'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Sales Orders tab
                  _buildOrdersList('draft'),

                  // Invoices tab (submitted orders)
                  _buildOrdersList('submitted'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList(String status) {
    final filterStatus = status == 'draft' ? 'pending' : 'paid';
    final items = _demoOrders
        .where((o) => o['status'] == filterStatus)
        .toList();

    if (items.isEmpty) {
      return Center(
        child: Text(
          'No ${status == 'draft' ? 'draft' : 'submitted'} orders',
          style: TextStyle(color: Colors.grey.shade600),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12.0),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final o = items[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              showDialog<void>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Order ${o['id']}'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Customer: ${o['customer']}'),
                      const SizedBox(height: 8),
                      Text('Amount: ₹${o['amount']}'),
                      const SizedBox(height: 8),
                      Text(
                        'Status: ${o['status'] == 'paid' ? 'Paid' : 'Pending'}',
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.receipt_long,
                      color: Colors.green.shade700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${o['id']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          o['customer'],
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${o['amount']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: o['status'] == 'paid'
                              ? Colors.green.shade100
                              : Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          o['status'] == 'paid' ? 'Paid' : 'Pending',
                          style: TextStyle(
                            color: o['status'] == 'paid'
                                ? Colors.green.shade800
                                : Colors.orange.shade800,
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
    );
  }
}
