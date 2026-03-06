import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DoseUp Dashboard"),
        centerTitle: false,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Text
            const Text(
              "Welcome to DoseUp 👋",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Compare medicine prices, find generic alternatives, and check availability.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 32),

            // Action Cards
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // 2 cards per row (perfect for web)
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.6,
                children: [
                  dashboardCard(
                    context,
                    icon: Icons.search,
                    title: "Search Medicine",
                    subtitle: "Find medicines quickly",
                    route: '/search',
                  ),
                  dashboardCard(
                    context,
                    icon: Icons.compare,
                    title: "Compare Prices",
                    subtitle: "Find cheaper alternatives",
                    route: '/compare',
                  ),
                  dashboardCard(
                    context,
                    icon: Icons.store,
                    title: "Check Availability",
                    subtitle: "View pharmacy availability",
                    route: '/availability',
                  ),
                  dashboardCard(
                    context,
                    icon: Icons.smart_toy,
                    title: "AI Assistant",
                    subtitle: "Get help using DoseUp",
                    route: '/assistant',
                  ),
                  dashboardCard(
                    context,
                    icon: Icons.search,
                    title: "🧾 Prescription Reader",
                    subtitle: "Read Prescriptions easily",
                    route: '/prescription',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Dashboard Card Widget
  Widget dashboardCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String route,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue.shade100),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 48,
              color: Colors.blue,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
