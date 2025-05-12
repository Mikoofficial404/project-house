import 'package:flutter/material.dart';
import 'package:project_house/ui/pages/pemilik_managment.dart';
import 'admin_page.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  final List<Map<String, dynamic>> menuItems = [
    {
      'title': 'Admin Pages',
      'icon': Icons.admin_panel_settings,
      'color': Colors.blue,
      'route': () => const AdminPage(),
    },
    {
      'title': 'Management Kosan',
      'icon': Icons.home_work,
      'color': Colors.green,
      'route': () => const AdminPage(),
    },
    {
      'title': 'Data Pemilik',
      'icon': Icons.people,
      'color': Colors.orange,
      'route': () => const PemilikManagment(),
    },
    {
      'title': 'Penghasilan',
      'icon': Icons.analytics,
      'color': Colors.purple,
      'route': () => const AdminPage(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            final item = menuItems[index];
            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => item['route']()),
                    ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item['icon'], size: 40, color: item['color']),
                    const SizedBox(height: 10),
                    Text(
                      item['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
