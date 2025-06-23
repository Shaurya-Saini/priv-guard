import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'scan_analysis_screen.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<Map<String, dynamic>> _mediaItems = [
    {'id': 1, 'type': 'image', 'thumbnail': Icons.image, 'title': 'Image 1'},
    {
      'id': 2,
      'type': 'text',
      'thumbnail': Icons.text_fields,
      'title': 'Text Post 1'
    },
    {'id': 3, 'type': 'image', 'thumbnail': Icons.image, 'title': 'Image 2'},
    {'id': 4, 'type': 'video', 'thumbnail': Icons.videocam, 'title': 'Video 1'},
    {
      'id': 5,
      'type': 'text',
      'thumbnail': Icons.text_fields,
      'title': 'Text Post 2'
    },
    {'id': 6, 'type': 'image', 'thumbnail': Icons.image, 'title': 'Image 3'},
    {'id': 7, 'type': 'image', 'thumbnail': Icons.image, 'title': 'Image 4'},
    {'id': 8, 'type': 'video', 'thumbnail': Icons.videocam, 'title': 'Video 2'},
    {
      'id': 9,
      'type': 'text',
      'thumbnail': Icons.text_fields,
      'title': 'Text Post 3'
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

  // Fixed text post creation method
  void _showCreateTextPostDialog() {
    final TextEditingController textController = TextEditingController();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
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
                    textController.dispose();
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    final text = textController.text.trim();
                    if (text.isNotEmpty) {
                      // Close dialog first
                      Navigator.of(dialogContext).pop();
                      
                      // Then update state and show snackbar
                      setState(() {
                        _mediaItems.add({
                          'id': DateTime.now().millisecondsSinceEpoch,
                          'type': 'text',
                          'thumbnail': Icons.text_fields,
                          'title': text.length > 20 ? text.substring(0, 20) + '...' : text,
                          'text': text,
                        });
                      });
                      
                      // Show success message
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Text post created successfully'),
                            backgroundColor: Colors.green[600],
                          ),
                        );
                      }
                    }
                    textController.dispose();
                  },
                  child: const Text("Post"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Web-compatible image picker from gallery
  Future<void> _pickImageFromGallery() async {
    try {
      if (kIsWeb) {
        final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
        uploadInput.accept = 'image/*';
        uploadInput.click();

        uploadInput.onChange.listen((e) async {
          final files = uploadInput.files;
          if (files != null && files.isNotEmpty) {
            final file = files[0];
            final reader = html.FileReader();
            
            reader.onLoadEnd.listen((e) {
              if (mounted) {
                setState(() {
                  _mediaItems.add({
                    'id': DateTime.now().millisecondsSinceEpoch,
                    'type': 'image',
                    'thumbnail': Icons.image,
                    'title': file.name,
                    'webImageData': reader.result as Uint8List,
                    'fileName': file.name,
                  });
                });
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Image uploaded successfully'),
                    backgroundColor: Colors.green[600],
                  ),
                );
              }
            });
            
            reader.readAsArrayBuffer(file);
          }
        });
      } else {
        // For mobile platforms, show a message about adding the image_picker dependency
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Image picker requires adding image_picker dependency for mobile platforms'),
              backgroundColor: Colors.orange[600],
              duration: Duration(seconds: 3),
            ),
          );
        }
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

  // Web-compatible image capture simulation (web doesn't support direct camera access easily)
  Future<void> _captureImageFromCamera() async {
    try {
      if (kIsWeb) {
        // For web, we'll redirect to gallery picker since camera access is more complex
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Camera capture not available on web. Please use gallery upload.'),
            backgroundColor: Colors.blue[600],
          ),
        );
        _pickImageFromGallery();
      } else {
        // For mobile platforms, show a message about adding the image_picker dependency
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Camera capture requires adding image_picker dependency for mobile platforms'),
              backgroundColor: Colors.orange[600],
              duration: Duration(seconds: 3),
            ),
          );
        }
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

  // Helper method to build image widget
  Widget _buildImageWidget(Map<String, dynamic> item) {
    if (kIsWeb && item['webImageData'] != null) {
      // For web, display image from Uint8List
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.memory(
          item['webImageData'],
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    } else if (!kIsWeb && item['path'] != null) {
      // For mobile, this would display from file path (requires image_picker)
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          color: Colors.grey[300],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image, color: Colors.grey[600]),
                Text(
                  'Image\n(Add image_picker\ndependency)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 8,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Center(
        child: Icon(
          item['thumbnail'],
          size: 32,
          color: Colors.indigo[400],
        ),
      );
    }
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
                          onLongPress: () => _onLongPress(item),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Stack(
                              children: [
                                // Display actual image if path exists, otherwise show icon
                                item['type'] == 'image' 
                                    ? _buildImageWidget(item)
                                    : Center(
                                        child: Icon(
                                          item['thumbnail'],
                                          size: 32,
                                          color: Colors.indigo[400],
                                        ),
                                      ),
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
