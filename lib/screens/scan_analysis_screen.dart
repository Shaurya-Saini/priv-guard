import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Post Types App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PostScreen(),
    );
  }
}

// Enum to define different post types
enum PostType { text, image, video }

// Model class to represent a post
class Post {
  final String id;
  final PostType type;
  final String? textContent;
  final String? imagePath;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.type,
    this.textContent,
    this.imagePath,
    required this.createdAt,
  });
}

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<Post> posts = [];
  final TextEditingController _textController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  int _postIdCounter = 1;

  // Function to handle TEXT posts
  void createTextPost() {
    if (_textController.text.trim().isEmpty) {
      _showMessage('Please enter some text');
      return;
    }

    final newPost = Post(
      id: 'post_${_postIdCounter++}',
      type: PostType.text,
      textContent: _textController.text.trim(),
      createdAt: DateTime.now(),
    );

    setState(() {
      posts.insert(0, newPost); // Add to beginning of list
    });

    _textController.clear();
    _showMessage('Text post created successfully!');
  }

  // Function to handle IMAGE posts
  void createImagePost() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (image != null) {
        final newPost = Post(
          id: 'post_${_postIdCounter++}',
          type: PostType.image,
          imagePath: image.path,
          createdAt: DateTime.now(),
        );

        setState(() {
          posts.insert(0, newPost);
        });

        _showMessage('Image post created successfully!');
      }
    } catch (e) {
      _showMessage('Error picking image: $e');
    }
  }

  // Function to handle VIDEO posts (placeholder)
  void createVideoPost() {
    _showMessage('Video posts will be available in future updates');
  }

  // Function to delete a post
  void deletePost(String postId) {
    setState(() {
      posts.removeWhere((post) => post.id == postId);
    });
    _showMessage('Post deleted');
  }

  // Function to show messages to user
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Function to format date for display
  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts App'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Create Post Section
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Create a New Post',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                
                // Text input field
                TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'What\'s on your mind?',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(12),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                
                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: createTextPost,
                      icon: Icon(Icons.text_fields),
                      label: Text('Text Post'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: createImagePost,
                      icon: Icon(Icons.image),
                      label: Text('Image Post'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: createVideoPost,
                      icon: Icon(Icons.video_library),
                      label: Text('Video Post'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Posts List Section
          Expanded(
            child: posts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.post_add, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No posts yet',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        Text(
                          'Create your first post above!',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Post header with type and delete button
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _getPostTypeColor(post.type),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      _getPostTypeText(post.type),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => deletePost(post.id),
                                    icon: Icon(Icons.delete, color: Colors.red),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              
                              // Post content based on type
                              _buildPostContent(post),
                              
                              SizedBox(height: 12),
                              
                              // Post timestamp
                              Text(
                                'Posted on ${formatDate(post.createdAt)}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Function to build different content based on post type
  Widget _buildPostContent(Post post) {
    switch (post.type) {
      case PostType.text:
        return Text(
          post.textContent ?? '',
          style: TextStyle(fontSize: 16),
        );
      
      case PostType.image:
        if (post.imagePath != null && File(post.imagePath!).existsSync()) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(post.imagePath!),
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          );
        } else {
          return Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.broken_image, size: 64, color: Colors.grey),
          );
        }
      
      case PostType.video:
        return Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.purple[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.purple),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.video_library, size: 64, color: Colors.purple),
              SizedBox(height: 8),
              Text(
                'Video posts will be available\nin future updates',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.purple),
              ),
            ],
          ),
        );
    }
  }

  // Function to get color for different post types
  Color _getPostTypeColor(PostType type) {
    switch (type) {
      case PostType.text:
        return Colors.green;
      case PostType.image:
        return Colors.orange;
      case PostType.video:
        return Colors.purple;
    }
  }

  // Function to get text label for different post types
  String _getPostTypeText(PostType type) {
    switch (type) {
      case PostType.text:
        return 'TEXT';
      case PostType.image:
        return 'IMAGE';
      case PostType.video:
        return 'VIDEO';
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}