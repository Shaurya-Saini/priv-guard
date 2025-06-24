import 'package:flutter/material.dart';

enum MediaType {
  image,
  text,
  video,
}

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
  MediaType? _mediaType;

  @override
  void initState() {
    super.initState();
    _determineMediaType();
    _startAnalysis();
  }

  void _determineMediaType() {
    // Determine media type based on mediaItem properties
    if (widget.mediaItem.containsKey('type')) {
      switch (widget.mediaItem['type'].toString().toLowerCase()) {
        case 'image':
        case 'photo':
          _mediaType = MediaType.image;
          break;
        case 'text':
        case 'post':
          _mediaType = MediaType.text;
          break;
        case 'video':
          _mediaType = MediaType.video;
          break;
        default:
          _mediaType = MediaType.text; // Default fallback
      }
    } else {
      _mediaType = MediaType.text; // Default fallback
    }
  }

  void _startAnalysis() {
    setState(() {
      _isScanning = true;
    });

    switch (_mediaType) {
      case MediaType.image:
        _scanImage();
        break;
      case MediaType.text:
        _scanText();
        break;
      case MediaType.video:
        _handleVideoScanning();
        break;
      default:
        _scanText();
    }
  }

  Future<void> _scanImage() async {
    // TODO: Replace with actual TensorFlow model inference
    // Example: final result = await _imagePrivacyModel.predict(widget.mediaItem['data']);

    // Simulate image analysis
    await Future.delayed(Duration(seconds: 4));

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
  }

  Future<void> _scanText() async {
    // TODO: Replace with actual TensorFlow model inference
    // Example: final result = await _textPrivacyModel.predict(widget.mediaItem['content']);

    // Simulate text analysis
    await Future.delayed(Duration(seconds: 2));

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

  Future<void> _handleVideoScanning() async {
    // Simulate brief loading for consistency
    await Future.delayed(Duration(seconds: 1));

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
  }

  Color _getRiskColor(int? score) {
    if (score == null) return Colors.grey;
    if (score >= 80) return Colors.red;
    if (score >= 50) return Colors.orange;
    return Colors.green;
  }

  IconData _getMediaIcon() {
    switch (_mediaType) {
      case MediaType.image:
        return Icons.image;
      case MediaType.text:
        return Icons.text_fields;
      case MediaType.video:
        return Icons.videocam;
      default:
        return Icons.description;
    }
  }

  String _getAnalysisTitle() {
    switch (_mediaType) {
      case MediaType.image:
        return 'Image Privacy Analysis';
      case MediaType.text:
        return 'Text Privacy Analysis';
      case MediaType.video:
        return 'Video Privacy Analysis';
      default:
        return 'Privacy Analysis';
    }
  }

  Widget _buildRiskScoreCard() {
    if (_analysisResult?['isVideoUnsupported'] == true) {
      return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                Icons.video_library_outlined,
                size: 64,
                color: Colors.grey[600],
              ),
              SizedBox(height: 16),
              Text(
                'Video Analysis',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                _analysisResult!['message'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
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
              value: _analysisResult!['riskScore'] / 100,
              strokeWidth: 8,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                _getRiskColor(_analysisResult!['riskScore']),
              ),
            ),
            SizedBox(height: 16),
            Text(
              '${_analysisResult!['riskScore']}/100',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _getRiskColor(_analysisResult!['riskScore']),
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
    );
  }

  Widget _buildVideoUnsupportedContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRiskScoreCard(),
          SizedBox(height: 20),
          Text(
            'Coming Soon',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          ...(_analysisResult!['supportedFeatures'] as List).map(
            (feature) => Card(
              margin: EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Icon(
                  Icons.schedule,
                  color: Colors.blue[600],
                ),
                title: Text(feature),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisResults() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRiskScoreCard(),
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

          // Technical Details (optional expansion)
          if (_analysisResult!['technicalDetails'] != null) ...[
            SizedBox(height: 20),
            ExpansionTile(
              title: Text(
                'Technical Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              children: [
                ..._analysisResult!['technicalDetails'].entries.map(
                      (entry) => ListTile(
                        title: Text(entry.key),
                        trailing: Text(entry.value.toString()),
                      ),
                    ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getAnalysisTitle(),
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
                  _getMediaIcon(),
                  size: 64,
                  color: Colors.grey[600],
                ),
                SizedBox(height: 8),
                Text(
                  widget.mediaItem['title'] ?? 'Media Content',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  _mediaType.toString().split('.').last.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
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
                          _mediaType == MediaType.image
                              ? 'Processing image content'
                              : _mediaType == MediaType.text
                                  ? 'Analyzing text content'
                                  : 'Checking video compatibility',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : _analysisResult != null
                    ? (_analysisResult!['isVideoUnsupported'] == true
                        ? _buildVideoUnsupportedContent()
                        : _buildAnalysisResults())
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
                if (_analysisResult != null &&
                    _analysisResult!['isVideoUnsupported'] != true)
                  ElevatedButton(
                    onPressed: () {
                      // Post with suggestions applied
                      // TODO: Implement actual privacy suggestions application
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
