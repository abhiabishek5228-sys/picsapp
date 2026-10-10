
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:picsapp/provider/homeprovider.dart';
import 'package:picsapp/services/hive_service.dart';

class PhotoDetailsScreen extends StatefulWidget {
  final PhotoModel photo;

  const PhotoDetailsScreen({
    super.key,
    required this.photo,
  });

  @override
  State<PhotoDetailsScreen> createState() =>
      _PhotoDetailsScreenState();
}

class _PhotoDetailsScreenState extends State<PhotoDetailsScreen> {
  bool isDownloading = false;

  bool get isFavorite {
    return HiveService.favoritesBox
            .get(widget.photo.id, defaultValue: false) ??
        false;
  }

  Future<void> toggleFavorite() async {
    final box = HiveService.favoritesBox;
    final photoId = widget.photo.id;

    if (isFavorite) {
      await box.delete(photoId);
    } else {
      await box.put(photoId, true);
    }

    if (!mounted) return;

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite
              ? 'Added to Favorites ❤️'
              : 'Removed from Favorites',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> downloadImage() async {
    try {
      setState(() {
        isDownloading = true;
      });

      final response = await http.get(
        Uri.parse(widget.photo.imageUrl),
      );

      if (response.statusCode != 200) {
        throw Exception('Download failed');
      }

      final directory = await getApplicationDocumentsDirectory();

      final fileName =
          '${widget.photo.id}_${widget.photo.name.replaceAll(' ', '_')}.jpg';

      final file = File('${directory.path}/$fileName');

      await file.writeAsBytes(response.bodyBytes);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image downloaded successfully'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to download image'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isDownloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final photo = widget.photo;

    return Scaffold(
      backgroundColor: const Color(0xff060A14),
      appBar: AppBar(
        backgroundColor: const Color(0xff060A14),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Photo Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Image.network(
                photo.imageUrl,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo name + Favorite icon
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          photo.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff151B2B),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: IconButton(
                          onPressed: toggleFavorite,
                          tooltip: isFavorite
                              ? 'Remove from Favorites'
                              : 'Add to Favorites',
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isFavorite
                                ? Colors.red
                                : const Color(0xffB8BDCE),
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        color: Color(0xff8F94A7),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Uploaded by ${photo.uploadedBy}',
                          style: const TextStyle(
                            color: Color(0xffB8BDCE),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const Icon(
                        Icons.category_outlined,
                        color: Color(0xff8F94A7),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        photo.category,
                        style: const TextStyle(
                          color: Color(0xffB8BDCE),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed:
                          isDownloading ? null : downloadImage,
                      icon: isDownloading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.download),
                      label: Text(
                        isDownloading
                            ? 'Downloading...'
                            : 'Download Image',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff6255F5),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
