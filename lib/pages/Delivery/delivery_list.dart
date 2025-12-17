import 'package:flutter/material.dart';
import 'delivery_oder.dart';

class DeliveryListPage extends StatefulWidget {
  const DeliveryListPage({super.key});

  @override
  State<DeliveryListPage> createState() => _DeliveryListPageState();
}

class _DeliveryListPageState extends State<DeliveryListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _demoOrders = [
    {'id': 'ORD-2024-00125', 'customer': 'Rajesh Kumar', 'status': 'pending'},
    {'id': 'ORD-2024-00124', 'customer': 'Priya Sharma', 'status': 'pending'},
    {'id': 'ORD-2024-00123', 'customer': 'Amit Singh', 'sticoatus': 'pending'},
    {'id': 'ORD-2024-00122', 'customer': 'Sunita Devi', 'status': 'pending'},
    {'id': 'ORD-2024-00121', 'customer': 'Arun Patel', 'status': 'pending'},
    {
      'id': 'ORD-2024-00120',
      'customer': 'Neha Gupta',
      'status': 'out_for_delivery',
    },
    {
      'id': 'ORD-2024-00119',
      'customer': 'Vikram Desai',
      'status': 'out_for_delivery',
    },
    {
      'id': 'ORD-2024-00118',
      'customer': 'Pooja Singh',
      'status': 'out_for_delivery',
    },
    {'id': 'ORD-2024-00117', 'customer': 'Suresh Kumar', 'status': 'delivered'},
    {'id': 'ORD-2024-00116', 'customer': 'Anita Verma', 'status': 'delivered'},
    {'id': 'ORD-2024-00115', 'customer': 'Ravi Chopra', 'status': 'delivered'},
    {'id': 'ORD-2024-00114', 'customer': 'Divya Nair', 'status': 'delivered'},
    {'id': 'ORD-2024-00113', 'customer': 'Manoj Joshi', 'status': 'delivered'},
    {'id': 'ORD-2024-00112', 'customer': 'Sneha Reddy', 'status': 'delivered'},
    {'id': 'ORD-2024-00111', 'customer': 'Karan Singh', 'status': 'delivered'},
    {'id': 'ORD-2024-00110', 'customer': 'Zara Khan', 'status': 'delivered'},
    {'id': 'ORD-2024-00109', 'customer': 'Arjun Roy', 'status': 'delivered'},
    {
      'id': 'ORD-2024-00108',
      'customer': 'Priyanka Menon',
      'status': 'delivered',
    },
    {
      'id': 'ORD-2024-00107',
      'customer': 'Deepak Saxena',
      'status': 'delivered',
    },
    {'id': 'ORD-2024-00106', 'customer': 'Kavya Iyer', 'status': 'delivered'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getFilteredOrders(String status) {
    return _demoOrders
        .where(
          (o) =>
              o['status'] == status &&
              (o['id'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  o['customer'].toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  )),
        )
        .toList();
  }

  int _getPendingCount() =>
      _demoOrders.where((o) => o['status'] == 'pending').length;
  int _getOutForDeliveryCount() =>
      _demoOrders.where((o) => o['status'] == 'out_for_delivery').length;
  int _getDeliveredCount() =>
      _demoOrders.where((o) => o['status'] == 'delivered').length;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search by Order ID or Customer Name',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      color: Colors.blue.shade400,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
            // TabBar with delivery-specific tabs
            Material(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: Colors.blue.shade600, width: 3),
                  insets: const EdgeInsets.symmetric(horizontal: 0),
                ),
                labelColor: Colors.blue.shade600,
                unselectedLabelColor: Colors.grey.shade600,
                tabs: [
                  Tab(text: 'Pending (${_getPendingCount()})'),
                  Tab(text: 'Out for Delivery (${_getOutForDeliveryCount()})'),
                  Tab(text: 'Delivered (${_getDeliveredCount()})'),
                ],
              ),
            ),
            // TabBarView
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOrdersList('pending'),
                  _buildOrdersList('out_for_delivery'),
                  _buildOrdersList('delivered'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList(String status) {
    final items = _getFilteredOrders(status);

    if (items.isEmpty) {
      return Center(
        child: Text(
          'No orders found',
          style: TextStyle(color: Colors.grey.shade600),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12.0),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 0),
      itemBuilder: (context, index) {
        final o = items[index];
        return Card(
          elevation: 0,
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DeliveryOrderPage(orderId: o['id']),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order ID',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '#${o['id']}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      _buildStatusBadge(o['status']),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customer',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        o['customer'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
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

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case 'pending':
        bgColor = const Color(0xFFFFC107);
        textColor = Colors.black;
        label = 'Pending';
        break;
      case 'out_for_delivery':
        bgColor = const Color(0xFF2196F3);
        textColor = Colors.white;
        label = 'Out for Delivery';
        break;
      case 'delivered':
        bgColor = const Color(0xFF4CAF50);
        textColor = Colors.white;
        label = 'Delivered';
        break;
      default:
        bgColor = Colors.grey.shade300;
        textColor = Colors.black;
        label = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
