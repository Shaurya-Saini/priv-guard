import 'package:flutter/material.dart';

class SocialMediaScannerScreen extends StatefulWidget {
  @override
  _SocialMediaScannerScreenState createState() =>
      _SocialMediaScannerScreenState();
}

class _SocialMediaScannerScreenState extends State<SocialMediaScannerScreen> {
  final TextEditingController _handleController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _autoScanEnabled = false;
  bool _pushNotificationsEnabled = true;

  @override
  void dispose() {
    _handleController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _startScan() {
    if (_handleController.text.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in both handle and email'),
          backgroundColor: Colors.red[600],
        ),
      );
      return;
    }

    // Start scanning functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Privacy report will be sent to ${_emailController.text}'),
        backgroundColor: Colors.green[600],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Social Media Scanner',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              // Help functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Info
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Icon(
                            Icons.security,
                            size: 48,
                            color: Colors.indigo[600],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Privacy Report Scanner',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Enter your social media handle and email to receive a comprehensive privacy analysis report.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Input Form
                  Text(
                    'Account Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16),

                  TextField(
                    controller: _handleController,
                    decoration: InputDecoration(
                      labelText: 'Social Media Handle',
                      hintText: '@username',
                      prefixIcon: Icon(Icons.alternate_email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.indigo[600]!),
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      hintText: 'your.email@example.com',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.indigo[600]!),
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Settings
                  Text(
                    'Scan Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16),

                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: Text('Auto-scan every 30 days'),
                          subtitle:
                              Text('Automatically rescan your profile monthly'),
                          value: _autoScanEnabled,
                          onChanged: (value) {
                            setState(() {
                              _autoScanEnabled = value;
                            });
                          },
                          activeColor: Colors.indigo[600],
                        ),
                        Divider(height: 1),
                        SwitchListTile(
                          title: Text('Push notifications'),
                          subtitle:
                              Text('Get notified when risk status changes'),
                          value: _pushNotificationsEnabled,
                          onChanged: (value) {
                            setState(() {
                              _pushNotificationsEnabled = value;
                            });
                          },
                          activeColor: Colors.indigo[600],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // Previous Scans
                  Text(
                    'Recent Scans',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16),

                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green[100],
                        child: Icon(
                          Icons.check,
                          color: Colors.green[600],
                        ),
                      ),
                      title: Text('Last scan completed'),
                      subtitle: Text('No previous scans found'),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // View previous scan details
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Footer with Scan Button
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _startScan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo[600],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    'Start Privacy Scan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '© 2024 PrivGuard - Your Privacy Guardian',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
