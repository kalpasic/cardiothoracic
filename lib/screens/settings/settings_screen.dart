import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medical_patient_app/services/supabase_service.dart';
import 'package:medical_patient_app/services/update_service.dart';
import 'package:medical_patient_app/services/update_dialog.dart';
import 'package:medical_patient_app/widgets/glass_container.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _autoCheckForUpdates = true;
  bool _wifiOnlyForUpdates = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _autoCheckForUpdates = prefs.getBool('auto_check_updates') ?? true;
      _wifiOnlyForUpdates = prefs.getBool('wifi_only_updates') ?? true;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_check_updates', _autoCheckForUpdates);
    await prefs.setBool('wifi_only_updates', _wifiOnlyForUpdates);
  }

  Future<void> _checkForUpdatesManually() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final updateService = UpdateService();
    final updateInfo = await updateService.checkForUpdates();

    Navigator.of(context).pop(); // Close loading

    if (updateInfo != null) {
      showDialog(
        context: context,
        builder: (context) => UpdateDialog(updateInfo: updateInfo),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You are using the latest version of the app.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Update Settings Section
        GlassContainer(
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.system_update, color: Colors.teal[700]),
                    const SizedBox(width: 10),
                    Text('App Updates', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal[700])),
                  ],
                ),
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text('Auto-check for updates'),
                subtitle: const Text('Automatically check for new versions'),
                value: _autoCheckForUpdates,
                onChanged: (value) {
                  setState(() {
                    _autoCheckForUpdates = value;
                  });
                  _saveSettings();
                },
                activeColor: Colors.teal[700],
              ),
              SwitchListTile(
                title: const Text('Wi-Fi only for downloads'),
                subtitle: const Text('Download updates only when on Wi-Fi'),
                value: _wifiOnlyForUpdates,
                onChanged: (value) {
                  setState(() {
                    _wifiOnlyForUpdates = value;
                  });
                  _saveSettings();
                },
                activeColor: Colors.teal[700],
              ),
              ListTile(
                title: const Text('Check for updates now'),
                subtitle: const Text('Manually check for new app version'),
                leading: Icon(Icons.refresh, color: Colors.teal[700]),
                onTap: _checkForUpdatesManually,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        _buildSettingItem(context, Icons.person_outline, 'Profile', 'Manage your account', const Color(0xFF0D9488)),
        _buildSettingItem(context, Icons.notifications_outlined, 'Notifications', 'Configure alerts', const Color(0xFF8B5CF6)),
        _buildSettingItem(context, Icons.security_outlined, 'Privacy & Security', 'Manage your privacy', const Color(0xFF3B82F6)),
        _buildSettingItem(context, Icons.help_outline, 'Help & Support', 'Get assistance', const Color(0xFFF59E0B)),
        const SizedBox(height: 16),
        GlassContainer(
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.logout, color: Colors.red),
            ),
            title: const Text('Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
            onTap: () async {
              await supabase.auth.signOut();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem(BuildContext context, IconData icon, String title, String subtitle, Color color) {
    return GlassContainer(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
        onTap: () {},
      ),
    );
  }
}