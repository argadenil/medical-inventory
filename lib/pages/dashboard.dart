import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final summaryData = [
    {
      'icon': Icons.bar_chart,
      'label': 'Total Medicines',
      'value': '1240',
      'color': Color.fromRGBO(65, 112, 162, 1),
    },
    {
      'icon': Icons.warning_amber_rounded,
      'label': 'Low Stock',
      'value': '24',
      'color': Colors.orange,
    },
    {
      'icon': Icons.warning_rounded,
      'label': 'Expiring Soon',
      'value': '18',
      'color': Colors.red,
    },
  ];

  List<Map<String, String>> inventoryData = [];
  List<Map<String, String>> filteredData = [];
  @override
  void initState() {
    super.initState();
    _initFirebaseAndFetchData();
    //filteredData = List.from(inventoryData);
  }

  Future<void> _initFirebaseAndFetchData() async {
    await Firebase.initializeApp();
    final db = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          'https://medical-ims-6ed83-default-rtdb.asia-southeast1.firebasedatabase.app',
    );
    final ref = db.ref();
    final snapshot = await ref.get();
    if (snapshot.exists && snapshot.value is List) {
      final List medicines = snapshot.value as List;
      summaryData[0]['value'] = medicines.length.toString();
      inventoryData = medicines
          .where((item) => item != null)
          .map<Map<String, String>>((item) => Map<String, String>.from(item))
          .toList();
    } else if (snapshot.exists && snapshot.value is Map) {
      final Map medicines = snapshot.value as Map;
      inventoryData = medicines.values
          .map<Map<String, String>>((item) => Map<String, String>.from(item))
          .toList();
    } else {
      inventoryData = [];
    }
    setState(() {
      filteredData = List.from(inventoryData);
    });
  }

  void _filterInventory(String query) {
    setState(() {
      filteredData = inventoryData
          .where(
            (item) =>
                item['name']!.toLowerCase().contains(query.toLowerCase()) ||
                item['category']!.toLowerCase().contains(query.toLowerCase()) ||
                item['supplier']!.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 4, 94, 1),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Dashboard",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: summaryData.map((data) {
                return Expanded(
                  child: Card(
                    elevation: 8, // More prominent shadow
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 12,
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: (data['color'] as Color)
                                .withOpacity(0.2),
                            radius: 35,
                            child: Icon(
                              data['icon'] as IconData,
                              size: 45,
                              color: data['color'] as Color,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            data['label'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            data['value'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextField(
                    onChanged: _filterInventory,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Search',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Text(
              "Medicine Inventory",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            // ...existing code...
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                // ...existing code...
                child: SingleChildScrollView(
                  child: ExpansionPanelList.radio(
                    children: filteredData
                        .asMap()
                        .entries
                        .map<ExpansionPanelRadio>((entry) {
                          final index = entry.key;
                          final medicine = entry.value;
                          Icon statusIcon;
                          switch (medicine['status']) {
                            case 'In Stock':
                              statusIcon = const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 35,
                              );
                              break;
                            case 'Low':
                              statusIcon = const Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.orange,
                                size: 35,
                              );
                              break;
                            case 'Out of Stock':
                              statusIcon = const Icon(
                                Icons.warning_rounded,
                                color: Colors.red,
                                size: 35,
                              );
                              break;
                            default:
                              statusIcon = const Icon(
                                Icons.info_outline,
                                color: Colors.grey,
                                size: 20,
                              );
                          }

                          return ExpansionPanelRadio(
                            value: medicine['name']!,
                            headerBuilder: (context, isExpanded) => ListTile(
                              leading: Text(
                                '${index + 1}',
                                style: TextStyle(fontSize: 15),
                              ),
                              title: Text('${medicine['name']}'),
                              subtitle: Text(medicine['category']!),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [statusIcon],
                              ),
                            ),
                            body: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // <-- Add this line
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.date_range),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Expiry Date: ${medicine['expiry']}',
                                      ),
                                      SizedBox(width: 10),
                                      Text('Supplier: ${medicine['supplier']}'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        })
                        .toList(),
                  ),
                ),
              ),
              // ...existing code... ),
            ),
            // ...existing code...],
          ],
        ),
      ),
    );
  }
}
