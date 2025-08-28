import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:parkditto/pages/booking_contents/plan.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'reserve/findparking.dart';
import 'reserve/compass_handler.dart'; // Add this import

class ReservePage extends StatefulWidget {
  const ReservePage({super.key});

  @override
  State<ReservePage> createState() => _ReservePageState();
}

class _ReservePageState extends State<ReservePage> {
  LatLng? userLocation;
  double? userHeading;
  final MapController _mapController = MapController();
  List<Map<String, dynamic>> filteredParkingSpots = [];
  CompassHandler _compassHandler = CompassHandler();
  StreamSubscription<double>? _compassSubscription;

  // Map of parking images
  final Map<int, String> parkingImages = {
    1: "assets/pamilihan.png",
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

  // ✅ Sample data with detailed parking information
  final List<Map<String, dynamic>> parkingSpots = [
    {
      "id": 1,
      "name": "Calauan Public Market Parking",
      "location": LatLng(14.1487, 121.3158),
      "address": "Public Market, Calauan, Laguna",
      "totalSpaces": 50,
      "availableSpaces": 10,
      "vehicleTypes": {
        "Car": {"total": 30, "available": 8},
        "Motorcycle": {"total": 20, "available": 2},
      },
      "floors": ["Ground", "2nd Floor"],
      "occupiedSlots": {
        "Car": {
          "Ground": [1, 3, 5, 7, 9, 11, 13, 15],
          "2nd Floor": [2, 4, 6, 8]
        },
        "Motorcycle": {
          "Ground": [1, 3, 5, 7, 9],
          "2nd Floor": [2, 4]
        }
      }
    },
    {
      "id": 2,
      "name": "Calauan Municipal Hall Parking",
      "location": LatLng(14.1492, 121.3163),
      "address": "Municipal Hall Compound, Calauan, Laguna",
      "totalSpaces": 80,
      "availableSpaces": 15,
      "vehicleTypes": {
        "Car": {"total": 50, "available": 10},
        "Mini Truck": {"total": 20, "available": 5},
        "Motorcycle": {"total": 10, "available": 0},
      },
      "floors": ["Ground"],
      "occupiedSlots": {
        "Car": {
          "Ground": [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35, 37, 39, 41, 43, 45, 47, 49]
        },
        "Mini Truck": {
          "Ground": [1, 3, 5, 7, 9, 11, 13, 15]
        },
        "Motorcycle": {
          "Ground": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        }
      }
    },
    {
      "id": 3,
      "name": "Bay Town Center Parking",
      "location": LatLng(14.1833, 121.2833),
      "address": "Bay Town Center, Bay, Laguna",
      "totalSpaces": 40,
      "availableSpaces": 8,
      "vehicleTypes": {
        "Car": {"total": 30, "available": 5},
        "Motorcycle": {"total": 10, "available": 3},
      },
      "floors": ["Ground", "2nd Floor", "3rd Floor"],
      "occupiedSlots": {
        "Car": {
          "Ground": [1, 2, 5, 7, 9],
          "2nd Floor": [2, 4, 6, 8, 10],
          "3rd Floor": [1, 3, 5]
        },
        "Motorcycle": {
          "Ground": [1, 3, 5],
          "2nd Floor": [2, 4],
          "3rd Floor": [1]
        }
      }
    },
    {
      "id": 4,
      "name": "Victoria Plaza Parking",
      "location": LatLng(14.2167, 121.3167),
      "address": "Victoria Plaza, Victoria, Laguna",
      "totalSpaces": 60,
      "availableSpaces": 12,
      "vehicleTypes": {
        "Car": {"total": 40, "available": 8},
        "Mini Truck": {"total": 10, "available": 2},
        "Motorcycle": {"total": 10, "available": 2},
      },
      "floors": ["Ground", "2nd Floor"],
      "occupiedSlots": {
        "Car": {
          "Ground": [1, 3, 5, 7, 9, 11, 13, 15],
          "2nd Floor": [2, 4, 6, 8, 10, 12, 14, 16]
        },
        "Mini Truck": {
          "Ground": [1, 3, 5, 7],
          "2nd Floor": [2, 4]
        },
        "Motorcycle": {
          "Ground": [1, 3, 5, 7],
          "2nd Floor": [2, 4]
        }
      }
    },
    {
      "id": 5,
      "name": "Nagcarlan Town Square Parking",
      "location": LatLng(14.1364, 121.4164),
      "address": "Town Square, Nagcarlan, Laguna",
      "totalSpaces": 35,
      "availableSpaces": 7,
      "vehicleTypes": {
        "Car": {"total": 25, "available": 5},
        "Motorcycle": {"total": 10, "available": 2},
      },
      "floors": ["Ground"],
      "occupiedSlots": {
        "Car": {
          "Ground": [1, 3, 5, 7, 9, 11, 13, 15, 17, 19]
        },
        "Motorcycle": {
          "Ground": [1, 3, 5, 7]
        }
      }
    },
    {
      "id": 6,
      "name": "Rizal Municipal Parking",
      "location": LatLng(14.1083, 121.3917),
      "address": "Municipal Building, Rizal, Laguna",
      "totalSpaces": 45,
      "availableSpaces": 9,
      "vehicleTypes": {
        "Car": {"total": 30, "available": 6},
        "Mini Truck": {"total": 5, "available": 1},
        "Motorcycle": {"total": 10, "available": 2},
      },
      "floors": ["Ground", "2nd Floor"],
      "occupiedSlots": {
        "Car": {
          "Ground": [1, 3, 5, 7, 9, 11, 13],
          "2nd Floor": [2, 4, 6, 8, 10]
        },
        "Mini Truck": {
          "Ground": [1, 3],
          "2nd Floor": [2]
        },
        "Motorcycle": {
          "Ground": [1, 3, 5, 7],
          "2nd Floor": [2, 4]
        }
      }
    },
    {
      "id": 7,
      "name": "Luisiana Public Market Parking",
      "location": LatLng(14.1850, 121.5100),
      "address": "Public Market, Luisiana, Laguna",
      "totalSpaces": 30,
      "availableSpaces": 6,
      "vehicleTypes": {
        "Car": {"total": 20, "available": 4},
        "Motorcycle": {"total": 10, "available": 2},
      },
      "floors": ["Ground"],
      "occupiedSlots": {
        "Car": {
          "Ground": [1, 3, 5, 7, 9, 11, 13, 15]
        },
        "Motorcycle": {
          "Ground": [1, 3, 5, 7]
        }
      }
    },
    {
      "id": 8,
      "name": "Pagsanjan Town Plaza Parking",
      "location": LatLng(14.2731, 121.4547),
      "address": "Town Plaza, Pagsanjan, Laguna",
      "totalSpaces": 75,
      "availableSpaces": 15,
      "vehicleTypes": {
        "Car": {"total": 50, "available": 10},
        "Mini Truck": {"total": 15, "available": 3},
        "Motorcycle": {"total": 10, "available": 2},
      },
      "floors": ["Ground", "2nd Floor", "3rd Floor"],
      "occupiedSlots": {
        "Car": {
          "Ground": [1, 3, 5, 7, 9, 11, 13, 15],
          "2nd Floor": [2, 4, 6, 8, 10, 12, 14, 16],
          "3rd Floor": [1, 3, 5, 7, 9]
        },
        "Mini Truck": {
          "Ground": [1, 3, 5],
          "2nd Floor": [2, 4],
          "3rd Floor": [1]
        },
        "Motorcycle": {
          "Ground": [1, 3, 5],
          "2nd Floor": [2, 4],
          "3rd Floor": [1]
        }
      }
    },
    {
      "id": 9,
      "name": "Cabuyao City Mall Parking",
      "location": LatLng(14.2750, 121.1250),
      "address": "City Mall, Cabuyao, Laguna",
      "totalSpaces": 125,
      "availableSpaces": 25,
      "vehicleTypes": {
        "Car": {"total": 80, "available": 15},
        "Mini Truck": {"total": 25, "available": 5},
        "Motorcycle": {"total": 20, "available": 5},
      },
      "floors": ["Ground", "2nd Floor", "3rd Floor", "4th Floor"],
      "occupiedSlots": {
        "Car": {
          "Ground": [1, 3, 5, 7, 9, 11, 13, 15, 17, 19],
          "2nd Floor": [2, 4, 6, 8, 10, 12, 14, 16, 18, 20],
          "3rd Floor": [1, 3, 5, 7, 9, 11, 13, 15],
          "4th Floor": [2, 4, 6, 8, 10, 12]
        },
        "Mini Truck": {
          "Ground": [1, 3, 5, 7, 9],
          "2nd Floor": [2, 4, 6, 8],
          "3rd Floor": [1, 3, 5],
          "4th Floor": [2, 4]
        },
        "Motorcycle": {
          "Ground": [1, 3, 5, 7, 9],
          "2nd Floor": [2, 4, 6, 8],
          "3rd Floor": [1, 3, 5],
          "4th Floor": [2, 4]
        }
      }
    },
    {
      "id": 10,
      "name": "San Pablo City Parking Complex",
      "location": LatLng(14.0667, 121.3250),
      "address": "City Complex, San Pablo City, Laguna",
      "totalSpaces": 150,
      "availableSpaces": 30,
      "vehicleTypes": {
        "Car": {"total": 100, "available": 20},
        "Mini Truck": {"total": 30, "available": 6},
        "Motorcycle": {"total": 20, "available": 4},
      },
      "floors": ["Ground", "2nd Floor", "3rd Floor"],
      "occupiedSlots": {
        "Car": {
          "Ground": [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29],
          "2nd Floor": [2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30],
          "3rd Floor": [1, 3, 5, 7, 9, 11, 13, 15, 17, 19]
        },
        "Mini Truck": {
          "Ground": [1, 3, 5, 7, 9, 11],
          "2nd Floor": [2, 4, 6, 8, 10, 12],
          "3rd Floor": [1, 3, 5]
        },
        "Motorcycle": {
          "Ground": [1, 3, 5, 7, 9],
          "2nd Floor": [2, 4, 6, 8, 10],
          "3rd Floor": [1, 3]
        }
      }
    },
    {
      "id": 11,
      "name": "Alaminos Town Center Parking",
      "location": LatLng(14.0639, 121.2464),
      "address": "Town Center, Alaminos, Laguna",
      "totalSpaces": 55,
      "availableSpaces": 11,
      "vehicleTypes": {
        "Car": {"total": 40, "available": 8},
        "Motorcycle": {"total": 15, "available": 3},
      },
      "floors": ["Ground", "2nd Floor"],
      "occupiedSlots": {
        "Car": {
          "Ground": [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31],
          "2nd Floor": [2, 4, 6, 8, 10, 12, 14, 16]
        },
        "Motorcycle": {
          "Ground": [1, 3, 5, 7, 9, 11],
          "2nd Floor": [2, 4, 6]
        }
      }
    },
    {
      "id": 12,
      "name": "Sta. Cruz Municipal Parking",
      "location": LatLng(14.2833, 121.4167),
      "address": "Municipal Building, Sta. Cruz, Laguna",
      "totalSpaces": 90,
      "availableSpaces": 18,
      "vehicleTypes": {
        "Car": {"total": 60, "available": 12},
        "Mini Truck": {"total": 20, "available": 4},
        "Motorcycle": {"total": 10, "available": 2},
      },
      "floors": ["Ground", "2nd Floor"],
      "occupiedSlots": {
        "Car": {
          "Ground": [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29],
          "2nd Floor": [2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24]
        },
        "Mini Truck": {
          "Ground": [1, 3, 5, 7, 9, 11, 13],
          "2nd Floor": [2, 4, 6, 8]
        },
        "Motorcycle": {
          "Ground": [1, 3, 5, 7],
          "2nd Floor": [2, 4]
        }
      }
    },
  ];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _startCompassListening();
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    _compassHandler.dispose();
    super.dispose();
  }

