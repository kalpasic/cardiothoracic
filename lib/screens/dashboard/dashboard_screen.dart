import 'package:flutter/material.dart';
import 'dart:ui';

// Screens
import 'package:medical_patient_app/screens/patients/patient_form_screen.dart';
import 'package:medical_patient_app/screens/patients/patient_list_screen.dart';
import 'package:medical_patient_app/screens/analytics/analytics_dashboard.dart';
import 'package:medical_patient_app/screens/settings/settings_screen.dart';

// Services & Widgets
import 'package:medical_patient_app/services/supabase_service.dart';
import 'package:medical_patient_app/widgets/glass_container.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const PatientListScreen(),
    const AnalyticsDashboard(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Medical Portal', style: TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.2)),
              child: const Icon(Icons.logout, size: 20),
            ),
            onPressed: () async {
              await supabase.auth.signOut();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color(0xFF0D9488).withOpacity(0.1), const Color(0xFF06B6D4).withOpacity(0.05), Colors.white],
          ),
        ),
        child: SafeArea(
          child: _screens[_selectedIndex],
        ),
      ),
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1)),
            ),
            child: NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() => _selectedIndex = index);
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              indicatorColor: const Color(0xFF0D9488).withOpacity(0.2),
              destinations: const [
                NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'Patients'),
                NavigationDestination(icon: Icon(Icons.analytics_outlined), selectedIcon: Icon(Icons.analytics), label: 'Analytics'),
                NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _selectedIndex == 0
          ? Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(colors: [Color(0xFF0D9488), Color(0xFF06B6D4)]),
          boxShadow: [BoxShadow(color: const Color(0xFF0D9488).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const PatientFormScreen()));
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: const Icon(Icons.add),
          label: const Text('New Patient'),
        ),
      )
          : null,
    );
  }
}