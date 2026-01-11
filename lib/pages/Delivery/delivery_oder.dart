import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

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
  final List<TextEditingController> _deliveredQtyControllers = [];

  final List<Map<String, dynamic>> _demoDliveryOrders = [
    {
      'id': 'ORD-2024-00125',
      'customer': 'Rajesh Kumar',
      'phone': '+91 98765 43210',
      'address':
          '123, Sunshine Apartments, MG Road, Sector 14, Gurugram, Haryana, 122001',
      'status': 'out_for_delivery',
      'items': [
        {
          'name': 'Premium Organic Himalayan Rock Salt Grinder Large',
          'unit': '500g Pack',
          'ordered': 2,
          'delivered': 2
        },
        {
          'name': 'Fresh Farm Vegetable Box - Season Special Selection',
          'unit': '2 Units',
          'ordered': 3,
          'delivered': 2
        },
        {
          'name': 'Whole Wheat Artisan Sourdough Bread Loaf',
          'unit': '1kg Pack',
          'ordered': 1,
          'delivered': 0
        },
      ],
    },
    {
      'id': 'ORD-2024-00120',
      'customer': 'Neha Gupta',
      'phone': '+91 98765 12345',
      'address': '456, Green Park Heights, Dwarka, New Delhi, 110075',
      'status': 'out_for_delivery',
      'items': [
        {'name': 'Product A', 'unit': '500g', 'ordered': 1, 'delivered': 1},
        {'name': 'Product D', 'unit': '250g', 'ordered': 2, 'delivered': 0},
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
    _initializeQtyControllers();
  }

  void _launchMap(String address) async {
    // Get current location
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Handle permission denied
      return;
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final query = Uri.encodeComponent(address);
    final url =
        'https://www.google.com/maps/dir/?api=1&origin=${position.latitude},${position.longitude}&destination=$query';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _initializeQtyControllers() {
    _deliveredQtyControllers.clear();
    for (final item in orderItems) {
      final controller =
          TextEditingController(text: item['delivered']?.toString() ?? '0');
      _deliveredQtyControllers.add(controller);
    }
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
      backgroundColor: const Color(0xFFF0F4F8), // Lighter blue-gray background
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isViewMode
              ? 'Order #${currentOrderId?.split('-').last} Details'
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
                // ============================================================
                // CUSTOMER INFORMATION CONTAINER (White)
                // ============================================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customer Information',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        customerName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        customerPhone,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delivery Address',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              deliveryAddress,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade800,
                                height: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () => _launchMap(deliveryAddress),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.map_outlined,
                                color: Color.fromARGB(255, 0, 149, 255),
                                size: 54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ============================================================
                // ORDER SUMMARY CONTAINER (White with checkboxes)
                // ============================================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order Summary',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            'TRACKING QUANTITIES',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      _buildOrderSummaryHeader(),

                      const SizedBox(height: 8),

                      // Items List
                      Column(
                        children: List.generate(orderItems.length, (index) {
                          final item = orderItems[index];
                          return _buildOrderItemRow(item, index);
                        }),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF9E6),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFDEEB9)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'CURRENT STATUS',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getStatusLabel(currentStatus),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                if (currentStatus == 'out_for_delivery')
                  Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1B9B6F).withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      color: const Color(0xFF1B9B6F),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Delivery marked as complete'),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Confirm Delivery & Update Status',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.check_circle_outline,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
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
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ] else ...[
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

  Widget _buildStatusWidget(Map<String, dynamic> item) {
    final int ordered = item['ordered'];
    final int delivered = item['delivered'];

    if (delivered == ordered) {
      return const Icon(Icons.check_circle, color: Colors.green, size: 24);
    } else if (delivered == 0) {
      return _buildStatusBadge('NOT DELIV.', Colors.red);
    } else if (delivered > 0 && delivered < ordered) {
      return _buildStatusBadge('PARTIAL', Colors.orange);
    } else {
      return const SizedBox(width: 50);
    }
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
            color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildOrderSummaryHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        children: [
          const Expanded(
            flex: 5,
            child: Text('ITEM',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
          ),
          const Expanded(
            flex: 2,
            child: Text('ORD.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
          ),
          const Expanded(
            flex: 3,
            child: Text('DELIVERED',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
          ),
          const Expanded(
            flex: 2,
            child: Text('STATUS',
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemRow(Map<String, dynamic> item, int index) {
    Widget statusWidget = _buildStatusWidget(item);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(item['unit'],
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item['ordered'].toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Container(
                width: 60,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  controller: _deliveredQtyControllers[index],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) {
                    setState(() {
                      int deliveredQty = int.tryParse(value) ?? 0;
                      if (deliveredQty < 0) {
                        deliveredQty = 0;
                      } else if (deliveredQty > item['ordered']) {
                        deliveredQty = item['ordered'];
                      }
                      item['delivered'] = deliveredQty;
                      _deliveredQtyControllers[index].text =
                          deliveredQty.toString();
                      _deliveredQtyControllers[index].selection =
                          TextSelection.fromPosition(TextPosition(
                              offset: _deliveredQtyControllers[index]
                                  .text
                                  .length));
                    });
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: statusWidget,
            ),
          ),
        ],
      ),
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
            fillColor: Colors.white,
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
    for (final controller in _deliveredQtyControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
