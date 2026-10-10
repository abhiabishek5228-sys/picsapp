import 'package:flutter/material.dart';

class PhotoModel {
  final String id;
  final String name;
  final String imageUrl;
  final String category;
  final String uploadedBy;
  final double height;

  PhotoModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.uploadedBy,
    required this.height,
  });
}

class HomeProvider extends ChangeNotifier {
  int currentIndex = 0;
  String selectedCategory = 'All';
  String searchQuery = '';

  final List<PhotoModel> _allPhotos = [
    PhotoModel(
      id: '1',
      name: 'City Lights',
      imageUrl:
          'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=500',
      category: 'Nightlife',
      uploadedBy: 'Alex',
      height: 300,
    ),
    PhotoModel(
      id: '2',
      name: 'Golden Sunset',
      imageUrl:
          'https://images.unsplash.com/photo-1495616811223-4d98c6e9c869?w=500',
      category: 'Sunset',
      uploadedBy: 'David',
      height: 200,
    ),
    PhotoModel(
      id: '3',
      name: 'Mountain View',
      imageUrl:
          'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=500',
      category: 'Nature',
      uploadedBy: 'John',
      height: 350,
    ),
    PhotoModel(
      id: '4',
      name: 'Luxury Ride',
      imageUrl:
          'https://images.unsplash.com/photo-1542282088-fe8426682b8f?w=500',
      category: 'Cars',
      uploadedBy: 'Mike',
      height: 250,
    ),
    PhotoModel(
      id: '5',
      name: 'Green Forest',
      imageUrl:
          'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=500',
      category: 'Nature',
      uploadedBy: 'Chris',
      height: 400,
    ),
    PhotoModel(
      id: '6',
      name: 'Beach View',
      imageUrl:
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=500',
      category: 'Nature',
      uploadedBy: 'Ryan',
      height: 200,
    ),
    PhotoModel(
      id: '7',
      name: 'Night Mountains',
      imageUrl:
          'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=500',
      category: 'Nightlife',
      uploadedBy: 'Sam',
      height: 300,
    ),
    PhotoModel(
      id: '8',
      name: 'Forest',
      imageUrl:
          'https://images.unsplash.com/photo-1493246507139-91e8fad9978e?w=500',
      category: 'Nature',
      uploadedBy: 'Daniel',
      height: 250,
    ),
  ];

  List<String> categories = [
    'All',
    'Nightlife',
    'Sunset',
    'Nature',
    'Cars',
    'Anime',
  ];

  List<PhotoModel> get filteredPhotos {
    return _allPhotos.where((photo) {
      final matchesCategory =
          selectedCategory == 'All' ||
          photo.category == selectedCategory;

      final matchesSearch =
          searchQuery.isEmpty ||
          photo.name.toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) ||
          photo.category.toLowerCase().contains(
                searchQuery.toLowerCase(),
              );

      return matchesCategory && matchesSearch;
    }).toList();
  }

  void changeCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  void updateSearch(String query) {
    searchQuery = query;
    notifyListeners();
  }

  void changeBottomNavIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }
  List<PhotoModel> get allPhotosForFavorites => _allPhotos;
}