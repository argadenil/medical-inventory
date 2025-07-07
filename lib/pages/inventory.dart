import 'package:flutter/material.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  final List<Map<String, dynamic>> inventory = [
    {
      "name": "Paracetamol",
      "category": "Pain Relief",
      "expiry": "1206-11",
      "status": "In Stock",
      "color": Colors.green,
      "icon": Icons.check_circle,
    },
    {
      "name": "Amoxicillin",
      "category": "Antibiotic",
      "expiry": "15",
      "status": "Low",
      "color": Colors.orange,
      "icon": Icons.warning,
    },
    {
      "name": "Cetirizine",
      "category": "MedsCo",
      "expiry": "2025-08-20",
      "status": "Meloebrilis",
      "color": Colors.blueGrey,
      "icon": Icons.info_outline,
    },
    {
      "name": "Allergy",
      "category": "HealthPlus",
      "expiry": "2025-07-30",
      "status": "Out of Stock",
      "color": Colors.red,
      "icon": Icons.cancel,
    },
  ];

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
                  inventory.add({
                    "name": name,
                    "category": category,
                    "expiry": expiry,
                    "status": status,
                    "color": statusColor,
                    "icon": statusIcon,
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
                          itemCount: inventory.length,
                          itemBuilder: (context, index) {
                            final item = inventory[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  Expanded(child: Text(item["name"])),
                                  Expanded(child: Text(item["category"])),
                                  Expanded(child: Text(item["expiry"])),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(
                                          item["icon"],
                                          size: 18,
                                          color: item["color"],
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
