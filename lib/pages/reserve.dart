import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'reserve/findparking.dart';

class ReservePage extends StatefulWidget {
  const ReservePage({super.key});

  @override
  State<ReservePage> createState() => _ReservePageState();
}

class _ReservePageState extends State<ReservePage> {
  LatLng? userLocation;
  final MapController _mapController = MapController();

  // ✅ Sample data
  final List<Map<String, dynamic>> parkingSpots = [
    {
      "name": "Farmlae Parking",
      "location": LatLng(14.2786, 121.4131),
      "address": "Bae Laguna near Jollibee",
      "spaces": 5,
    },
    {
      "name": "Town Plaza Parking",
      "location": LatLng(14.2810, 121.4150),
      "address": "Town Plaza, Bae Laguna",
      "spaces": 8,
    },
    {
      "name": "Marketplace Parking",
      "location": LatLng(14.2760, 121.4100),
      "address": "Public Market, Bae Laguna",
      "spaces": 3,
    },
    {
      "name": "Riverfront Parking",
      "location": LatLng(14.2800, 121.4080),
      "address": "Riverfront Area, Bae Laguna",
      "spaces": 12,
    },
    {
      "name": "Mall Parking",
      "location": LatLng(14.2750, 121.4160),
      "address": "Shopping Mall, Bae Laguna",
      "spaces": 20,
    },
    {
      "name": "Church Parking",
      "location": LatLng(14.2790, 121.4120),
      "address": "Church Area, Bae Laguna",
      "spaces": 6,
    },
  ];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        userLocation = LatLng(position.latitude, position.longitude);
      });

      if (userLocation != null) {
        _mapController.move(userLocation!, 14);
      } else if (parkingSpots.isNotEmpty) {
        _mapController.move(parkingSpots[0]["location"], 14);
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _openOsmPage() async {
    const url = 'https://www.openstreetmap.org/copyright';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView( // ✅ ginawa nang scrollable ang buong page
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 60, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Icon(Icons.search, color: Color(0xFF3B060A), size: 28),
                  Text(
                    "Find Parking",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3B060A),
                    ),
                  ),
                  Icon(Icons.notifications, color: Color(0xFF3B060A), size: 28),
                ],
              ),
            ),

            // ✅ Map (fixed height para hindi lumobo)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              height: 350, // 🔑 fixed height (same look, scrollable na)
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF3B060A), width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: userLocation ?? (parkingSpots.isNotEmpty
                        ? parkingSpots[0]["location"]
                        : const LatLng(14.2786, 121.4131)),
                    initialZoom: 16,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.parking_app',
                    ),
                    RichAttributionWidget(
                      attributions: [
                        TextSourceAttribution(
                          'OpenStreetMap contributors',
                          onTap: _openOsmPage,
                        ),
                      ],
                    ),
                    MarkerLayer(
                      markers: [
                        if (userLocation != null)
                          Marker(
                            point: userLocation!,
                            width: 50,
                            height: 50,
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.blue,
                              size: 42,
                            ),
                          ),
                        ...parkingSpots.map((spot) {
                          return Marker(
                            point: spot["location"],
                            width: 50,
                            height: 50,
                            child: const Icon(
                              Icons.local_parking,
                              color: Colors.red,
                              size: 42,
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                "Parking nearby",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3B060A),
                ),
              ),
            ),

            // ✅ List ng cards (hindi na Expanded, fixed height + shrinkWrap)
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(), // disable nested scroll
              shrinkWrap: true, // para mag-fit sa scroll parent
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              itemCount: parkingSpots.length,
              itemBuilder: (context, index) {
                final spot = parkingSpots[index];
                return _buildParkingCard(spot);
              },
            ),
          ],
        ),
      ),
    );
  }

  // 🔑 Card builder extracted for clarity
  Widget _buildParkingCard(Map<String, dynamic> spot) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30,left: 16,right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Container(
            height: 140,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFF3B060A), width: 2),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10),bottom: Radius.circular(10)),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  child: Image.asset(
                    "lib/assets/parkingbg.png",
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.local_parking, size: 30, color: Color(0xFF3B060A)),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(color: Color(0xFF3B060A), width: 0.8),
                    ),
                    child: Text(
                      "${spot["spaces"]} free spaces",
                      style: const TextStyle(
                        color: Color(0xFF3B060A),
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(spot["name"],
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3B060A))),
                      const SizedBox(height: 2),
                      Text(spot["address"],
                          style: const TextStyle(
                              fontSize: 14, color: Color(0xFF3B060A))),
                    ],
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 90,
                      height: 26,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FindParkingPage()),
                        );},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text(
                          "Reserve",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 90,
                      height: 26,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF5D2C2C),
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text(
                          "Book now",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
