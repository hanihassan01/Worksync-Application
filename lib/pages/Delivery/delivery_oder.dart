import 'package:flutter/material.dart';

class DeliveryOrderPage extends StatefulWidget {
  final String? orderId;

  const DeliveryOrderPage({super.key, this.orderId});

  @override
  State<DeliveryOrderPage> createState() => _DeliveryOrderPageState();
}

class _DeliveryOrderPageState extends State<DeliveryOrderPage> {
  late bool isViewMode;
  String? currentOrderId;
  String customerName = '';
  String customerPhone = '';
  String deliveryAddress = '';
  String currentStatus = '';
  List<Map<String, dynamic>> orderItems = [];

  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerPhoneController =
      TextEditingController();
  final TextEditingController _deliveryAddressController =
      TextEditingController();

  final List<Map<String, dynamic>> _demoDliveryOrders = [
    {
      'id': 'ORD-2024-00125',
      'customer': 'Rajesh Kumar',
      'phone': '+91 98765 43210',
      'address':
          '123, Sunshine Apartments, MG Road, Sector 14, Gurugram, Haryana, 122001',
      'status': 'out_for_delivery',
      'items': [
        {'name': 'Product A', 'unit': '500g', 'qty': 2},
        {'name': 'Product B', 'unit': '1kg', 'qty': 1},
        {'name': 'Product C', 'unit': '2 units', 'qty': 3},
      ],
    },
    {
      'id': 'ORD-2024-00120',
      'customer': 'Neha Gupta',
      'phone': '+91 98765 12345',
      'address': '456, Green Park Heights, Dwarka, New Delhi, 110075',
      'status': 'out_for_delivery',
      'items': [
        {'name': 'Product A', 'unit': '500g', 'qty': 1},
        {'name': 'Product D', 'unit': '250g', 'qty': 2},
      ],
    },
    {
      'id': 'ORD-2024-00117',
      'customer': 'Suresh Kumar',
      'phone': '+91 98765 67890',
      'address': '789, Metro Plaza, Bangalore, Karnataka, 560001',
      'status': 'delivered',
      'items': [
        {'name': 'Product B', 'unit': '1kg', 'qty': 2},
        {'name': 'Product C', 'unit': '2 units', 'qty': 1},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    isViewMode = widget.orderId != null;
    if (isViewMode) {
      _loadDemoOrderData();
    }
  }

  void _loadDemoOrderData() {
    final order = _demoDliveryOrders.firstWhere(
      (o) => o['id'] == widget.orderId,
      orElse: () => _demoDliveryOrders[0],
    );

    currentOrderId = order['id'];
    customerName = order['customer'];
    customerPhone = order['phone'];
    deliveryAddress = order['address'];
    currentStatus = order['status'];
    orderItems = List<Map<String, dynamic>>.from(order['items']);

    _customerNameController.text = customerName;
    _customerPhoneController.text = customerPhone;
    _deliveryAddressController.text = deliveryAddress;
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'out_for_delivery':
        return 'Out for Delivery';
      case 'delivered':
        return 'Delivered';
      default:
        return 'Unknown';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return const Color(0xFFFFC107);
      case 'out_for_delivery':
        return const Color(0xFFFF9800);
      case 'delivered':
        return const Color(0xFF4CAF50);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isViewMode
              ? 'Order #${widget.orderId} Details'
              : 'New Delivery Order',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: isViewMode
            ? [
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.black),
                  onPressed: () {},
                ),
              ]
            : [],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isViewMode) ...[
                // Customer Information
                _buildSectionCard(
                  title: 'Customer Information',
                  children: [
                    _buildInfoRow('Name', customerName),
                    _buildInfoRow('Phone', customerPhone),
                  ],
                ),
                const SizedBox(height: 16),
                // Delivery Address
                _buildSectionCard(
                  title: 'Delivery Address',
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                deliveryAddress,
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.location_on,
                            color: Colors.blue.shade600,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ] else ...[
                // Create mode - form fields
                _buildFormField('Customer Name', _customerNameController),
                const SizedBox(height: 12),
                _buildFormField('Customer Phone', _customerPhoneController),
                const SizedBox(height: 12),
                _buildFormField(
                  'Delivery Address',
                  _deliveryAddressController,
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
              ],
              // Order Summary
              _buildSectionCard(
                title: 'Order Summary',
                children: [
                  if (orderItems.isNotEmpty)
                    Column(
                      children: List.generate(orderItems.length, (index) {
                        final item = orderItems[index];
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item['unit'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Qty: ${item['qty']}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            if (index < orderItems.length - 1)
                              const SizedBox(height: 12),
                            if (index < orderItems.length - 1)
                              Divider(height: 12, color: Colors.grey.shade200),
                            if (index < orderItems.length - 1)
                              const SizedBox(height: 12),
                          ],
                        );
                      }),
                    )
                  else
                    Text(
                      'No items added',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              // Current Status (only in view mode)
              if (isViewMode)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _getStatusColor(currentStatus).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Status',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getStatusLabel(currentStatus),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(currentStatus),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
              // Action Buttons
              if (isViewMode) ...[
                if (currentStatus == 'out_for_delivery')
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Delivery marked as complete'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B9B6F),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Confirm Delivery Done',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Issue reported')),
                      );
                    },
                    child: Text(
                      'Report Issue',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Delivery order created')),
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Create Delivery Order',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildFormField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: 'Enter $label',
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _deliveryAddressController.dispose();
    super.dispose();
  }
}
