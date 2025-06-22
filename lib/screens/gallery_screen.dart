import 'package:flutter/material.dart';
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
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete ${item['title']}?'),
          content: Text('This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _mediaItems
                      .removeWhere((element) => element['id'] == item['id']);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${item['title']} deleted'),
                    backgroundColor: Colors.red[600],
                  ),
                );
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
                        // Upload media functionality
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
                        // Capture functionality
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
                        // Create text post functionality
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
                                Center(
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
