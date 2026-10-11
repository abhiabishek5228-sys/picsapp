
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPhotoScreen extends StatefulWidget {
  final XFile image;

  const UploadPhotoScreen({
    super.key,
    required this.image,
  });

  @override
  State<UploadPhotoScreen> createState() =>
      _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  final TextEditingController _titleController =
      TextEditingController();

  late Future<Uint8List> _imageBytesFuture;

  String? _selectedCategory;
  bool _isPreparing = false;

  static const Color backgroundColor = Color(0xff060A14);
  static const Color cardColor = Color(0xff151B2B);
  static const Color accentColor = Color(0xff6255F5);

  final List<String> _categories = [
    'Nightlife',
    'Sunset',
    'Nature',
    'Cars',
    'Anime',
  ];

  @override
  void initState() {
    super.initState();
    _imageBytesFuture = widget.image.readAsBytes();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _continueUpload() {
    if (_isPreparing) return;

    final String title = _titleController.text.trim();

    if (title.isEmpty) {
      _showMessage('Please enter a photo title');
      return;
    }

    if (_selectedCategory == null) {
      _showMessage('Please select a category');
      return;
    }

    _showMessage(
      'Details ready! Firebase upload will be connected next.',
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: cardColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.white38,
      ),
      prefixIcon: Icon(
        icon,
        color: Colors.white54,
      ),
      filled: true,
      fillColor: cardColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 17,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xff30364A),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: accentColor,
          width: 1.5,
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Upload Photo',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Preview'),

              const SizedBox(height: 14),

              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: double.infinity,
                  height: 320,
                  color: cardColor,
                  child: FutureBuilder<Uint8List>(
                    future: _imageBytesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: accentColor,
                          ),
                        );
                      }

                      if (snapshot.hasError ||
                          !snapshot.hasData) {
                        return const Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            color: Colors.white54,
                            size: 60,
                          ),
                        );
                      }

                      return Image.memory(
                        snapshot.data!,
                        width: double.infinity,
                        height: 320,
                        fit: BoxFit.cover,
                        errorBuilder: (
                          context,
                          error,
                          stackTrace,
                        ) {
                          return const Center(
                            child: Icon(
                              Icons.broken_image_outlined,
                              color: Colors.white54,
                              size: 60,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 28),

              _sectionTitle('Photo Title'),

              const SizedBox(height: 10),

              TextField(
                controller: _titleController,
                style: const TextStyle(
                  color: Colors.white,
                ),
                textCapitalization:
                    TextCapitalization.sentences,
                decoration: _inputDecoration(
                  hint: 'Enter photo title',
                  icon: Icons.title,
                ),
              ),

              const SizedBox(height: 24),

              _sectionTitle('Choose Category'),

              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: _selectedCategory,
                dropdownColor: cardColor,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
                iconEnabledColor: Colors.white70,
                decoration: _inputDecoration(
                  hint: 'Select a category',
                  icon: Icons.category_outlined,
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: _continueUpload,
                  icon: const Icon(
                    Icons.cloud_upload_outlined,
                  ),
                  label: const Text(
                    'Upload Photo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
