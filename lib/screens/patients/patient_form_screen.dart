import 'package:flutter/material.dart';
import 'package:medical_patient_app/services/supabase_service.dart';
import 'package:medical_patient_app/widgets/glass_container.dart';

class PatientFormScreen extends StatefulWidget {
  final Map<String, dynamic>? patient;

  const PatientFormScreen({Key? key, this.patient}) : super(key: key);

  @override
  State<PatientFormScreen> createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends State<PatientFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // A. Patient Demographics
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _addressController = TextEditingController();
  String _sex = 'Male';

  // B. Symptoms / History
  String _nyha = 'I';
  String _ccs = 'I';
  bool _sob = false;
  bool _chestPain = false;
  bool _palpitations = false;
  bool _dyspnea = false;
  bool _orthopnea = false;
  bool _pnd = false;

  // C. Diagnosis / Left Heart
  bool _stemi = false;
  bool _acs = false;
  bool _nstemi = false;
  bool _ccsD = false;
  bool _arrhythmia = false;

  // D. Comorbidities
  bool _dm = false;
  bool _ht = false;
  bool _dl = false;
  bool _ba = false;
  bool _copd = false;
  bool _cva = false;
  bool _pvd = false;
  bool _rheumaticFever = false;
  final _otherComorbidityController = TextEditingController();

  // E. Investigations
  final _lmcaController = TextEditingController();
  final _ladController = TextEditingController();
  final _lcxController = TextEditingController();
  final _rcaController = TextEditingController();
  final _efController = TextEditingController();
  String _echoFindings = 'Trivial';
  bool _tee = false;
  bool _tse = false;
  bool _ctca = false;
  bool _ctAngio = false;
  bool _cmr = false;
  bool _mrValve = false;
  bool _arValve = false;
  bool _trValve = false;
  bool _pvValve = false;
  final _otherEcgController = TextEditingController();

  // F. Examination
  final _bpController = TextEditingController();
  final _prController = TextEditingController();
  bool _oedema = false;
  String _handed = 'Right';
  final _allenTestController = TextEditingController();
  final _painNotesController = TextEditingController();

  // G. Diagnosis
  bool _ca = false;
  final _otherDiagnosisController = TextEditingController();

