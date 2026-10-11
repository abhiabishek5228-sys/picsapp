
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:picsapp/screens/admin/user/uploadphotoscreen.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:picsapp/provider/homeprovider.dart';
import 'package:picsapp/screens/admin/user/photodetails.dart';
import 'package:picsapp/screens/admin/user/savedscreen.dart';
import 'package:picsapp/services/hive_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  
Future<void> _pickImage() async {
  try {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (!mounted || image == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UploadPhotoScreen(
          image: image,
        ),
      ),
    );
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Image selection failed: $e'),
      ),
    );
  }
}


  final TextEditingController searchController =
      TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();

    return Scaffold(
      backgroundColor: const Color(0xff060A14),

      // APP BAR
      appBar: AppBar(
        backgroundColor: const Color(0xff060A14),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () {},
        ),
        centerTitle: true,
        title: const Text(
          'P I C E S',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xff151B2B),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),

      // UPLOAD BUTTON
floatingActionButton: FloatingActionButton(
  onPressed: _pickImage,
  backgroundColor: const Color(0xff6255F5),
  shape: const CircleBorder(),
  child: const Icon(
    Icons.add,
    color: Colors.white,
    size: 30,
  ),
),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,

      // BOTTOM NAVIGATION
      bottomNavigationBar: _buildBottomNavBar(homeProvider),

      // HOME BODY
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // SEARCH BAR
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff151B2B),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: const Color(0xff30364A),
                  ),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: homeProvider.updateSearch,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Search amazing images...',
                    hintStyle: TextStyle(
                      color: Color(0xff8F94A7),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xff8F94A7),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // CATEGORY CHIPS
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: homeProvider.categories.length,
                  itemBuilder: (context, index) {
                    final category =
                        homeProvider.categories[index];

                    final isSelected =
                        homeProvider.selectedCategory == category;

                    return _buildCategoryChip(
                      category,
                      isSelected,
                      () => homeProvider.changeCategory(category),
                    );
                  },
                ),
              ),

              const SizedBox(height: 15),

              // PHOTO GRID
              Expanded(
                child: homeProvider.filteredPhotos.isEmpty
                    ? const Center(
                        child: Text(
                          'No images found',
                          style: TextStyle(
                            color: Colors.white54,
                          ),
                        ),
                      )
                    : MasonryGridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        itemCount:
                            homeProvider.filteredPhotos.length,
                        itemBuilder: (context, index) {
                          final photo =
                              homeProvider.filteredPhotos[index];

                          return _buildPhotoCard(photo);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // CATEGORY CHIP
  Widget _buildCategoryChip(
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    IconData? icon;

    if (label == 'Nightlife') {
      icon = Icons.nightlight_round;
    } else if (label == 'Sunset') {
      icon = Icons.wb_twilight;
    } else if (label == 'Nature') {
      icon = Icons.eco;
    } else if (label == 'Cars') {
      icon = Icons.directions_car;
    } else if (label == 'Anime') {
      icon = Icons.animation;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xff6255F5)
              : const Color(0xff151B2B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xff6255F5)
                : const Color(0xff30364A),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // PHOTO CARD + HIVE FAVORITE + SNACKBAR
  Widget _buildPhotoCard(PhotoModel photo) {
    return ValueListenableBuilder<Box<bool>>(
      valueListenable: HiveService.favoritesBox.listenable(),
      builder: (context, favoritesBox, child) {
        final isFavorite =
            favoritesBox.get(photo.id, defaultValue: false) ??
                false;

        return Stack(
          children: [
            // PHOTO IMAGE
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PhotoDetailsScreen(
                      photo: photo,
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: photo.height,
                  width: double.infinity,
                  color: const Color(0xff151B2B),
                  child: Image.network(
                    photo.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (
                      context,
                      child,
                      loadingProgress,
                    ) {
                      if (loadingProgress == null) {
                        return child;
                      }

                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xff6255F5),
                        ),
                      );
                    },
                    errorBuilder: (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return const Center(
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.white54,
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // FAVORITE BUTTON
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                color: const Color(0xff151B2B).withValues(
                  alpha: 0.85,
                ),
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: IconButton(
                  onPressed: () async {
                    final messenger =
                        ScaffoldMessenger.of(context);

                    try {
                      if (isFavorite) {
                        await favoritesBox.delete(photo.id);

                        if (!context.mounted) return;

                        messenger.showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Photo removed from favorites',
                            ),
                           backgroundColor: Colors.grey,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else {
                        await favoritesBox.put(photo.id, true);

                        if (!context.mounted) return;

                        messenger.showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Photo successfully saved to favorites! ',
                            ),
                            backgroundColor:Colors.grey,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    } catch (error) {
                      if (!context.mounted) return;

                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            'Something went wrong: $error',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  icon: Icon(
                    isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: isFavorite
                        ? Colors.red
                        : Colors.white,
                    size: 22,
                  ),
                  tooltip: isFavorite
                      ? 'Remove from Favorites'
                      : 'Add to Favorites',
                  constraints: const BoxConstraints(
                    minWidth: 42,
                    minHeight: 42,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // BOTTOM NAVIGATION BAR
  Widget _buildBottomNavBar(HomeProvider provider) {
    return BottomAppBar(
      color: const Color(0xff111726),
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _navItem(
              Icons.home,
              'Home',
              0,
              provider,
            ),
            _navItem(
              Icons.bookmark_border,
              'Saved',
              1,
              provider,
            ),
            const SizedBox(width: 40),
            _navItem(
              Icons.download_outlined,
              'Downloads',
              2,
              provider,
            ),
            _navItem(
              Icons.settings_outlined,
              'Settings',
              3,
              provider,
            ),
          ],
        ),
      ),
    );
  }

  // NAVIGATION ITEM
  Widget _navItem(
    IconData icon,
    String label,
    int index,
    HomeProvider provider,
  ) {
    final isSelected = provider.currentIndex == index;

    return GestureDetector(
      onTap: () {
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SavedScreen(),
            ),
          );
        } else {
          provider.changeBottomNavIndex(index);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected
                ? const Color(0xff6255F5)
                : const Color(0xff8F94A7),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xff6255F5)
                  : const Color(0xff8F94A7),
              fontSize: 11,
              fontWeight: isSelected
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
