import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Services
import 'services/supabase_service.dart';
import 'services/update_service.dart';
import 'services/update_dialog.dart';

// Screens
import 'screens/auth/login_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';

// Widgets
import 'widgets/glass_container.dart';

// Initialize Supabase
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // IMPORTANT: Replace with your Supabase URL and Anon Key
  await Supabase.initialize(
    url: 'https://uqricirhkehgvwoldgai.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVxcmljaXJoa2VoZ3Z3b2xkZ2FpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjYwMjA5MzIsImV4cCI6MjA4MTU5NjkzMn0.7HYAMappgqndhPYF_Q9268gNcKvsOx4GHvgCt634q2A',
  );

  // Initialize Google Fonts
  await GoogleFonts.pendingFonts();

  runApp(const MedicalPatientApp());
}

class MedicalPatientApp extends StatefulWidget {
  const MedicalPatientApp({Key? key}) : super(key: key);

  @override
  State<MedicalPatientApp> createState() => _MedicalPatientAppState();
}

class _MedicalPatientAppState extends State<MedicalPatientApp> {
  // This key is used to access the navigator from the UpdateService
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    // Check for updates when the app starts
    _checkForUpdates();
  }

  Future<void> _checkForUpdates() async {
    final updateService = UpdateService();
    final updateInfo = await updateService.checkForUpdates();

    if (updateInfo != null) {
      bool isForced = updateInfo['is_forced'] ?? false;

      // Use addPostFrameCallback to ensure the context is available
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: navigatorKey.currentContext!,
          barrierDismissible: !isForced, // Cannot dismiss if it's a forced update
          builder: (context) => UpdateDialog(
            updateInfo: updateInfo,
            isForced: isForced,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Medical Patient System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF0F4F8),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF1A365D),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      home: const AuthGate(),
    );
  }
}

// Auth Gate
class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.session != null) {
          return const DashboardScreen();
        }
        return const LoginScreen();
      },
    );
  }
}