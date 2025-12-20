import 'package:flutter/material.dart';
import 'package:medical_patient_app/widgets/glass_container.dart';

class AnalyticsDashboard extends StatelessWidget {
  const AnalyticsDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildStatCard('Total Patients', '156', Icons.people_outline, const Color(0xFF0D9488), const Color(0xFF06B6D4)),
        _buildStatCard('This Month', '24', Icons.calendar_today_outlined, const Color(0xFF8B5CF6), const Color(0xFFC084FC)),
        _buildStatCard('Critical Cases', '8', Icons.warning_amber_outlined, const Color(0xFFF59E0B), const Color(0xFFFBBF24)),
        _buildStatCard('Completed', '132', Icons.check_circle_outline, const Color(0xFF10B981), const Color(0xFF34D399)),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color1, Color color2) {
    return GlassContainer(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color1, color2]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: color1.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
            ),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1A365D))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}