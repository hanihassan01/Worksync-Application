import 'package:flutter/material.dart';

class Home_page extends StatelessWidget {
  const Home_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to Settings Page
            },
            icon: Icon(Icons.settings_outlined, color: Colors.black, size: 26),
          ),
          const SizedBox(width: 10),
        ],
      ),

      body: Container(
        color: Color(0xFFe8f0f8),
        child: Column(
          children: [
            _buildProfileCard('Sarah'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 120,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Color(0xFFe8f0f8),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          height: 81,
                          width: 80,
                          child: Icon(
                            Icons.add_shopping_cart,
                            color: Colors.black,
                            size: 40,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'add new sales',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 120,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Color(0xFFe8f0f8),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          height: 81,
                          width: 80,
                          child: Icon(
                            Icons.local_shipping_outlined,
                            color: Colors.black,
                            size: 40,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'View deliveries',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 120,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Color(0xFFe8f0f8),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          height: 81,
                          width: 80,
                          child: Icon(
                            Icons.inventory_2_outlined,
                            color: Colors.black,
                            size: 40,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'check inventrory',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Daily Overview',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 200,
                      height: 80,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        // color: Color(0xFFF5F5F5),
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 12.0,
                                top: 11.0,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.wallet_outlined,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Todays Sales',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),

                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 15.0,
                                  top: 2.0,
                                ),
                                child: Text(
                                  '\$1500',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      height: 80,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        // color: Color(0xFFF5F5F5),
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 12.0,
                                top: 11.0,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.wallet_outlined,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Total Deliveries',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),

                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 15.0,
                                  top: 2.0,
                                ),
                                child: Text(
                                  '\$1500',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 200,
                      height: 80,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        // color: Color(0xFFF5F5F5),
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 12.0,
                                top: 11.0,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.wallet_outlined,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Pending Deliveries',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),

                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 15.0,
                                  top: 2.0,
                                ),
                                child: Text(
                                  '\$1500',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      height: 80,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        // color: Color(0xFFF5F5F5),
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 12.0,
                                top: 11.0,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.access_time_outlined,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Stock Summary',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),

                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 15.0,
                                  top: 2.0,
                                ),
                                child: Text(
                                  '\$1500',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildProfileCard(String name) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
    child: Center(
      child: Container(
        alignment: Alignment.topCenter,
        width: double.infinity,
        height: 240,
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 40,
              backgroundColor: Color.fromARGB(255, 202, 198, 198),
              child: Icon(Icons.person, size: 50, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
