import 'package:flutter/material.dart';
import 'package:parkditto/mainpage.dart';
import 'package:parkditto/pages/reserve/findparking.dart';
import 'package:parkditto/api/api_service.dart'; // Import the API service
import 'reserve.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Map of parking images
  final Map<int, String> parkingImages = {
    1: "assets/market.png",
    2: "assets/calauan.png",
    3: "assets/bay.png",
    4: "assets/victoria.png",
    5: "assets/parking5.jpg",
    6: "assets/parking6.jpg",
    7: "assets/parking7.jpg",
    8: "assets/parking8.jpg",
    9: "assets/parking9.jpg",
    10: "assets/parking10.jpg",
    11: "assets/parking11.jpg",
    12: "assets/parking12.jpg",
  };

  // Default image if specific image is not available
  final String defaultParkingImage = "assets/parkingbg.png";

  List<Map<String, dynamic>> parkingSpots = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadParkingSpots();
  }

  Future<void> _loadParkingSpots() async {
    try {
      final spots = await ApiService.getParkingSpots();
      setState(() {
        parkingSpots = spots;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load parking spots';
        isLoading = false;
      });
      print("Error loading parking spots: $e");
    }
  }

  // Helper function to get image for a parking spot
  String _getParkingImage(int parkingId) {
    return parkingImages[parkingId] ?? defaultParkingImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Header
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 50, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/search.png",
                      width: 40,
                      height: 40,
                    ),
                    const Text(
                      "Home",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B060A),
                      ),
                    ),
                    Image.asset(
                      "assets/notif.png",
                      width: 40,
                      height: 40,
                    ),
                  ],
                ),
              ),

              // ✅ Parking Nearby Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Parking nearby",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B060A),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        MainPage.of(context)?.onItemTapped(1);
                      },
                      child: const Text(
                        "View Map",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3B060A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ✅ Horizontal list of nearby parking
              SizedBox(
                height: 240,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  itemCount: parkingSpots.length > 5 ? 5 : parkingSpots.length,
                  itemBuilder: (context, index) {
                    final spot = parkingSpots[index];
                    final imagePath = _getParkingImage(spot["id"]);

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FindParkingPage(parkingData: spot)),
                        );
                      },
                      child: Container(
                        width: 266,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFF3B060A), width: 2),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(5)),
                                  child: Image.asset(
                                    imagePath,
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        defaultParkingImage,
                                        height: 150,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                                Positioned(
                                  right: 6,
                                  bottom: 6,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFDF7D8),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      "${spot["available_spaces"]} free spaces",
                                      style: const TextStyle(
                                        color: Color(0xFF3B060A),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    spot["name"],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF3B060A),
                                        fontSize: 16
                                    ),
                                  ),
                                  Text(
                                    spot["address"],
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ✅ Promo Banner
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFFDF7D8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.campaign,
                        color: Color(0xFF3B060A), size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Save up to 25% – Get Monthly or yearly plan!",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3B060A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ✅ Favorite Place
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Favorite Parking Spots",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B060A),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ReservePage()),
                        );
                      },
                      child: const Text(
                        "View Map",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3B060A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ✅ List of favorite spots
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: parkingSpots.length > 6 ? 6 : parkingSpots.length,
                itemBuilder: (context, index) {
                  final spot = parkingSpots[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FindParkingPage(parkingData: spot)),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Color(0xFFD9D9D9).withOpacity(0.3),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.asset(
                            _getParkingImage(spot["id"]),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                defaultParkingImage,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                        title: Text(
                          spot["name"],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3B060A)),
                        ),
                        subtitle: Text(
                          spot["address"],
                          style: const TextStyle(color: Colors.black54),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(0xFFFDF7D8),
                          ),
                          child: Text(
                            "${spot["available_spaces"]} free spaces",
                            style: const TextStyle(
                              color: Color(0xFF3B060A),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}