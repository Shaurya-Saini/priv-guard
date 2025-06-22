import 'package:flutter/material.dart';

class ScanAnalysisScreen extends StatefulWidget {
  final Map<String, dynamic> mediaItem;

  const ScanAnalysisScreen({Key? key, required this.mediaItem})
      : super(key: key);

  @override
  _ScanAnalysisScreenState createState() => _ScanAnalysisScreenState();
}

class _ScanAnalysisScreenState extends State<ScanAnalysisScreen> {
  bool _isScanning = false;
  Map<String, dynamic>? _analysisResult;

  @override
  void initState() {
    super.initState();
    _startAnalysis();
  }

  void _startAnalysis() {
    setState(() {
      _isScanning = true;
    });

    // Simulate analysis process
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isScanning = false;
        _analysisResult = {
          'riskScore': 75,
          'riskLevel': 'Medium',
          'detectedRisks': [
            'Personal information visible',
            'Location data detected',
            'Faces identified',
          ],
          'suggestions': [
            'Blur faces before posting',
            'Remove location metadata',
            'Check privacy settings',
          ],
        };
      });
    });
  }

  Color _getRiskColor(int score) {
    if (score >= 80) return Colors.red;
    if (score >= 50) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy Analysis',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Media Preview
          Container(
            width: double.infinity,
            height: 200,
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.mediaItem['thumbnail'],
                  size: 64,
                  color: Colors.grey[600],
                ),
                SizedBox(height: 8),
                Text(
                  widget.mediaItem['title'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: _isScanning
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.indigo[600]!),
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Analyzing privacy risks...',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'This may take a few moments',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : _analysisResult != null
                    ? SingleChildScrollView(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Risk Score Card
                            Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Text(
                                      'Privacy Risk Score',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    CircularProgressIndicator(
                                      value:
                                          _analysisResult!['riskScore'] / 100,
                                      strokeWidth: 8,
                                      backgroundColor: Colors.grey[300],
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        _getRiskColor(
                                            _analysisResult!['riskScore']),
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      '${_analysisResult!['riskScore']}/100',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: _getRiskColor(
                                            _analysisResult!['riskScore']),
                                      ),
                                    ),
                                    Text(
                                      '${_analysisResult!['riskLevel']} Risk',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: 20),

                            // Detected Risks
                            Text(
                              'Detected Risks',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 12),
                            ...(_analysisResult!['detectedRisks'] as List).map(
                              (risk) => Card(
                                margin: EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: Icon(
                                    Icons.warning_amber,
                                    color: Colors.orange[600],
                                  ),
                                  title: Text(risk),
                                ),
                              ),
                            ),

                            SizedBox(height: 20),

                            // Suggestions
                            Text(
                              'Privacy Suggestions',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 12),
                            ...(_analysisResult!['suggestions'] as List).map(
                              (suggestion) => Card(
                                margin: EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: Icon(
                                    Icons.lightbulb_outline,
                                    color: Colors.blue[600],
                                  ),
                                  title: Text(suggestion),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Center(
                        child: Text(
                          'Analysis failed. Please try again.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
          ),

          // Footer
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                if (_analysisResult != null)
                  ElevatedButton(
                    onPressed: () {
                      // Post with suggestions applied
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[600],
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      'Apply Suggestions & Post',
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