  void _startCompassListening() {
    _compassSubscription = _compassHandler.compassStream.listen((heading) {
      if (mounted) {
        setState(() {
          userHeading = heading;
        });
      }
    }, onError: (error) {
      print("Compass error: $error");
      // Fallback to GPS heading if compass is not available
      _getGpsHeading();
    });
  }

  void _getGpsHeading() async {
    try {
      // Try to get heading from GPS if compass is not available
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (position.heading != null && position.heading! > 0 && mounted) {
        setState(() {
          userHeading = position.heading;
        });
      }
    } catch (e) {
      print("Error getting GPS heading: $e");
    }
  }

  // Function to calculate distance between two coordinates in kilometers
  double _calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    double lat1 = start.latitude * pi / 180;
    double lon1 = start.longitude * pi / 180;
    double lat2 = end.latitude * pi / 180;
    double lon2 = end.longitude * pi / 180;

    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a = sin(dLat/2) * sin(dLat/2) +
        cos(lat1) * cos(lat2) * sin(dLon/2) * sin(dLon/2);
    double c = 2 * atan2(sqrt(a), sqrt(1-a));

    return earthRadius * c;
  }

  // Filter parking spots within 5km radius
  void _filterParkingSpots() {
    if (userLocation == null) return;

    setState(() {
      filteredParkingSpots = parkingSpots.where((spot) {
        double distance = _calculateDistance(userLocation!, spot["location"]);
        return distance <= 5.0; // 5km radius
      }).toList();
    });
  }

  Future<void> _getUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Handle permission denial
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        userLocation = LatLng(position.latitude, position.longitude);
      });

      // Try to get heading from GPS if available
      if (position.heading != null && position.heading! > 0) {
        setState(() {
          userHeading = position.heading;
        });
      }

      // Filter parking spots after getting user location
      _filterParkingSpots();

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

  // Helper function to get image for a parking spot
  String _getParkingImage(int parkingId) {
    return parkingImages[parkingId] ?? defaultParkingImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 60, 16, 12),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/search.png",
                      width: 40,
                      height: 40,
                    ),
                    const Text(
                      "Find Parking",
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
                  ]
              ),
            ),

            // ✅ Map with Compass Indicator
            Stack(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  height: 350,
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

                        // Add radius circle around user location
                        if (userLocation != null)
                          CircleLayer(
                            circles: [
                              CircleMarker(
                                point: userLocation!,
                                color: Colors.blue.withOpacity(0.2),
                                borderColor: Colors.blue,
                                borderStrokeWidth: 2,
                                useRadiusInMeter: true,
                                radius: 2000, // 5km radius in meters
                              ),
                            ],
                          ),

                        MarkerLayer(
                          markers: [
                            // Show all parking spots on the map, not just filtered ones
                            ...parkingSpots.map((spot) {
                              return Marker(
                                point: spot["location"],
                                width: 50,
                                height: 50,
                                child: Image.asset(
                                  "assets/logoo.png",
                                  width: 42,
                                  height: 42,
                                ),
                              );
                            }).toList(),

                            // User location marker with rotation
                            if (userLocation != null)
                              Marker(
                                point: userLocation!,
                                width: 50,
                                height: 50,
                                child: Transform.rotate(
                                  angle: userHeading != null
                                      ? (userHeading! * pi / 180)
                                      : 0,
                                  child: Image.asset(
                                    "assets/car_pin.png",
                                    width: 42,
                                    height: 42,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.location_on,
                                        color: Colors.blue,
                                        size: 42,
                                      );
                                    },
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Compass indicator in the top right corner
                if (userHeading != null)
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Column(
                        children: [
                          Transform.rotate(
                            angle: userHeading! * pi / 180,
                            child: Icon(Icons.navigation, color: Colors.red),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "${userHeading!.toStringAsFixed(0)}°",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                "Parking nearby (within 5km)",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3B060A),
                ),
              ),
            ),

            // ✅ List ng cards - using filteredParkingSpots instead of all parkingSpots
            filteredParkingSpots.isEmpty
                ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  userLocation == null
                      ? "Getting your location..."
                      : "No parking spots found within 5km",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF3B060A),
                  ),
                ),
              ),
            )
                : ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              itemCount: filteredParkingSpots.length,
              itemBuilder: (context, index) {
                final spot = filteredParkingSpots[index];
                return _buildParkingCard(spot, context);
              },
            ),
          ],
        ),
      ),

      // Floating action button to re-center the map
      floatingActionButton: userLocation != null
          ? FloatingActionButton(
        onPressed: () {
          _mapController.move(userLocation!, _mapController.camera.zoom);
        },
        backgroundColor: Color(0xFF3B060A),
        child: Icon(Icons.my_location, color: Colors.white),
      )
          : null,
    );
  }

  Widget _buildParkingCard(Map<String, dynamic> spot, BuildContext context) {
    // Calculate distance from user
    double distance = userLocation != null
        ? _calculateDistance(userLocation!, spot["location"])
        : 0.0;

    // Get the specific image for this parking spot
    String imagePath = _getParkingImage(spot["id"]);

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
                    imagePath, // Use the specific image for this parking spot
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to default image if specific image is not found
                      return Image.asset(
                        defaultParkingImage,
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
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
                      "${spot["availableSpaces"]} free spaces",
                      style: const TextStyle(
                        color: Color(0xFF3B060A),
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                if (userLocation != null)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(color: Color(0xFF3B060A), width: 0.8),
                      ),
                      child: Text(
                        "${distance.toStringAsFixed(1)} km away",
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
                      if (userLocation != null)
                        Text(
                          "${distance.toStringAsFixed(1)} km from your location",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      const SizedBox(height: 4),
                      // Show available vehicle types
                      Wrap(
                        spacing: 1,
                        children: (spot["vehicleTypes"] as Map<String, dynamic>).entries.map((entry) {
                          return Chip(
                            label: Text(
                              "${entry.key}: ${entry.value["available"]}",
                              style: const TextStyle(fontSize: 10),
                            ),
                            backgroundColor: const Color(0xFF3B060A),
                            labelStyle: const TextStyle(color: Color(0xFFFDF7D8)),
                            visualDensity: VisualDensity.compact,
                          );
                        }).toList(),
                      ),
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
                            MaterialPageRoute(builder: (context) => FindParkingPage(parkingData: spot)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF02542D),
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text(
                          "Reserve",
                          style: TextStyle(
                              color: Color(0xFFFDF7D8),
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 90,
                      height: 26,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FindParkingPage(parkingData: spot)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF3B060A),
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text(
                          "Book now",
                          style: TextStyle(
                              color: Color(0xFFFDF7D8),
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