import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:picsapp/provider/homeprovider.dart';
import 'package:provider/provider.dart';
import 'package:picsapp/screens/admin/user/photodetails.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

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
      
      // 1. CUSTOM APP BAR
      appBar: AppBar(
        backgroundColor: const Color(0xff060A14),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white, size: 28),
          onPressed: () {},
        ),
        centerTitle: true,
        title: const Text(
          'P I C E S',
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 4),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              decoration: const BoxDecoration(color: Color(0xff151B2B), shape: BoxShape.circle),
              child: IconButton(icon: const Icon(Icons.person, color: Colors.white), onPressed: () {}),
            ),
          ),
        ],
      ),
      
      // 2. FLOATING ACTION BUTTON (Upload)
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xff6255F5),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // 3. BOTTOM NAVIGATION BAR
      bottomNavigationBar: _buildBottomNavBar(homeProvider),

      // 4. MAIN BODY
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff151B2B),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xff30364A)),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) => homeProvider.updateSearch(value),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Search amazing images...',
                    hintStyle: TextStyle(color: Color(0xff8F94A7)),
                    prefixIcon: Icon(Icons.search, color: Color(0xff8F94A7)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Category Chips
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: homeProvider.categories.length,
                  itemBuilder: (context, index) {
                    final category = homeProvider.categories[index];
                    final isSelected = homeProvider.selectedCategory == category;
                    return _buildCategoryChip(category, isSelected, () {
                      homeProvider.changeCategory(category);
                    });
                  },
                ),
              ),

              const SizedBox(height: 15),

              // Staggered Image Grid
              Expanded(
                child: homeProvider.filteredPhotos.isEmpty
                    ? const Center(child: Text('No images found', style: TextStyle(color: Colors.white54)))
                    : MasonryGridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        itemCount: homeProvider.filteredPhotos.length,
                        itemBuilder: (context, index) {
                          return _buildPhotoCard(homeProvider.filteredPhotos[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================== HELPER WIDGETS ==================

  // 1. Custom Category Chip
  Widget _buildCategoryChip(String label, bool isSelected, VoidCallback onTap) {
    IconData? icon;
    if (label == 'Nightlife') icon = Icons.nightlight_round;
    if (label == 'Sunset') icon = Icons.wb_twilight;
    if (label == 'Nature') icon = Icons.eco;
    if (label == 'Cars') icon = Icons.directions_car;
    if (label == 'Anime') icon = Icons.animation;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff6255F5) : const Color(0xff151B2B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xff6255F5) : const Color(0xff30364A)),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 16),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  // 2. Custom Photo Card for the Grid
  Widget _buildPhotoCard(PhotoModel photo) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhotoDetailsScreen(
            photo: photo,
          ),
        ),
      );
    },
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: photo.height,
        color: const Color(0xff151B2B),
        child: Image.network(
          photo.imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }

            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xff6255F5),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
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
  );
}

  // 3. Custom Bottom Navigation Bar
  Widget _buildBottomNavBar(HomeProvider provider) {
    return BottomAppBar(
      color: const Color(0xff111726),
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _navItem(Icons.home, 'Home', 0, provider),
            _navItem(Icons.bookmark_border, 'Saved', 1, provider),
            const SizedBox(width: 40), // Space for FAB
            _navItem(Icons.download_outlined, 'Downloads', 2, provider),
            _navItem(Icons.settings_outlined, 'Settings', 3, provider),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index, HomeProvider provider) {
    final isSelected = provider.currentIndex == index;
    return GestureDetector(
      onTap: () => provider.changeBottomNavIndex(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? const Color(0xff6255F5) : const Color(0xff8F94A7), size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xff6255F5) : const Color(0xff8F94A7),
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}