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

  // Enhanced regex patterns with improved name detection
  final Map<String, RegExp> _personalDataPatterns = {
    // Indian Documents (Check these FIRST to avoid misidentification)
    'Aadhaar Number': RegExp(r'\b[2-9]\d{3}\s?\d{4}\s?\d{4}\b'),
    'PAN Card': RegExp(r'\b[A-Z]{5}\d{4}[A-Z]\b'),
    'Driving License': RegExp(r'\b[A-Z]{2}\d{2}\s?\d{11}\b'),
    'Passport Number': RegExp(r'\b[A-Z]\d{7}\b'),
    
    // Enhanced Name Detection with better filtering
    'Name': RegExp(r'(?:Mr\.?\s+|Ms\.?\s+|Mrs\.?\s+|Dr\.?\s+|Prof\.?\s+)?[A-Z][a-z]{2,}(?:\s[A-Z][a-z]{2,}){1,3}(?!\s*(?:Street|St|Avenue|Ave|Road|Rd|Drive|Dr|Lane|Ln|Boulevard|Blvd|Company|Corp|Ltd|Inc|LLC|University|College|School))', caseSensitive: false),
    
    // Other sensitive data
    'Email': RegExp(r'\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\b'),
    'Phone': RegExp(r'\b(?:\+91[\s-]?)?[6-9]\d{9}\b|\b(?:\+\d{1,3}[\s-]?)?\(?\d{3}\)?[\s-]?\d{3}[\s-]?\d{4}\b'),
    'SSN': RegExp(r'\b\d{3}-\d{2}-\d{4}\b'),
    'Credit Card': RegExp(r'\b(?:\d{4}[\s-]?){3}\d{4}\b'),
    'Date': RegExp(r'\b\d{1,2}[/-]\d{1,2}[/-]\d{2,4}\b'),
    'Address': RegExp(r'\d+\s+[A-Za-z\s]+(?:Street|St|Avenue|Ave|Road|Rd|Drive|Dr|Lane|Ln|Boulevard|Blvd)\b', caseSensitive: false),
    'IP Address': RegExp(r'\b(?:\d{1,3}\.){3}\d{1,3}\b'),
  };

  @override
  void initState() {
    super.initState();
    _startAnalysis();
  }

  // Enhanced name filtering to reduce false positives
  List<String> _filterValidNames(List<String> potentialNames, String fullText) {
    List<String> validNames = [];
    
    // Common words that are NOT names
    Set<String> excludeWords = {
      'The', 'This', 'That', 'These', 'Those', 'When', 'Where', 'What', 'Who', 'Why', 'How',
      'First', 'Last', 'Next', 'Previous', 'New', 'Old', 'Good', 'Bad', 'Best', 'Worst',
      'Company', 'Corporation', 'Limited', 'Private', 'Public', 'Government', 'Department',
      'Street', 'Avenue', 'Road', 'Drive', 'Lane', 'Boulevard', 'City', 'State', 'Country',
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
      'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December',
      'Welcome', 'Contact', 'Support', 'Help', 'Service', 'Team', 'Group', 'Office', 'Center',
      'Main', 'Central', 'North', 'South', 'East', 'West', 'Upper', 'Lower', 'High', 'Low'
    };
    
    for (String name in potentialNames) {
      String trimmedName = name.trim();
      
      // Skip if it's a common non-name word
      String firstWord = trimmedName.split(' ').first;
      if (excludeWords.contains(firstWord)) continue;
      
      // Skip if it's part of an address or organization
      if (RegExp(r'\b(?:Street|St|Avenue|Ave|Road|Rd|Drive|Dr|Lane|Ln|Boulevard|Blvd|Company|Corp|Ltd|Inc|LLC|University|College|School)\b', caseSensitive: false).hasMatch(trimmedName)) continue;
      
      // Skip if it's all caps (likely acronym or abbreviation)
      if (trimmedName == trimmedName.toUpperCase() && trimmedName.length > 3) continue;
      
      // Skip single words (names usually have first + last)
      if (!trimmedName.contains(' ')) continue;
      
      // Skip if it contains numbers
      if (RegExp(r'\d').hasMatch(trimmedName)) continue;
      
      // Skip if it's too short or too long
      if (trimmedName.length < 4 || trimmedName.length > 50) continue;
      
      // Skip if it contains special characters (except spaces and periods)
      if (RegExp(r'[^a-zA-Z\s\.]').hasMatch(trimmedName)) continue;
      
      validNames.add(trimmedName);
    }
    
    return validNames;
  }

  // IMPROVED: Better detection logic that preserves ALL risks
  Map<String, List<String>> _detectPersonalData(String text) {
    Map<String, List<String>> detectedData = {};
    Set<String> processedMatches = Set<String>();
    
    print('Analyzing text: $text'); // Debug log
    
    // Process in priority order but KEEP ALL MATCHES
    List<String> priorityOrder = [
      'Aadhaar Number',
      'PAN Card', 
      'Driving License',
      'Passport Number',
      'Email',
      'Phone',
      'SSN',
      'Credit Card',
      'Name',
      'Date',
      'Address',
      'IP Address',
    ];
    
    for (String type in priorityOrder) {
      if (_personalDataPatterns.containsKey(type)) {
        RegExp pattern = _personalDataPatterns[type]!;
        List<String> matches = [];
        
        for (RegExpMatch match in pattern.allMatches(text)) {
          String matchedText = match.group(0)!;
          
          // Special handling for names
          if (type == 'Name') {
            List<String> potentialNames = [matchedText];
            List<String> validNames = _filterValidNames(potentialNames, text);
            
            for (String validName in validNames) {
              // Check if this name overlaps with already processed data
              bool alreadyProcessed = false;
              for (String processed in processedMatches) {
                if (processed.contains(validName) || validName.contains(processed)) {
                  alreadyProcessed = true;
                  break;
                }
              }
              
              if (!alreadyProcessed) {
                matches.add(validName);
                processedMatches.add(validName);
              }
            }
          } else {
            // For non-names, check overlap with higher priority items
            bool alreadyProcessed = false;
            for (String processed in processedMatches) {
              if (processed.contains(matchedText) || matchedText.contains(processed)) {
                alreadyProcessed = true;
                break;
              }
            }
            
            if (!alreadyProcessed) {
              matches.add(matchedText);
              processedMatches.add(matchedText);
            }
          }
        }
        
        // Remove duplicates and store ALL matches
        matches = matches.toSet().toList();
        detectedData[type] = matches;
        
        if (matches.isNotEmpty) {
          print('Found $type: $matches'); // Debug log
        }
      }
    }
    
    return detectedData;
  }

  // ENHANCED: Better risk assessment that handles multiple risks properly
  Map<String, dynamic> _generateRiskAssessment(Map<String, List<String>> detectedData) {
    List<String> risks = [];
    List<String> suggestions = [];
    int riskScore = 0;
    
    // Process ALL detected data types
    detectedData.forEach((type, matches) {
      if (matches.isNotEmpty) {
        switch (type) {
          case 'Aadhaar Number':
            riskScore += 50; // Highest risk
            risks.add('🚨 Aadhaar numbers detected (${matches.length} found)');
            suggestions.add('CRITICAL: Remove Aadhaar numbers immediately - highest privacy risk in India');
            break;
          case 'PAN Card':
            riskScore += 45;
            risks.add('🔴 PAN card numbers detected (${matches.length} found)');
            suggestions.add('HIGH RISK: Remove PAN card information - critical for financial security');
            break;
          case 'Driving License':
            riskScore += 40;
            risks.add('⚠ Driving license numbers detected (${matches.length} found)');
            suggestions.add('Remove driving license numbers to prevent identity theft');
            break;
          case 'Passport Number':
            riskScore += 45;
            risks.add('🔴 Passport numbers detected (${matches.length} found)');
            suggestions.add('Remove passport numbers - critical for identity security');
            break;
          case 'Email':
            riskScore += 20;
            risks.add('📧 Email addresses detected (${matches.length} found)');
            suggestions.add('Remove or redact email addresses before sharing');
            break;
          case 'Phone':
            riskScore += 25;
            risks.add('📱 Phone numbers detected (${matches.length} found)');
            suggestions.add('Remove or mask phone numbers to protect contact privacy');
            break;
          case 'SSN':
            riskScore += 45;
            risks.add('🚨 Social Security Numbers detected (${matches.length} found)');
            suggestions.add('Immediately remove SSN data - high privacy risk');
            break;
          case 'Credit Card':
            riskScore += 40;
            risks.add('💳 Credit card numbers detected (${matches.length} found)');
            suggestions.add('Remove credit card information immediately');
            break;
          case 'Name':
            riskScore += 15;
            risks.add('👤 Personal names detected (${matches.length} found)');
            suggestions.add('Consider using initials instead of full names');
            break;
          case 'Date':
            riskScore += 10;
            risks.add('📅 Date information detected (${matches.length} found)');
            suggestions.add('Review if dates reveal sensitive information');
            break;
          case 'Address':
            riskScore += 30;
            risks.add('🏠 Physical addresses detected (${matches.length} found)');
            suggestions.add('Remove or generalize location information');
            break;
          case 'IP Address':
            riskScore += 20;
            risks.add('🌐 IP addresses detected (${matches.length} found)');
            suggestions.add('Remove IP addresses to prevent location tracking');
            break;
        }
      }
    });

    // Cap risk score at 100
    riskScore = riskScore > 100 ? 100 : riskScore;
    
    String riskLevel = _calculateRiskLevel(riskScore);

    return {
      'riskScore': riskScore,
      'riskLevel': riskLevel,
      'detectedRisks': risks.isEmpty ? ['No personal data patterns detected'] : risks,
      'suggestions': suggestions.isEmpty ? ['✅ Content appears safe to share'] : suggestions,
      'detectedData': detectedData,
    };
  }

  String _calculateRiskLevel(int score) {
    if (score >= 80) return 'Critical';
    if (score >= 60) return 'High';
    if (score >= 40) return 'Medium';
    if (score >= 20) return 'Low';
    return 'Minimal';
  }

  void _startAnalysis() {
    setState(() { _isScanning = true; });
    
    Future.delayed(Duration(seconds: 2), () {
      final type = widget.mediaItem['type'] ?? 'text';
      final content = widget.mediaItem['text'] ?? 
                     widget.mediaItem['title'] ?? 
                     widget.mediaItem['fileName'] ?? 
                     '';

      if (type == 'video') {
        setState(() {
          _isScanning = false;
          _analysisResult = {
            'riskScore': null,
            'riskLevel': 'Not Supported',
            'isVideoUnsupported': true,
            'message': 'Video scanning will be supported in future versions',
            'supportedFeatures': [
              'Audio privacy analysis',
              'Visual content recognition',
              'Automatic face blurring',
              'Location metadata removal',
            ],
          };
        });
      } else {
        // Perform regex-based analysis for text and image content
        Map<String, List<String>> detectedData = _detectPersonalData(content);
        Map<String, dynamic> riskAssessment = _generateRiskAssessment(detectedData);
        
        setState(() {
          _isScanning = false;
          _analysisResult = riskAssessment;
        });
      }
    });
  }

  Color _getRiskColor(int? score) {
    if (score == null) return Color(0xFF94A3B8);
    if (score >= 80) return Color(0xFFDC2626); // Critical - Dark Red
    if (score >= 60) return Color(0xFFEF4444); // High - Red
    if (score >= 40) return Color(0xFFF59E0B); // Medium - Orange
    if (score >= 20) return Color(0xFF10B981); // Low - Green
    return Color(0xFF06B6D4); // Minimal - Cyan
  }

  IconData _getMediaIcon() {
    final type = widget.mediaItem['type'];
    if (type == 'image') return Icons.image;
    if (type == 'video') return Icons.videocam;
    return Icons.text_fields;
  }

  // ENHANCED: Better visual indicators for different document types
  Widget _buildDetectedDataWidget() {
    if (_analysisResult?['detectedData'] == null) return SizedBox.shrink();
    
    Map<String, List<String>> detectedData = _analysisResult!['detectedData'];
    List<Widget> dataWidgets = [];
    
    detectedData.forEach((type, matches) {
      if (matches.isNotEmpty) {
        // Determine severity color and icon based on document type
        Color severityColor;
        Color backgroundColor;
        IconData severityIcon;
        String severityLabel = '';
        
        if (['Aadhaar Number'].contains(type)) {
          severityColor = Color(0xFFDC2626); // Critical - Dark Red
          backgroundColor = Color(0xFFFEE2E2);
          severityIcon = Icons.error;
          severityLabel = 'CRITICAL';
        } else if (['PAN Card', 'Passport Number', 'SSN'].contains(type)) {
          severityColor = Color(0xFFEF4444); // High - Red
          backgroundColor = Color(0xFFFEF2F2);
          severityIcon = Icons.warning;
          severityLabel = 'HIGH RISK';
        } else if (['Driving License', 'Credit Card'].contains(type)) {
          severityColor = Color(0xFFF59E0B); // Medium - Orange
          backgroundColor = Color(0xFFFEF3C7);
          severityIcon = Icons.warning_amber;
          severityLabel = 'MEDIUM';
        } else {
          severityColor = Color(0xFF10B981); // Low - Green
          backgroundColor = Color(0xFFECFDF5);
          severityIcon = Icons.info;
          severityLabel = 'LOW';
        }
        
        dataWidgets.add(
          Container(
            margin: EdgeInsets.only(bottom: 8),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: severityColor, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(severityIcon, color: severityColor, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '$type Found:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: severityColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (severityLabel.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: severityColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          severityLabel,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: matches.map((match) => Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: severityColor, width: 0.5),
                    ),
                    child: Text(
                      _maskSensitiveData(match, type),
                      style: TextStyle(
                        fontSize: 12,
                        color: severityColor,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
        );
      }
    });
    
    if (dataWidgets.isEmpty) {
      return Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFFECFDF5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Color(0xFF10B981), width: 1),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Color(0xFF10B981), size: 16),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'No personal data patterns detected',
                style: TextStyle(
                  color: Color(0xFF065F46),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detected Personal Data:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
        ),
        SizedBox(height: 8),
        ...dataWidgets,
      ],
    );
  }

  // IMPROVED: Better masking for different data types
  String _maskSensitiveData(String data, String type) {
    switch (type) {
      case 'Aadhaar Number':
        // Remove spaces and mask middle digits
        String cleaned = data.replaceAll(' ', '');
        if (cleaned.length >= 8) {
          return '${cleaned.substring(0, 4)} **** ${cleaned.substring(cleaned.length - 4)}';
        }
        break;
      case 'PAN Card':
        if (data.length >= 6) {
          return '${data.substring(0, 3)}*${data.substring(data.length - 2)}';
        }
        break;
      case 'Credit Card':
        String cleaned = data.replaceAll(RegExp(r'[\s-]'), '');
        if (cleaned.length >= 8) {
          return '---${cleaned.substring(cleaned.length - 4)}';
        }
        break;
      case 'Phone':
        String cleaned = data.replaceAll(RegExp(r'[\s()-]'), '');
        if (cleaned.length >= 6) {
          return '--${cleaned.substring(cleaned.length - 4)}';
        }
        break;
      case 'Email':
        int atIndex = data.indexOf('@');
        if (atIndex > 2) {
          return '${data.substring(0, 2)}*${data.substring(atIndex)}';
        }
        break;
      case 'Driving License':
        if (data.length >= 6) {
          return '${data.substring(0, 4)}${data.substring(data.length - 4)}';
        }
        break;
      case 'Passport Number':
        if (data.length >= 4) {
          return '${data.substring(0, 2)}*${data.substring(data.length - 2)}';
        }
        break;
      case 'Name':
        // For names, show first name and mask last name
        List<String> parts = data.split(' ');
        if (parts.length >= 2) {
          return '${parts[0]} ${parts[1].substring(0, 1)}*';
        }
        break;
    }
    return data; // Return original if no masking rule applies
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
          // Media Preview Container
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
                  
                  // Content text with constraints
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        width: constraints.maxWidth,
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
                  
                  // Show detected data
                  if (_analysisResult != null && !_isScanning) ...[
                    SizedBox(height: 16),
                    _buildDetectedDataWidget(),
                  ],
                  
                  // Image preview for images
                  if (widget.mediaItem['type'] == 'image')
                    Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Container(
                            width: constraints.maxWidth,
                            height: 120,
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
          
          // Risk Score Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isScanning ? 'Analyzing Content...' : 'Risk Score',
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
                    child: _isScanning 
                        ? CircularProgressIndicator(color: primaryColor)
                        : Container(
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
          if (!_isScanning && _analysisResult != null && !isVideoUnsupported)
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
          
          // Content Section - ENSURES ALL RISKS ARE DISPLAYED
          if (!_isScanning && _analysisResult != null)
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isVideoUnsupported)
                      Container(
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
                        child: Column(
                          children: [
                            Icon(Icons.info, color: primaryColor, size: 48),
                            SizedBox(height: 16),
                            Text(
                              _analysisResult!['message'],
                              style: TextStyle(fontSize: 16, color: slate700),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    else ...[
                      if (_showRisksTab)
                        // ENSURE ALL RISKS ARE DISPLAYED
                        ...(_analysisResult!['detectedRisks'] as List<dynamic>?)?.map<Widget>((risk) => Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return Container(
                                    width: constraints.maxWidth,
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
                                                risk.toString(),
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
                                                'Risk identified by regex pattern',
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
                            )).toList() ?? [],
                      if (!_showRisksTab)
                        // ENSURE ALL SUGGESTIONS ARE DISPLAYED
                        ...(_analysisResult!['suggestions'] as List<dynamic>?)?.map<Widget>((suggestion) => Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return Container(
                                    width: constraints.maxWidth,
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
                                            suggestion.toString(),
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
                            )).toList() ?? [],
                    ],
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