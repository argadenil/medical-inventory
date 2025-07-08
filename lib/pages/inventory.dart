import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  List<Map<String, String>> inventoryData = [];
  List<Map<String, String>> filteredData = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _initFirebaseAndFetchData();
  }

  void _showAddMedicineDialog() {
    String name = '';
    String category = '';
    String expiry = '';
    String status = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Medicine"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Medicine Name'),
                  onChanged: (value) => name = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Category'),
                  onChanged: (value) => category = value,
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Expiry Date (YYYY-MM-DD)',
                  ),
                  onChanged: (value) => expiry = value,
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Status (In Stock / Low / Out of Stock)',
                  ),
                  onChanged: (value) => status = value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Color statusColor;
                IconData statusIcon;

                switch (status.toLowerCase()) {
                  case 'in stock':
                    statusColor = Colors.green;
                    statusIcon = Icons.check_circle;
                    break;
                  case 'low':
                    statusColor = Colors.orange;
                    statusIcon = Icons.warning;
                    break;
                  case 'out of stock':
                    statusColor = Colors.red;
                    statusIcon = Icons.cancel;
                    break;
                  default:
                    statusColor = Colors.grey;
                    statusIcon = Icons.help_outline;
                }

                setState(() {
                  inventoryData.add({
                    "name": name,
                    "category": category,
                    "expiry": expiry,
                    "status": status,
                  });
                });

                Navigator.pop(context);
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _initFirebaseAndFetchData() async {
    final db = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          'https://medical-ims-6ed83-default-rtdb.asia-southeast1.firebasedatabase.app',
    );
    final ref = db.ref();
    final snapshot = await ref.get();
    if (snapshot.exists && snapshot.value is List) {
      final List medicines = snapshot.value as List;
      inventoryData = medicines
          .where((item) => item != null)
          .map<Map<String, String>>((item) => Map<String, String>.from(item))
          .toList();
      print('inventoryData.length.  ${inventoryData.length}');
    } else {
      inventoryData = [];
    }
    setState(() {
      filteredData = List.from(inventoryData);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(3, 4, 94, 1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Inventory",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              // Search and Filter Row
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search",
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.filter_list),
                        SizedBox(width: 8),
                        Text("Filter by"),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Inventory Table
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      // Table Header
                      Row(
                        children: const [
                          Expanded(
                            child: Text(
                              "Medicine Name",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Category",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Expiry",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Status",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      // Table Rows
                      Expanded(
                        child: ListView.builder(
                          itemCount: inventoryData.length,
                          itemBuilder: (context, index) {
                            final item = inventoryData[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  Expanded(child: Text(item["name"] ?? "")),
                                  Expanded(child: Text(item["category"] ?? "")),
                                  Expanded(child: Text(item["expiry"] ?? "")),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(
                                          item["icon"] != null
                                              ? IconData(
                                                  int.parse(item["icon"]!),
                                                  fontFamily: 'MaterialIcons',
                                                )
                                              : Icons.help_outline,
                                          size: 18,
                                          color: item["color"] != null
                                              ? Color(int.parse(item["color"]!))
                                              : Colors.grey,
                                        ),
                                        const SizedBox(width: 6),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const Divider(),
                      TextButton.icon(
                        onPressed: _showAddMedicineDialog,
                        icon: const Icon(Icons.add),
                        label: const Text("Add New Medicine"),
                      ),
                    ],
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