  // H. Plan
  bool _planCA = false;
  bool _planCMR = false;
  bool _planEcho = false;
  bool _planCarotidDuplex = false;
  bool _planMASA = false;
  final _otherPlanController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.patient != null) {
      _loadPatientData();
    }
  }

  void _loadPatientData() {
    final p = widget.patient!;
    _nameController.text = p['name'] ?? '';
    _ageController.text = p['age']?.toString() ?? '';
    _addressController.text = p['address'] ?? '';
    _sex = p['sex'] ?? 'Male';
    _nyha = p['nyha'] ?? 'I';
    _ccs = p['ccs'] ?? 'I';
    _sob = p['sob'] ?? false;
    _chestPain = p['chest_pain'] ?? false;
    _palpitations = p['palpitations'] ?? false;
    _dyspnea = p['dyspnea'] ?? false;
    _orthopnea = p['orthopnea'] ?? false;
    _pnd = p['pnd'] ?? false;
    _stemi = p['stemi'] ?? false;
    _acs = p['acs'] ?? false;
    _nstemi = p['nstemi'] ?? false;
    _ccsD = p['ccs_d'] ?? false;
    _arrhythmia = p['arrhythmia'] ?? false;
    _dm = p['dm'] ?? false;
    _ht = p['ht'] ?? false;
    _dl = p['dl'] ?? false;
    _ba = p['ba'] ?? false;
    _copd = p['copd'] ?? false;
    _cva = p['cva'] ?? false;
    _pvd = p['pvd'] ?? false;
    _rheumaticFever = p['rheumatic_fever'] ?? false;
    _otherComorbidityController.text = p['other_comorbidity'] ?? '';
    _lmcaController.text = p['lmca'] ?? '';
    _ladController.text = p['lad'] ?? '';
    _lcxController.text = p['lcx'] ?? '';
    _rcaController.text = p['rca'] ?? '';
    _efController.text = p['ef']?.toString() ?? '';
    _echoFindings = p['echo_findings'] ?? 'Trivial';
    _tee = p['tee'] ?? false;
    _tse = p['tse'] ?? false;
    _ctca = p['ctca'] ?? false;
    _ctAngio = p['ct_angio'] ?? false;
    _cmr = p['cmr'] ?? false;
    _mrValve = p['mr_valve'] ?? false;
    _arValve = p['ar_valve'] ?? false;
    _trValve = p['tr_valve'] ?? false;
    _pvValve = p['pv_valve'] ?? false;
    _otherEcgController.text = p['other_ecg'] ?? '';
    _bpController.text = p['bp'] ?? '';
    _prController.text = p['pr'] ?? '';
    _oedema = p['oedema'] ?? false;
    _handed = p['handed'] ?? 'Right';
    _allenTestController.text = p['allen_test'] ?? '';
    _painNotesController.text = p['pain_notes'] ?? '';
    _ca = p['ca'] ?? false;
    _otherDiagnosisController.text = p['other_diagnosis'] ?? '';
    _planCA = p['plan_ca'] ?? false;
    _planCMR = p['plan_cmr'] ?? false;
    _planEcho = p['plan_echo'] ?? false;
    _planCarotidDuplex = p['plan_carotid_duplex'] ?? false;
    _planMASA = p['plan_masa'] ?? false;
    _otherPlanController.text = p['other_plan'] ?? '';
  }

  Future<void> _savePatient() async {
    if (!_formKey.currentState!.validate()) return;

    final patientData = {
      'name': _nameController.text,
      'age': int.tryParse(_ageController.text) ?? 0,
      'sex': _sex,
      'address': _addressController.text,
      'nyha': _nyha,
      'ccs': _ccs,
      'sob': _sob,
      'chest_pain': _chestPain,
      'palpitations': _palpitations,
      'dyspnea': _dyspnea,
      'orthopnea': _orthopnea,
      'pnd': _pnd,
      'stemi': _stemi,
      'acs': _acs,
      'nstemi': _nstemi,
      'ccs_d': _ccsD,
      'arrhythmia': _arrhythmia,
      'dm': _dm,
      'ht': _ht,
      'dl': _dl,
      'ba': _ba,
      'copd': _copd,
      'cva': _cva,
      'pvd': _pvd,
      'rheumatic_fever': _rheumaticFever,
      'other_comorbidity': _otherComorbidityController.text,
      'lmca': _lmcaController.text,
      'lad': _ladController.text,
      'lcx': _lcxController.text,
      'rca': _rcaController.text,
      'ef': int.tryParse(_efController.text),
      'echo_findings': _echoFindings,
      'tee': _tee,
      'tse': _tse,
      'ctca': _ctca,
      'ct_angio': _ctAngio,
      'cmr': _cmr,
      'mr_valve': _mrValve,
      'ar_valve': _arValve,
      'tr_valve': _trValve,
      'pv_valve': _pvValve,
      'other_ecg': _otherEcgController.text,
      'bp': _bpController.text,
      'pr': _prController.text,
      'oedema': _oedema,
      'handed': _handed,
      'allen_test': _allenTestController.text,
      'pain_notes': _painNotesController.text,
      'ca': _ca,
      'other_diagnosis': _otherDiagnosisController.text,
      'plan_ca': _planCA,
      'plan_cmr': _planCMR,
      'plan_echo': _planEcho,
      'plan_carotid_duplex': _planCarotidDuplex,
      'plan_masa': _planMASA,
      'other_plan': _otherPlanController.text,
      'user_id': supabase.auth.currentUser!.id,
    };

    try {
      if (widget.patient == null) {
        await supabase.from('patients').insert(patientData);
      } else {
        await supabase.from('patients').update(patientData).eq('id', widget.patient!['id']);
      }
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Patient saved successfully'),
          backgroundColor: Color(0xFF0D9488),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.patient == null ? 'New Patient' : 'Edit Patient'),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D9488), Color(0xFF06B6D4)],
                ),
              ),
              child: const Icon(Icons.save, size: 20),
            ),
            onPressed: _savePatient,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0D9488).withOpacity(0.1),
              const Color(0xFF06B6D4).withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // A. Patient Demographics
                _buildSection(
                  'A. Patient Demographics',
                  Icons.person_outline,
                  [
                    _buildGlassTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      icon: Icons.badge_outlined,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildGlassTextField(
                            controller: _ageController,
                            label: 'Age',
                            icon: Icons.calendar_today_outlined,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GlassContainer(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: DropdownButtonFormField<String>(
                              value: _sex,
                              decoration: const InputDecoration(
                                labelText: 'Sex',
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.wc_outlined),
                              ),
                              items: ['Male', 'Female', 'Other']
                                  .map((e) => DropdownMenuItem(
                                  value: e, child: Text(e)))
                                  .toList(),
                              onChanged: (v) => setState(() => _sex = v!),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildGlassTextField(
                      controller: _addressController,
                      label: 'Address',
                      icon: Icons.location_on_outlined,
                      maxLines: 2,
                    ),
                  ],
                ),

                // B. Symptoms / History
                _buildSection(
                  'B. Symptoms / History (H/O)',
                  Icons.favorite_outline,
                  [
                    _buildGlassCheckbox('SOB (Shortness of Breath)', _sob,
                            (v) => setState(() => _sob = v!)),
                    _buildGlassCheckbox('Chest Pain', _chestPain,
                            (v) => setState(() => _chestPain = v!)),
                    _buildGlassCheckbox('Palpitations', _palpitations,
                            (v) => setState(() => _palpitations = v!)),
                    _buildGlassCheckbox('Dyspnea / Dizziness', _dyspnea,
                            (v) => setState(() => _dyspnea = v!)),
                    _buildGlassCheckbox('Orthopnea', _orthopnea,
                            (v) => setState(() => _orthopnea = v!)),
                    _buildGlassCheckbox('PND (Paroxysmal Nocturnal Dyspnea)', _pnd,
                            (v) => setState(() => _pnd = v!)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: GlassContainer(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: DropdownButtonFormField<String>(
                              value: _nyha,
                              decoration: const InputDecoration(
                                labelText: 'NYHA Class',
                                border: InputBorder.none,
                              ),
                              items: ['I', 'II', 'III', 'IV']
                                  .map((e) => DropdownMenuItem(
                                  value: e, child: Text('NYHA $e')))
                                  .toList(),
                              onChanged: (v) => setState(() => _nyha = v!),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GlassContainer(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: DropdownButtonFormField<String>(
                              value: _ccs,
                              decoration: const InputDecoration(
                                labelText: 'CCS Class',
                                border: InputBorder.none,
                              ),
                              items: ['I', 'II', 'III', 'IV']
                                  .map((e) => DropdownMenuItem(
                                  value: e, child: Text('CCS $e')))
                                  .toList(),
                              onChanged: (v) => setState(() => _ccs = v!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // C. Diagnosis / Left Heart
                _buildSection(
                  'C. Diagnosis / Left Heart (L/H)',
                  Icons.monitor_heart_outlined,
                  [
                    _buildGlassCheckbox('STEMI', _stemi,
                            (v) => setState(() => _stemi = v!)),
                    _buildGlassCheckbox('ACS', _acs,
                            (v) => setState(() => _acs = v!)),
                    _buildGlassCheckbox('NSTEMI', _nstemi,
                            (v) => setState(() => _nstemi = v!)),
                    _buildGlassCheckbox('CCS', _ccsD,
                            (v) => setState(() => _ccsD = v!)),
                    _buildGlassCheckbox('Arrhythmia', _arrhythmia,
                            (v) => setState(() => _arrhythmia = v!)),
                  ],
                ),

                // D. Comorbidities
                _buildSection(
                  'D. Comorbidities',
                  Icons.medical_information_outlined,
                  [
                    _buildGlassCheckbox('DM (Diabetes Mellitus)', _dm,
                            (v) => setState(() => _dm = v!)),
                    _buildGlassCheckbox('HT (Hypertension)', _ht,
                            (v) => setState(() => _ht = v!)),
                    _buildGlassCheckbox('DL (Dyslipidemia)', _dl,
                            (v) => setState(() => _dl = v!)),
                    _buildGlassCheckbox('BA (Bronchial Asthma)', _ba,
                            (v) => setState(() => _ba = v!)),
                    _buildGlassCheckbox('COPD', _copd,
                            (v) => setState(() => _copd = v!)),
                    _buildGlassCheckbox('CVA', _cva,
                            (v) => setState(() => _cva = v!)),
                    _buildGlassCheckbox('PVD', _pvd,
                            (v) => setState(() => _pvd = v!)),
                    _buildGlassCheckbox('Rheumatic Fever', _rheumaticFever,
                            (v) => setState(() => _rheumaticFever = v!)),
                    const SizedBox(height: 8),
                    _buildGlassTextField(
                      controller: _otherComorbidityController,
                      label: 'Other Comorbidities',
                      icon: Icons.add_circle_outline,
                      required: false,
                    ),
                  ],
                ),

                // E. Investigations
                _buildSection(
                  'E. Investigations',
                  Icons.science_outlined,
                  [
                    Text('1. Coronary Angiography (CA)',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    const SizedBox(height: 12),
                    _buildGlassTextField(
                      controller: _lmcaController,
                      label: 'LMCA',
                      icon: Icons.timeline,
                      required: false,
                    ),
                    const SizedBox(height: 12),
                    _buildGlassTextField(
                      controller: _ladController,
                      label: 'LAD',
                      icon: Icons.timeline,
                      required: false,
                    ),
                    const SizedBox(height: 12),
                    _buildGlassTextField(
                      controller: _lcxController,
                      label: 'LCX',
                      icon: Icons.timeline,
                      required: false,
                    ),
                    const SizedBox(height: 12),
                    _buildGlassTextField(
                      controller: _rcaController,
                      label: 'RCA',
                      icon: Icons.timeline,
                      required: false,
                    ),
                    const SizedBox(height: 20),
                    Text('2. Echocardiography',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildGlassTextField(
                            controller: _efController,
                            label: 'EF (%)',
                            icon: Icons.percent,
                            keyboardType: TextInputType.number,
                            required: false,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GlassContainer(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: DropdownButtonFormField<String>(
                              value: _echoFindings,
                              decoration: const InputDecoration(
                                labelText: 'Findings',
                                border: InputBorder.none,
                              ),
                              items: ['Trivial', 'Trace', 'Mild', 'Moderate', 'Severe']
                                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                  .toList(),
                              onChanged: (v) => setState(() => _echoFindings = v!),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildGlassCheckbox('TEE', _tee,
                                  (v) => setState(() => _tee = v!)),
                        ),
                        Expanded(
                          child: _buildGlassCheckbox('TSE', _tse,
                                  (v) => setState(() => _tse = v!)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text('3. Additional Imaging',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildGlassCheckbox('CTCA', _ctca,
                                  (v) => setState(() => _ctca = v!)),
                        ),
                        Expanded(
                          child: _buildGlassCheckbox('CT Angio', _ctAngio,
                                  (v) => setState(() => _ctAngio = v!)),
                        ),
                        Expanded(
                          child: _buildGlassCheckbox('CMR', _cmr,
                                  (v) => setState(() => _cmr = v!)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text('4. ECG Findings - Valves',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildGlassCheckbox('MR', _mrValve,
                                  (v) => setState(() => _mrValve = v!)),
                        ),
                        Expanded(
                          child: _buildGlassCheckbox('AR', _arValve,
                                  (v) => setState(() => _arValve = v!)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildGlassCheckbox('TR', _trValve,
                                  (v) => setState(() => _trValve = v!)),
                        ),
                        Expanded(
                          child: _buildGlassCheckbox('PV', _pvValve,
                                  (v) => setState(() => _pvValve = v!)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildGlassTextField(
                      controller: _otherEcgController,
                      label: 'Other ECG Findings',
                      icon: Icons.add_circle_outline,
                      required: false,
                    ),
                  ],
                ),

                // F. Examination
                _buildSection(
                  'F. Examination (Ex/)',
                  Icons.healing_outlined,
                  [
                    Row(
                      children: [
                        Expanded(
                          child: _buildGlassTextField(
                            controller: _bpController,
                            label: 'BP',
                            icon: Icons.monitor_heart,
                            required: false,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildGlassTextField(
                            controller: _prController,
                            label: 'PR (Pulse Rate)',
                            icon: Icons.favorite_border,
                            keyboardType: TextInputType.number,
                            required: false,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildGlassCheckbox('Oedema', _oedema,
                                  (v) => setState(() => _oedema = v!)),
                        ),
                        Expanded(
                          child: GlassContainer(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: DropdownButtonFormField<String>(
                              value: _handed,
                              decoration: const InputDecoration(
                                labelText: 'Handed',
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.back_hand_outlined),
                                contentPadding: EdgeInsets.zero,
                              ),
                              items: ['Right', 'Left']
                                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                  .toList(),
                              onChanged: (v) => setState(() => _handed = v!),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildGlassTextField(
                      controller: _allenTestController,
                      label: 'Allen Test Result',
                      icon: Icons.touch_app_outlined,
                      required: false,
                    ),
                    const SizedBox(height: 12),
                    _buildGlassTextField(
                      controller: _painNotesController,
                      label: 'Pain Area / Comments',
                      icon: Icons.note_outlined,
                      maxLines: 3,
                      required: false,
                    ),
                  ],
                ),

                // G. Diagnosis
                _buildSection(
                  'G. Diagnosis (Dx)',
                  Icons.assignment_outlined,
                  [
                    _buildGlassCheckbox('CA (Coronary Artery Disease)', _ca,
                            (v) => setState(() => _ca = v!)),
                    const SizedBox(height: 8),
                    _buildGlassTextField(
                      controller: _otherDiagnosisController,
                      label: 'Other Diagnosis',
                      icon: Icons.add_circle_outline,
                      maxLines: 2,
                      required: false,
                    ),
                  ],
                ),

                // H. Plan
                _buildSection(
                  'H. Plan',
                  Icons.checklist_outlined,
                  [
                    _buildGlassCheckbox('CA (Coronary Angiography)', _planCA,
                            (v) => setState(() => _planCA = v!)),
                    _buildGlassCheckbox('CMR (Cardiac MRI)', _planCMR,
                            (v) => setState(() => _planCMR = v!)),
                    _buildGlassCheckbox('Echo / TEE', _planEcho,
                            (v) => setState(() => _planEcho = v!)),
                    _buildGlassCheckbox('Carotid Duplex', _planCarotidDuplex,
                            (v) => setState(() => _planCarotidDuplex = v!)),
                    _buildGlassCheckbox('MASA', _planMASA,
                            (v) => setState(() => _planMASA = v!)),
                    const SizedBox(height: 8),
                    _buildGlassTextField(
                      controller: _otherPlanController,
                      label: 'Other Plans',
                      icon: Icons.add_circle_outline,
                      maxLines: 2,
                      required: false,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0D9488), Color(0xFF06B6D4)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0D9488).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _savePatient,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Save Patient',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return GlassContainer(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF0D9488).withOpacity(0.2),
                      const Color(0xFF06B6D4).withOpacity(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: const Color(0xFF0D9488), size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A365D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildGlassTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool required = true,
  }) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF0D9488)),
          border: InputBorder.none,
        ),
        validator: required ? (v) => v?.isEmpty == true ? 'Required' : null : null,
      ),
    );
  }

  Widget _buildGlassCheckbox(String title, bool value, Function(bool?) onChange) {
    return GlassContainer(
      margin: const EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.zero,
      child: CheckboxListTile(
        title: Text(title),
        value: value,
        onChanged: onChange,
        activeColor: const Color(0xFF0D9488),
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }
}