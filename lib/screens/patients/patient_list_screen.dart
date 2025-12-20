import 'package:flutter/material.dart';
import 'package:medical_patient_app/services/supabase_service.dart';
import 'package:medical_patient_app/widgets/glass_container.dart';
import 'package:medical_patient_app/screens/patients/patient_form_screen.dart';
import 'package:medical_patient_app/screens/patients/patient_detail_screen.dart';

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({Key? key}) : super(key: key);

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> _patients = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    setState(() => _isLoading = true);
    try {
      final response = await supabase.from('patients').select().order('created_at', ascending: false);
      setState(() {
        _patients = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading patients: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: GlassContainer(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search patients...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
        ),
        Expanded(
          child: _isLoading
              ? Center(child: CircularProgressIndicator(color: const Color(0xFF0D9488)))
              : RefreshIndicator(
            onRefresh: _loadPatients,
            color: const Color(0xFF0D9488),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _patients.length,
              itemBuilder: (context, index) {
                final patient = _patients[index];
                return GlassContainer(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: [const Color(0xFF0D9488).withOpacity(0.8), const Color(0xFF06B6D4).withOpacity(0.8)]),
                      ),
                      child: Center(
                        child: Text(patient['name']?[0]?.toUpperCase() ?? 'P',
                            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    title: Text(patient['name'] ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    subtitle: Text('Age: ${patient['age']} | ${patient['sex']}', style: TextStyle(color: Colors.grey[700])),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PatientDetailScreen(patient: patient)));
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}