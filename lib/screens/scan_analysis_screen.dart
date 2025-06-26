import 'package:flutter/material.dart';
import 'dart:ui';

class ScanAnalysisScreen extends StatefulWidget {
  final Map<String, dynamic> mediaItem;

  const ScanAnalysisScreen({Key? key, required this.mediaItem}) : super(key: key);

  @override
  _ScanAnalysisScreenState createState() => _ScanAnalysisScreenState();
}

class _ScanAnalysisScreenState extends State<ScanAnalysisScreen> {
  bool _isScanning = false;
  Map<String, dynamic>? _analysisResult;
  bool _showRisksTab = true;

  @override
  void initState() {
    super.initState();
    _startAnalysis();
  }

  void _startAnalysis() {
    setState(() { _isScanning = true; });
    // Fake analysis for demo
    Future.delayed(Duration(seconds: 2), () {
      final type = widget.mediaItem['type'] ?? 'text';
      if (type == 'image') {
        setState(() {
          _isScanning = false;
          _analysisResult = {
            'riskScore': 85,
            'riskLevel': 'High',
            'detectedRisks': [
              'Faces detected in image',
              'EXIF location data present',
              'Personal items visible (ID cards, documents)',
              'Background contains identifiable information',
            ],
            'suggestions': [
              'Blur or crop faces before sharing',
              'Remove EXIF metadata',
              'Cover sensitive documents in background',
              'Check for reflective surfaces showing personal info',
            ],
            'technicalDetails': {
              'facesDetected': 2,
              'locationAccuracy': 'High precision GPS',
              'personalItemsCount': 3,
            }
          };
        });
      } else if (type == 'video') {
        setState(() {
          _isScanning = false;
          _analysisResult = {
            'riskScore': null,
            'riskLevel': 'Not Supported',
            'isVideoUnsupported': true,
            'message': 'Scanning videos will be supported in future versions',
            'supportedFeatures': [
              'Audio privacy analysis',
              'Visual content recognition',
              'Automatic face blurring',
              'Location metadata removal',
            ],
          };
        });
      } else {
        setState(() {
          _isScanning = false;
          _analysisResult = {
            'riskScore': 60,
            'riskLevel': 'Medium',
            'detectedRisks': [
              'Phone number mentioned',
              'Workplace information shared',
              'Personal schedule details',
              'Family member names mentioned',
            ],
            'suggestions': [
              'Remove or redact phone numbers',
              'Avoid sharing specific workplace details',
              'Limit sharing of daily routines',
              'Use initials instead of full names',
            ],
            'technicalDetails': {
              'personalDataPoints': 4,
              'sensitiveKeywords': ['phone', 'work', 'schedule'],
              'privacyScore': 6.5,
            }
          };
        });
      }
    });
  }

  Color _getRiskColor(int? score) {
    if (score == null) return Color(0xFF94A3B8);
    if (score >= 80) return Color(0xFFEF4444);
    if (score >= 50) return Color(0xFFF59E0B);
    return Color(0xFF10B981);
  }

  IconData _getMediaIcon() {
    final type = widget.mediaItem['type'];
    if (type == 'image') return Icons.image;
    if (type == 'video') return Icons.videocam;
    return Icons.text_fields;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFF0C7FF2);
    final slate200 = Color(0xFFE2E8F0);
    final slate400 = Color(0xFF94A3B8);
    final slate500 = Color(0xFF64748B);
    final slate600 = Color(0xFF475569);
    final slate700 = Color(0xFF334155);
    final slate800 = Color(0xFF1E293B);
    final slate900 = Color(0xFF0F172A);

    bool isVideoUnsupported = _analysisResult?['isVideoUnsupported'] == true;

    return Scaffold(
      backgroundColor: Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.mediaItem['title'] ?? 'Privacy Analysis',
          style: TextStyle(
            color: slate800,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Media Preview Container - COMPLETELY FIXED FOR IMAGE OVERFLOW
          Container(
            margin: EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User info row with FIXED constraints
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: slate200,
                        child: Icon(_getMediaIcon(), color: slate600),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'User',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: slate800,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '@username',
                              style: TextStyle(
                                fontSize: 12,
                                color: slate500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  
                  // Content text with STRICT constraints - KEY FIX
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        width: constraints.maxWidth, // Use available width
                        child: Text(
                          widget.mediaItem['text'] ?? 
                          widget.mediaItem['title'] ?? 
                          widget.mediaItem['fileName'] ?? 
                          'Media content',
                          style: TextStyle(
                            fontSize: 14,
                            color: slate700,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                      );
                    },
                  ),
                  
                  // Image preview with STRICT constraints - CRITICAL FIX
                  if (widget.mediaItem['type'] == 'image')
                    Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Container(
                            width: constraints.maxWidth, // Use exact available width
                            height: 120, // Fixed height to prevent overflow
                            decoration: BoxDecoration(
                              color: slate200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: widget.mediaItem['encryptedPath'] != null
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.image,
                                            size: 32,
                                            color: slate600,
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'Encrypted Image',
                                            style: TextStyle(
                                              color: slate600,
                                              fontSize: 10,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    )
                                  : Center(
                                      child: Icon(
                                        Icons.image,
                                        size: 32,
                                        color: slate600,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Risk Score Section with proper constraints
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Risk Score',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: slate800,
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: slate200,
                      ),
                      child: Stack(
                        children: [
                          CustomPaint(
                            painter: RiskScorePainter(
                              value: (_analysisResult?['riskScore'] ?? 0) / 100,
                              color: _getRiskColor(_analysisResult?['riskScore']),
                            ),
                            size: Size(120, 120),
                          ),
                          Center(
                            child: Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${_analysisResult?['riskScore'] ?? '--'}',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: _getRiskColor(_analysisResult?['riskScore']),
                                      ),
                                    ),
                                    Text(
                                      _analysisResult?['riskLevel'] ?? 'Unknown',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: slate500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          
          // Tabs Section
          Container(
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _showRisksTab = true),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _showRisksTab ? primaryColor : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Detected Risks',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: _showRisksTab ? primaryColor : slate500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _showRisksTab = false),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: !_showRisksTab ? primaryColor : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Suggestions',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: !_showRisksTab ? primaryColor : slate500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Content Section with FIXED overflow constraints
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_showRisksTab)
                    ..._analysisResult?['detectedRisks']?.map<Widget>((risk) => Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Container(
                                width: constraints.maxWidth, // Use exact available width
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFE0F2FE),
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.warning,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            risk,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: slate800,
                                            ),
                                            maxLines: null,
                                            softWrap: true,
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'Risk identified',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: slate500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )) ??
                        [],
                  if (!_showRisksTab)
                    ..._analysisResult?['suggestions']?.map<Widget>((suggestion) => Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Container(
                                width: constraints.maxWidth, // Use exact available width
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: slate200,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.lightbulb_outline,
                                          color: slate600,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        suggestion,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: slate800,
                                        ),
                                        maxLines: null,
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )) ??
                        [],
                ],
              ),
            ),
          ),
          
          // Bottom Button
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              border: Border(
                top: BorderSide(
                  color: slate200,
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Apply changes
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    'Apply Changes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RiskScorePainter extends CustomPainter {
  final double value;
  final Color color;

  RiskScorePainter({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;
    final startAngle = -0.5 * 3.14159;
    final sweepAngle = 2 * 3.14159 * value;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

