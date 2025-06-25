import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:image_picker/image_picker.dart'; // For picking images
import 'dart:io'; // For File on mobile
import 'dart:typed_data'; // For Uint8List on web
import 'scan_analysis_screen.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  // Add an instance of ImagePicker
  final ImagePicker _picker = ImagePicker();

  List<Map<String, dynamic>> _mediaItems = [
    {'id': 1, 'type': 'image', 'thumbnail': Icons.image, 'title': 'Image 1'},
    {
      'id': 2,
      'type': 'text',
      'thumbnail': Icons.text_fields,
      'title': 'Text Post 1',
      'text':
          'This is my first text post! Having a great day and wanted to share my thoughts with everyone.'
    },
    {'id': 3, 'type': 'image', 'thumbnail': Icons.image, 'title': 'Image 2'},
    {'id': 4, 'type': 'video', 'thumbnail': Icons.videocam, 'title': 'Video 1'},
    {
      'id': 5,
      'type': 'text',
      'thumbnail': Icons.text_fields,
      'title': 'Text Post 2',
      'text':
          'Just finished reading an amazing book about Flutter development. The concepts are really fascinating and I can\'t wait to implement them in my next project!'
    },
    {'id': 6, 'type': 'image', 'thumbnail': Icons.image, 'title': 'Image 3'},
    {'id': 7, 'type': 'image', 'thumbnail': Icons.image, 'title': 'Image 4'},
    {'id': 8, 'type': 'video', 'thumbnail': Icons.videocam, 'title': 'Video 2'},
    {
      'id': 9,
      'type': 'text',
      'thumbnail': Icons.text_fields,
      'title': 'Text Post 3',
      'text': 'Beautiful sunset today! 🌅'
    },
    {'id': 10, 'type': 'image', 'thumbnail': Icons.image, 'title': 'Image 5'},
    {'id': 11, 'type': 'image', 'thumbnail': Icons.image, 'title': 'Image 6'},
    {
      'id': 12,
      'type': 'video',
      'thumbnail': Icons.videocam,
      'title': 'Video 3'
    },
  ];

  // Method to show full content view
  void _showFullContent(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.indigo[50],
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Row(
                    children: [
                      Icon(item['thumbnail'], color: Colors.indigo[600]),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item['title'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.indigo[800],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.grey[600]),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),

                // Content
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: _buildFullContentWidget(item),
                  ),
                ),

                // Action buttons
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(16)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ScanAnalysisScreen(mediaItem: item),
                            ),
                          );
                        },
                        icon: Icon(Icons.scanner, size: 18),
                        label: Text('Scan'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo[600],
                          foregroundColor: Colors.white,
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _onLongPress(item);
                        },
                        icon: Icon(Icons.more_horiz, size: 18),
                        label: Text('Options'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.indigo[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper method to build full content widget
  Widget _buildFullContentWidget(Map<String, dynamic> item) {
    switch (item['type']) {
      case 'text':
        return Container(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Text(
                    item['text'] ?? 'No content available',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 16, color: Colors.grey[500]),
                    SizedBox(width: 8),
                    Text(
                      'Posted recently',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );

      case 'image':
        return Container(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                constraints: BoxConstraints(
                  maxHeight: 400,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildImageWidget(item, isFullView: true),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.image, size: 16, color: Colors.grey[500]),
                  SizedBox(width: 8),
                  Text(
                    'Image • ${item['fileName'] ?? 'Unknown file'}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

      case 'video':
        return Container(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.play_circle_outline,
                        size: 64,
                        color: Colors.indigo[600],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Video Preview',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tap to play (video player not implemented)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.videocam, size: 16, color: Colors.grey[500]),
                  SizedBox(width: 8),
                  Text(
                    'Video • Duration: 1:23',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

      default:
        return Container(
          child: Center(
            child: Text(
              'Content type not supported',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        );
    }
  }

  void _onLongPress(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(item['thumbnail'], color: Colors.indigo[600]),
                        SizedBox(width: 12),
                        Text(
                          item['title'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ListTile(
                      leading: Icon(Icons.scanner, color: Colors.indigo[600]),
                      title: Text('Scan for Privacy Risks'),
                      subtitle: Text('Analyze this item before posting'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ScanAnalysisScreen(mediaItem: item),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.delete, color: Colors.red[600]),
                      title: Text('Delete'),
                      subtitle: Text('Remove this item permanently'),
                      onTap: () {
                        Navigator.pop(context);
                        _deleteItem(item);
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteItem(Map<String, dynamic> item) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Delete ${item['title']}?'),
          content: Text('This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Close dialog first
                Navigator.of(dialogContext).pop();

                // Then update state and show snackbar
                setState(() {
                  _mediaItems
                      .removeWhere((element) => element['id'] == item['id']);
                });

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item['title']} deleted'),
                      backgroundColor: Colors.red[600],
                    ),
                  );
                }
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showAddOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Content',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.indigo[100],
                        child: Icon(Icons.add_photo_alternate,
                            color: Colors.indigo[600]),
                      ),
                      title: Text('Upload Media'),
                      subtitle: Text('Choose photos or videos from gallery'),
                      onTap: () {
                        Navigator.pop(context);
                        _pickImageFromGallery();
                      },
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green[100],
                        child: Icon(Icons.camera_alt, color: Colors.green[600]),
                      ),
                      title: Text('Capture Image'),
                      subtitle: Text('Take a photo with camera'),
                      onTap: () {
                        Navigator.pop(context);
                        _captureImageFromCamera();
                      },
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.orange[100],
                        child:
                            Icon(Icons.text_fields, color: Colors.orange[600]),
                      ),
                      title: Text('Create Text Post'),
                      subtitle: Text('Write a text-based post'),
                      onTap: () {
                        Navigator.pop(context);
                        _showCreateTextPostDialog();
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCreateTextPostDialog() {
    final TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Create Text Post"),
          content: TextField(
            controller: textController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: "What's on your mind?",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                // Dispose controller after a short delay to ensure dialog is fully closed
                Future.delayed(Duration(milliseconds: 100), () {
                  textController.dispose();
                });
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final text = textController.text.trim();
                Navigator.of(dialogContext).pop();

                // Dispose controller after a short delay
                Future.delayed(Duration(milliseconds: 100), () {
                  textController.dispose();
                });

                if (text.isNotEmpty) {
                  _addTextPost(text);
                }
              },
              child: const Text("Post"),
            ),
          ],
        );
      },
    );
  }

// Separate method to add text post
  void _addTextPost(String text) {
    if (mounted) {
      setState(() {
        _mediaItems.add({
          'id': DateTime.now().millisecondsSinceEpoch,
          'type': 'text',
          'thumbnail': Icons.text_fields,
          'title': text.length > 20 ? text.substring(0, 20) + '...' : text,
          'text': text,
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Text post created successfully'),
          backgroundColor: Colors.green[600],
        ),
      );
    }
  }

  // MODIFIED: Cross-platform image picker from gallery
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null && mounted) {
        // Read bytes for web, keep path for mobile
        final Uint8List? imageBytes =
            kIsWeb ? await pickedFile.readAsBytes() : null;
        final String? imagePath = kIsWeb ? null : pickedFile.path;

        setState(() {
          _mediaItems.add({
            'id': DateTime.now().millisecondsSinceEpoch,
            'type': 'image',
            'thumbnail': Icons.image,
            'title': pickedFile.name,
            'webImageData': imageBytes, // Will be null on mobile
            'path': imagePath, // Will be null on web
            'fileName': pickedFile.name,
          });
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image uploaded successfully'),
            backgroundColor: Colors.green[600],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: ${e.toString()}'),
            backgroundColor: Colors.red[600],
          ),
        );
      }
    }
  }

  // MODIFIED: Cross-platform image capture from camera
  Future<void> _captureImageFromCamera() async {
    try {
      final XFile? capturedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (capturedFile != null && mounted) {
        // Read bytes for web, keep path for mobile
        final Uint8List? imageBytes =
            kIsWeb ? await capturedFile.readAsBytes() : null;
        final String? imagePath = kIsWeb ? null : capturedFile.path;

        setState(() {
          _mediaItems.add({
            'id': DateTime.now().millisecondsSinceEpoch,
            'type': 'image',
            'thumbnail': Icons.image,
            'title': capturedFile.name,
            'webImageData': imageBytes, // Will be null on mobile
            'path': imagePath, // Will be null on web
            'fileName': capturedFile.name,
          });
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image captured successfully'),
            backgroundColor: Colors.green[600],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to capture image: ${e.toString()}'),
            backgroundColor: Colors.red[600],
          ),
        );
      }
    }
  }

  // MODIFIED: Helper method to build image widget for both platforms
  Widget _buildImageWidget(Map<String, dynamic> item,
      {bool isFullView = false}) {
    // For web, display image from Uint8List if available
    if (kIsWeb && item['webImageData'] != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(isFullView ? 12 : 8),
        child: Image.memory(
          item['webImageData'],
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }
    // For mobile, display from file path if available
    else if (!kIsWeb && item['path'] != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(isFullView ? 12 : 8),
        child: Image.file(
          File(item['path']),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }
    // Fallback for initial dummy data or if something goes wrong
    else {
      return Center(
        child: Icon(
          item['thumbnail'],
          size: isFullView ? 64 : 32,
          color: Colors.indigo[400],
        ),
      );
    }
  }

  // Helper method to build text content widget for grid
  Widget _buildTextContentWidget(Map<String, dynamic> item) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.text_fields,
            size: 16,
            color: Colors.indigo[400],
          ),
          SizedBox(height: 4),
          Expanded(
            child: Text(
              item['text'] ?? 'No content',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[700],
                height: 1.2,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PrivGuard Gallery',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {
              // Notifications functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Grid View
          Expanded(
            child: _mediaItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_library_outlined,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No media yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Add or capture media to get started',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.all(16),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: _mediaItems.length,
                      itemBuilder: (context, index) {
                        final item = _mediaItems[index];
                        return GestureDetector(
                          onTap: () => _showFullContent(
                              item), // Single tap to view content
                          onLongPress: () =>
                              _onLongPress(item), // Long press for options
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Stack(
                              children: [
                                // Display content based on type
                                if (item['type'] == 'image')
                                  _buildImageWidget(item)
                                else if (item['type'] == 'text')
                                  _buildTextContentWidget(item)
                                else
                                  Center(
                                    child: Icon(
                                      item['thumbnail'],
                                      size: 32,
                                      color: Colors.indigo[400],
                                    ),
                                  ),

                                // Video duration overlay
                                if (item['type'] == 'video')
                                  Positioned(
                                    bottom: 4,
                                    right: 4,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        '1:23',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),

          // Footer
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              '© 2024 PrivGuard - Your Privacy Guardian',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddOptions,
        backgroundColor: Colors.indigo[600],
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
