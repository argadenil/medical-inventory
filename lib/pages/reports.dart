import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
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
      'color': Color.fromRGBO(224, 94, 85, 1),
    },
    {
      'icon': Icons.warning_rounded,
      'label': 'Expiring Soon',
      'value': '18',
      'color': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(3, 4, 94, 1),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Reports",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              _summaryCards(),
              const SizedBox(height: 20),
              _barChartCard(),
              const SizedBox(height: 20),
              _pieChartCard(),
              const SizedBox(height: 20),
              _expiryTable(),
              const SizedBox(height: 20),
              _exportButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryCards() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [

        ],
      ),
    );
  }

  Widget _barChartCard() {
    return _cardWrapper(
      title: "Monthly Stock Inflow",
      child: SizedBox(
        height: 200,
        child: BarChart(
          BarChartData(
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 28),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, _) {
                    const labels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                    return Text(
                      labels[value.toInt()],
                      style: const TextStyle(color: Colors.black, fontSize: 10),
                    );
                  },
                ),
              ),
            ),
            barGroups: List.generate(6, (i) {
              final heights = [120, 140, 110, 160, 100, 180];
              return BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: heights[i].toDouble(),
                    color: Color.fromRGBO(3, 4, 94, 1),
                    width: 14,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _pieChartCard() {
    return _cardWrapper(
      title: "Stock by Category",
      child: SizedBox(
        height: 180,
        child: PieChart(
          PieChartData(
            centerSpaceRadius: 30,
            sections: [
              PieChartSectionData(
                value: 40,
                color: Colors.teal,
                title: 'Antibiotics',
              ),
              PieChartSectionData(
                value: 30,
                color: Colors.purple,
                title: 'Pain Relief',
              ),
              PieChartSectionData(
                value: 20,
                color: Colors.orange,
                title: 'Vitamins',
              ),
              PieChartSectionData(value: 10, color: Colors.red, title: 'Other'),
            ],
            sectionsSpace: 2,
          ),
        ),
      ),
    );
  }

  Widget _expiryTable() {
    return _cardWrapper(
      title: "Expiring Soon",
      child: Column(
        children: [
          _tableRow("Name", "Expiry", "Status", isHeader: true),
          const Divider(color: Colors.black12),
          _tableRow("Paracetamol", "Aug 2025", "In Stock"),
          _tableRow("Amoxicillin", "Jul 2025", "Low Stock"),
          _tableRow("Ibuprofen", "Sep 2024", "Out of Stock"),
        ],
      ),
    );
  }

  Widget _tableRow(
    String col1,
    String col2,
    String col3, {
    bool isHeader = false,
  }) {
    final style = TextStyle(
      color: isHeader ? Colors.grey[800] : Colors.black,
      fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(child: Text(col1, style: style)),
          Expanded(child: Text(col2, style: style)),
          Expanded(child: Text(col3, style: style)),
        ],
      ),
    );
  }

  Widget _exportButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          // Add export logic
        },
        icon: const Icon(Icons.download),
        label: const Text("Export PDF"),
      ),
    );
  }

  Widget _cardWrapper({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
