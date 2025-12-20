import 'package:flutter/material.dart';
import 'package:medical_patient_app/services/update_service.dart';
import 'package:medical_patient_app/widgets/glass_container.dart';

class UpdateDialog extends StatefulWidget {
  final Map<String, dynamic> updateInfo;
  final bool isForced;

  const UpdateDialog({
    Key? key,
    required this.updateInfo,
    this.isForced = false,
  }) : super(key: key);

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  bool _isDownloading = false;
  double _downloadProgress = 0.0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !widget.isForced, // Prevent closing if it's a forced update
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: GlassContainer(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.system_update, color: Theme.of(context).primaryColor, size: 28),
                  const SizedBox(width: 12),
                  const Text('App Update Available', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Version ${widget.updateInfo['version']} is now available!',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                widget.updateInfo['release_notes'] ?? 'Bug fixes and performance improvements.',
                style: TextStyle(color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              if (_isDownloading)
                Column(
                  children: [
                    LinearProgressIndicator(value: _downloadProgress, backgroundColor: Colors.grey[300]),
                    const SizedBox(height: 10),
                    Text('Downloading: ${(_downloadProgress * 100).toInt()}%'),
                  ],
                ),
              if (!_isDownloading) ...[
                if (!widget.isForced)
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Later', style: TextStyle(color: Colors.grey)),
                    ),
                  ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _downloadUpdate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Update Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  void _downloadUpdate() async {
    setState(() => _isDownloading = true);
    // Simulate progress for a better UX
    for(int i = 0; i <= 100; i+=5) {
      await Future.delayed(const Duration(milliseconds: 100));
      if(mounted) {
        setState(() {
          _downloadProgress = i / 100.0;
        });
      }
    }

    final updateService = UpdateService();
    final file = await updateService.downloadUpdate(
      widget.updateInfo['file_id'],
      widget.updateInfo['file_name'],
    );

    if (file != null) {
      await updateService.installUpdate(file);
    } else {
      // Fallback to opening the Google Drive link
      await updateService.openUpdatePage(widget.updateInfo['file_id']);
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}